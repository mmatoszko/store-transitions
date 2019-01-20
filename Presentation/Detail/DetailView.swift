//
//  DetailView.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


final class DetailView: UIView {

    weak var closeButton: UIButton?

    init() {
        super.init(frame: .zero)
        addCloseButton()
    }

    private func addCloseButton() {
        let button = createCloseButton(with: "close")
        addSubview(button)
        button.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        rightAnchor.constraint(equalTo: button.rightAnchor, constant: 20).isActive = true
        self.closeButton = button
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private func createCloseButton(with text: String) -> UIButton {
    let button = UIButton(type: .custom)
    button.layer.cornerRadius = 10
    button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.backgroundColor = .gray
    return button
}
