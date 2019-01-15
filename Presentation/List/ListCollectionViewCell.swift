//
//  ListCollectionViewCell.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


let cellCornerRadius: CGFloat = 20


final class ListCollectionViewCell: UICollectionViewCell {


    static let identifier = "ListCell"

    let imageView: UIImageView

    let nameLabel: UILabel

    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        nameLabel.backgroundColor = .yellow

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        contentView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(element: ListElement) {
        backgroundColor = .blue
        layer.cornerRadius = cellCornerRadius
        layer.showShadowForCell()
        nameLabel.text = element.title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
}

private extension CALayer {

    func showShadowForCell() {
        shadowOffset = CGSize(width: -2, height: -2)
        shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        shadowOpacity = 1
        shadowRadius = 20
        shouldRasterize = true
    }
}

struct ListElement {
    let imageName: String
    let title: String
    let subtitle: String
    let description: String
}
