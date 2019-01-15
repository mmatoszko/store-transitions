//
//  DetailViewController.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


final class DetailViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = DetailView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
    }

    private func addCloseButton() {
        let button = createCloseButton(with: "close")
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        view.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 20).isActive = true
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
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
