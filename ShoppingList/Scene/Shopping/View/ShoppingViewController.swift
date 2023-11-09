//
//  ShoppingViewController.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/08.
//

import UIKit

import RealmSwift
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

class ShoppingViewController: UIViewController {
    // MARK: - View
    let mainView = ShoppingMainView()

    // MARK: - ViewModel
    let viewModel = ShoppingViewModel()

    let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        initialAttributes()
        bind()
    }

    func initialAttributes() {
        navigationItem.title = "쇼핑"
        view.backgroundColor = .systemBackground
    }

    func bind() {
        let searchBar = mainView.searchBar
        let addButton = mainView.addButton
        let tableView = mainView.tableView

        let inputItem = PublishRelay<ShoppingTodo>()
        let completeButtonIsSelected = PublishRelay<Bool>()
        let likeButtonIsSelected = PublishRelay<Bool>()


        let itemIsCompleted = PublishRelay<(todo: ShoppingTodo, isSelected: Bool)>()
        let itemIsLiked = PublishRelay<(todo: ShoppingTodo, isLiked: Bool)>()

        // Input
        let input = ShoppingViewModel.Input(
            searchButtonClicked: searchBar.rx.searchButtonClicked,
            addButtonTapped: addButton.rx.tap,
            searchBarText: searchBar.rx.text,
            modelSelected: tableView.rx.modelSelected(ShoppingTodo.self),
            itemSelected: tableView.rx.itemSelected,
            itemDeleted: tableView.rx.itemDeleted,
            itemIsCompleted: itemIsCompleted,
            itemIsLiked: itemIsLiked
        )

        // Output
        let output = viewModel.transform(input: input)
        output.query
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

        output.cellIdentifier
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)

        output.items
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: ShoppingTableViewCell.identifier,
                    cellType: ShoppingTableViewCell.self
                )
            ) { row, element, cell in

                cell.item
                    .bind(with: self) { owner, todo in
                        inputItem.accept(todo)
                    }
                    .disposed(by: cell.disposeBag)

                cell.completeButtonIsSelected
                    .bind(with: self) { owner, bool in
                        completeButtonIsSelected.accept(bool)
                    }
                    .disposed(by: cell.disposeBag)

                cell.completeButtonIsSelected
                    .withLatestFrom(cell.item) { bool, todo in
                        return (todo, bool)
                    }
                    .bind(with: self) { owner, value in
                        itemIsCompleted.accept(value)
                    }
                    .disposed(by: cell.disposeBag)

                cell.likeButtonIsSelected
                    .bind(with: self) { owner, bool in
                        likeButtonIsSelected.accept(bool)
                    }
                    .disposed(by: cell.disposeBag)

                cell.likeButtonIsSelected
                    .withLatestFrom(cell.item) { bool, todo in
                        return (todo, bool)
                    }
                    .bind(with: self) { owner, value in
                        itemIsLiked.accept(value)
                    }
                    .disposed(by: cell.disposeBag)

                cell.item.accept(element)
            }
            .disposed(by: disposeBag)
    }

}
