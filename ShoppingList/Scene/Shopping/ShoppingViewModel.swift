//
//  ShoppingViewModel.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class ShoppingViewModel {
    let disposeBag = DisposeBag()

    private var todoList: [ShoppingTodo] = []

    private let task = Repository()

    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchBarText: ControlProperty<String?>

        let addButtonTapped: ControlEvent<Void>

        let modelSelected: ControlEvent<ShoppingTodo>
        let itemSelected: ControlEvent<IndexPath>
        let itemDeleted: ControlEvent<IndexPath>

        let itemIsCompleted: PublishRelay<(todo: ShoppingTodo, isSelected: Bool)>
        let itemIsLiked: PublishRelay<(todo: ShoppingTodo, isLiked: Bool)>
    }

    struct Output {
        let cellIdentifier: Observable<String>
        let items: BehaviorRelay<[ShoppingTodo]>
    }

    func transform(input: Input) -> Output {
        let items = BehaviorRelay(value: todoList)

        // 전부 가져오기
        let todoList = task.fetchShoppingTodoAll()
        Observable.of(todoList)
            .subscribe(with: self) { owner, todoList in
                owner.todoList = todoList
                items.accept(owner.todoList)
            }
            .dispose()

        // 추가하기
        input.addButtonTapped
            .withLatestFrom(input.searchBarText.orEmpty) { _, text in
                return text
            }
            .filter { !$0.isEmpty }
            .map { text in
                return ShoppingTodo(
                    name: text,
                    ownerId: UUID()
                )
            }
            .subscribe(with: self) { owner, todo in
                owner.task.addShoppingTodo(todo)
                owner.todoList.append(todo)
                items.accept(owner.todoList)
            }
            .disposed(by: disposeBag)

        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchBarText.orEmpty) { _, text in
                print(text)
                return text
            }
            .bind(with: self) { owner, text in
                print(text)
                owner.todoList = owner.task.fetchShoppingTodoList(text)
                items.accept(owner.todoList)
            }
            .disposed(by: disposeBag)

        input.searchBarText
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .bind(with: self) { owner, text in
                owner.todoList = owner.task.fetchShoppingTodoList(text)
                items.accept(owner.todoList)
            }
            .disposed(by: disposeBag)


        let cellIdentifier = Observable
            .zip(
                input.modelSelected,
                input.itemSelected
            )
            .map { "\($0.name), \($1)" }

        input.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.task.deleteShoppingTodo(owner.todoList[indexPath.row])
                owner.todoList.remove(at: indexPath.row)

                print(owner.todoList)

                items.accept(owner.todoList)
            }
            .disposed(by: disposeBag)



        input.itemIsCompleted
            .bind(with: self) { owner, value in
                if let index = owner.todoList.firstIndex(where: {$0.ownerId == value.todo.ownerId}) {
                    owner.todoList[index].isCompleted = value.isSelected
                    owner.task.updateShoppingTodoDTO(owner.todoList[index], isCompleted: value.isSelected)
                } else {
                    print("❌ 발생할 일이 없음")
                }
            }
            .disposed(by: disposeBag)

        input.itemIsLiked
            .bind(with: self) { owner, value in
                if let index = owner.todoList.firstIndex(where: {$0.ownerId == value.todo.ownerId}) {
                    owner.todoList[index].isLiked = value.isLiked
                    owner.task.updateShoppingTodoDTO(owner.todoList[index], isLiked: value.isLiked)
                } else {
                    print("❌ 발생할 일이 없음")
                }
            }
            .disposed(by: disposeBag)

        return Output(
            cellIdentifier: cellIdentifier,
            items: items
        )
    }

}
