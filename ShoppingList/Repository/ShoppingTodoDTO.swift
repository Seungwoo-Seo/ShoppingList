//
//  ShoppingTodoDTO.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/10.
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
