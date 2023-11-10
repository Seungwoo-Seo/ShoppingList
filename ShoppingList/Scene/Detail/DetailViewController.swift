//
//  DetailViewController.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/09.
//

import UIKit

import SnapKit

final class DetailViewController: UIViewController {

    let label = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(
            ofSize: 17,
            weight: .bold
        )
        return label
    }()

    var dataString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    func initialAttributes() {
        view.backgroundColor = .systemBackground
        label.text = dataString
    }

    func initialHierarchy() {
        view.addSubview(label)
    }

    func initialLayout() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

}
