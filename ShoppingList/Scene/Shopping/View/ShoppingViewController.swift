//
//  ShoppingViewController.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/08.
//

import UIKit

import RxCocoa
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

        // config -> Output
        viewModel.items
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: ShoppingTableViewCell.identifier,
                    cellType: ShoppingTableViewCell.self
                )
            ) { row, element, cell in
                cell.todoLabel.text = "\(element), \(row)"

                // Input Output 패턴을 사용할 때
                // 이 셀 내부에 있는 컴포넌트들의 Input들을 어떻게 처리해줘야하지???? Input Output 패턴을 준수할 때???
                cell.completeButton.rx.tap
                cell.likeButton.rx.tap

            }
            .disposed(by: disposeBag)

        // Input
        let input = ShoppingViewModel.Input(
            searchButtonClicked: searchBar.rx.searchButtonClicked,
            addButtonTapped: addButton.rx.tap,
            searchBarText: searchBar.rx.text,
            modelSelected: tableView.rx.modelSelected(String.self),
            itemSelected: tableView.rx.itemSelected
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
    }

}
