//
//  ShoppingMainView.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/08.
//

import UIKit

import SnapKit

final class ShoppingMainView: UIView {
    let searchBar = {
        let view = UISearchBar()
        view.searchBarStyle = .minimal
        view.backgroundColor = .systemGray6
        view.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        view.searchTextField.placeholder = "무엇을 구매하실 건가요?"
        view.searchTextField.leftView = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    let addButton = {
        var config = UIButton.Configuration.gray()
        config.title = "추가"
        config.baseForegroundColor = .black
        let button = UIButton(configuration: config)
        return button
    }()
    let tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.rowHeight = UITableView.automaticDimension
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialAttributes() {

    }

    func initialHierarchy() {
        [searchBar, addButton, tableView].forEach { addSubview($0) }
    }

    func initialLayout() {
        let offset = 8
        let inset = 16

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.height.equalTo(80)
        }

        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.trailing.equalTo(searchBar).inset(inset)
        }

        searchBar.searchTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(addButton.snp.leading).offset(-offset)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(offset*2)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

}
