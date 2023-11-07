//
//  ShoppingViewController.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/08.
//

import UIKit

import SnapKit

class ShoppingViewController: UIViewController {
    // MARK: - View
    let mainView = ShoppingMainView()

    // MARK: - Life Cycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialAttributes()
    }

    func initialAttributes() {
        navigationItem.title = "쇼핑"
        view.backgroundColor = .systemBackground
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }

}

extension ShoppingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShoppingTableViewCell.identifier,
            for: indexPath
        ) as? ShoppingTableViewCell

        cell?.todoLabel.text = "하하하하하하하하하ㅏ하하하하"


        return cell ?? UITableViewCell()
    }

}

extension ShoppingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }

}

