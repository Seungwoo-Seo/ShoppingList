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

    let items = BehaviorRelay(
        value: [
            "그립톡 구매하기",
            "사이다 구매",
            "아이패드 케이스 최저가 알아보기",
            "양말"
        ]
    )

    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let addButtonTapped: ControlEvent<Void>
        let searchBarText: ControlProperty<String?>

        let modelSelected: ControlEvent<String>
        let itemSelected: ControlEvent<IndexPath>
    }

    struct Output {
        let query: Observable<String>
        let cellIdentifier: Observable<String>
    }

    func transform(input: Input) -> Output {
        let query = input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchBarText.orEmpty) { _, text in
                return text
            }
            // TODO: Realm 만들어서 검색 구현해야 함


        input.addButtonTapped
            .withLatestFrom(input.searchBarText.orEmpty) { _, text in
                return text
            }
            // TODO: Realm에 업데이트 해줘야 함


        let cellIdentifier = Observable
            .zip(
                input.modelSelected,
                input.itemSelected
            )
            .map { "\($0), \($1)" }
            // TODO: 보여질 VC에 전달할 데이터 만들어서 Output으로 만들기

        return Output(
            query: query,
            cellIdentifier: cellIdentifier
        )
    }

}
