//
//  DismissInteractor.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 18/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import Foundation


import UIKit


final class DismissInteractor: UIPercentDrivenInteractiveTransition {

    var interactionInProgress = false

    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        addGestureRecognizer(to: viewController.view)
    }

    private func addGestureRecognizer(to view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }

    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let superview = gestureRecognizer.view?.superview else {
            return
        }
        let translation = gestureRecognizer.translation(in: superview)
        let screenHeight = UIScreen.main.bounds.height
        var progress = (translation.y / screenHeight)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController?.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.15
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }

}
