//
//  ShoppingTodo.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/09.
//

import Foundation

import RealmSwift

class ShoppingTodoDTO: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var isCompleted: Bool
    @Persisted var isLiked: Bool
    @Persisted var ownerId: UUID

    convenience init(
        name: String,
        isCompleted: Bool = false,
        isLiked: Bool = false,
        ownerId: UUID
    ) {
        self.init()
        self.name = name
        self.isCompleted = isCompleted
        self.isLiked = isLiked
        self.ownerId = ownerId
    }

    var toDO: ShoppingTodo {
        return ShoppingTodo(
            name: name,
            isCompleted: isCompleted,
            isLiked: isLiked,
            ownerId: ownerId
        )
    }
}

struct ShoppingTodo {
    var name: String
    var isCompleted: Bool = false
    var isLiked: Bool = false
    let ownerId: UUID

    var toDTO: ShoppingTodoDTO {
        return ShoppingTodoDTO(
            name: name,
            isCompleted: isCompleted,
            isLiked: isLiked,
            ownerId: ownerId
        )
    }
}

class Repository {
    private let realm = try! Realm()

    func addShoppingTodo(_ todo: ShoppingTodo) {
        do {
            try realm.write {
                realm.add(todo.toDTO)
            }
        } catch {
            print("❌ addShoppingTodo")
        }
    }

    func fetchShoppingTodoAll() -> [ShoppingTodo] {
        return realm.objects(ShoppingTodoDTO.self).map { $0.toDO }
    }

    func fetchShoppingTodoDTO(_ todo: ShoppingTodo) -> ShoppingTodoDTO? {
        return realm.objects(ShoppingTodoDTO.self).where {
            $0.ownerId == todo.ownerId
        }.first
    }

    func updateShoppingTodoDTO(
        _ todo: ShoppingTodo,
        isCompleted: Bool
    ) {
        guard let todoDTO = fetchShoppingTodoDTO(todo) else {
            print("ShoppingTodoDTO is nil")
            return
        }

        do {
            try realm.write {
                todoDTO.isCompleted = isCompleted
            }
        } catch {
            print("❌ updateShoppingTodoDTO, isComplete")
        }
    }

    func updateShoppingTodoDTO(
        _ todo: ShoppingTodo,
        isLiked: Bool
    ) {
        guard let todoDTO = fetchShoppingTodoDTO(todo) else {
            print("ShoppingTodoDTO is nil")
            return
        }

        do {
            try realm.write {
                todoDTO.isLiked = isLiked
            }
        } catch {
            print("❌ updateShoppingTodoDTO, isLiked")
        }
    }

    func deleteShoppingTodo(_ todo: ShoppingTodo) {
        guard let todoDTO = fetchShoppingTodoDTO(todo) else {
            print("ShoppingTodoDTO is nil")
            return
        }

        do {
            try realm.write {
                realm.delete(todoDTO)
            }
        } catch {
            print("❌ deleteShoppingTodo")
        }
    }

}
