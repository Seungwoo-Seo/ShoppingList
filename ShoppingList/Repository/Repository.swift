//
//  Repository.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/10.
//

import Foundation

import RealmSwift

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

    func fetchShoppingTodoList(_ name: String) -> [ShoppingTodo] {
        if name.isEmpty {
            return fetchShoppingTodoAll()
        } else {
            return realm
                .objects(ShoppingTodoDTO.self)
                .where({$0.name.contains(name)})
                .map { $0.toDO }
        }
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
