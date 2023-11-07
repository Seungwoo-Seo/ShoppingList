//
//  ShoppingTableViewCell.swift
//  ShoppingList
//
//  Created by 서승우 on 2023/11/08.
//

import UIKit

import SnapKit

final class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"

    let grayBackgroundView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    let completeButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "checkmark.square.fill")
            default:
                button.configuration?.image = UIImage(systemName: "checkmark.square")
            }
        }
        return button
    }()
    let todoLabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    let likeButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "star.fill")
            default:
                button.configuration?.image = UIImage(systemName: "star")
            }
        }
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialHierarchy()
        initialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialHierarchy() {
        contentView.addSubview(grayBackgroundView)

        [
            completeButton,
            todoLabel,
            likeButton
        ].forEach { grayBackgroundView.addSubview($0) }
    }

    func initialLayout() {
        let offset = 8
        let inset = 8
        grayBackgroundView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset/2)
            make.horizontalEdges.equalToSuperview().inset(inset*2)
        }

        completeButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
            make.leading.equalToSuperview().offset(offset)
        }

        todoLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
            make.leading.equalTo(completeButton.snp.trailing).offset(offset)
        }

        likeButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
            make.leading.equalTo(todoLabel.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().inset(inset)
        }
    }

}
