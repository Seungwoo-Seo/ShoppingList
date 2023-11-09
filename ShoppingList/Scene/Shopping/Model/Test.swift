//
//  Test.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/09.
//

import Foundation
import RxDataSources

struct ShoppingTodoSection {
    var items: [Item]
}

extension ShoppingTodoSection: SectionModelType {
    typealias Item = ShoppingTodo

    init(original: ShoppingTodoSection, items: [Item]) {
     self = original
     self.items = items
   }
}
