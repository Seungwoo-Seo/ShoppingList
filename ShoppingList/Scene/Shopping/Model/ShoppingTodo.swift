//
//  ShoppingTodo.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/09.
//

import Foundation

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
