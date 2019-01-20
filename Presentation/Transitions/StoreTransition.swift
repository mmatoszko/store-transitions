//
//  StoreTransition.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


final class StoreTransition: NSObject, UIViewControllerTransitioningDelegate {

    struct CellInformation {
        let absoluteCellFrame: CGRect
        weak var cell: UICollectionViewCell?
    }

    private let cellInformation: CellInformation

    weak var viewController: DetailViewController?

    init(cellInformation: CellInformation, viewController: DetailViewController) {
        self.cellInformation = cellInformation
        self.viewController = viewController
        super.init()
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowElementDetailsAnimator(cellInformation: cellInformation)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CloseElementDetailsAnimator(cellInformation: cellInformation)
    }

}


extension UIView {

    @discardableResult
    func embededInContainerView(view: UIView = UIView(), insets: UIEdgeInsets = .zero) -> UIView {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
            ])
        return view
    }

}
