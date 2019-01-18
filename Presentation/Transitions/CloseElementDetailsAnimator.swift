//
//  CloseElementDetailsAnimator.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


final class CloseElementDetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let cellInformation: StoreTransition.CellInformation

    init(cellInformation: StoreTransition.CellInformation) {
        self.cellInformation = cellInformation
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let detailViewController = transitionContext.viewController(forKey: .from) as? DetailViewController,
            let detailView = transitionContext.view(forKey: .from) else {
                return
        }
        detailView.translatesAutoresizingMaskIntoConstraints = false

        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false

        container.removeConstraints(container.constraints)

        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(detailView)

        // Element fills inside animated container view
        detailView.embededInContainerView(view: animatedContainerView)

        animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: detailView.frame.width)
        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: detailView.frame.height)

        NSLayoutConstraint.activate([animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint])

        container.layoutIfNeeded()

        func animateBackToPlace() {
            // Back to identity
            detailView.transform = .identity
            animatedContainerTopConstraint.constant = self.cellInformation.absoluteCellFrame.minY
            animatedContainerWidthConstraint.constant = self.cellInformation.absoluteCellFrame.width
            animatedContainerHeightConstraint.constant = self.cellInformation.absoluteCellFrame.height
            detailView.layer.cornerRadius = cellCornerRadius
            container.layoutIfNeeded()
        }

        func finalizeAnimation() {
            let success = !transitionContext.transitionWasCancelled
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            if success {
                detailView.removeFromSuperview()
                self.cellInformation.cell?.isHidden = false
            } else {
                // Remove temporary fixes if not success!
                container.removeConstraints(container.constraints)

                container.addSubview(detailView)
                detailView.embededInContainerView(view: container)
            }
            transitionContext.completeTransition(success)
        }
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        animateBackToPlace()
        }) { (finished) in
            finalizeAnimation()
        }
    }
}
