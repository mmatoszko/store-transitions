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
        var makeVisible: (Bool) -> Void
    }

    private let cellInformation: CellInformation

    convenience init?(cell: UICollectionViewCell) {
        guard
            let currentCellFrame = cell.layer.presentation()?.frame,
            let absoluteCellFrame = cell.superview?.convert(currentCellFrame, to: nil) else {
                assertionFailure("Can't get cell's absolute frame")
                return nil
        }
        let cellInformation = CellInformation(
            absoluteCellFrame: absoluteCellFrame,
            makeVisible: { [weak cell] visible in
                cell?.isHidden = !visible
            }
        )
        self.init(cellInformation: cellInformation)
    }

    private init(cellInformation: CellInformation) {
        self.cellInformation = cellInformation
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

    func constraint(in container: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: container.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: container.rightAnchor, constant: insets.right),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: insets.bottom)
            ])
    }

}
