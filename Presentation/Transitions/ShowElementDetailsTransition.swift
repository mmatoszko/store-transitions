//
//  ShowElementDetailsTransition.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 17/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


final class ShowElementDetailsTransition {

    let animator: UIViewPropertyAnimator

    init(params: StoreTransition.CellInformation,
         transitionContext: UIViewControllerContextTransitioning,
         baseAnimator: UIViewPropertyAnimator) {
        let container = transitionContext.containerView

        let detailView = transitionContext.view(forKey: .to)!
        detailView.translatesAutoresizingMaskIntoConstraints = false
        let initialFrame = params.absoluteCellFrame

        // Temporary container view for animation
        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animatedContainerView)

        let animatedContainerConstraints = [
            animatedContainerView.widthAnchor.constraint(equalToConstant: container.bounds.width),
            animatedContainerView.heightAnchor.constraint(equalToConstant: container.bounds.height),
            animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ]
        NSLayoutConstraint.activate(animatedContainerConstraints)

        let verticalConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: initialFrame.minY)
        verticalConstraint.isActive = true

        animatedContainerView.addSubview(detailView)

        let elementConstraints = [
            detailView.topAnchor.constraint(equalTo: animatedContainerView.topAnchor),
            detailView.centerXAnchor.constraint(equalTo: animatedContainerView.centerXAnchor),
            ]
        NSLayoutConstraint.activate(elementConstraints)


        let widthConstraint = detailView.widthAnchor.constraint(equalToConstant: initialFrame.width)
        let heightConstraint = detailView.heightAnchor.constraint(equalToConstant: initialFrame.height)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])

        detailView.layer.cornerRadius = cellCornerRadius

        // Prepare cell
        params.cell?.isHidden = true
        params.cell?.transform = .identity


        container.layoutIfNeeded()

        func animateContainerBouncingUp() {
            verticalConstraint.constant = 0
            container.layoutIfNeeded()
        }

        func fillUpContainerWithDetailView() {
            widthConstraint.constant = animatedContainerView.bounds.width
            heightConstraint.constant = animatedContainerView.bounds.height
            detailView.layer.cornerRadius = 0
            container.layoutIfNeeded()
        }

        func finalizeAnimation() {
            // Remove temporary `animatedContainerView`
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()

            // Re-add to the top
            container.addSubview(detailView)

            detailView.removeConstraints([widthConstraint, heightConstraint])
            detailView.constraint(in: container)

            let success = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(success)
        }

        baseAnimator.addAnimations {
            animateContainerBouncingUp()
            let expandingAnimation = UIViewPropertyAnimator(duration: baseAnimator.duration * 0.6, curve: .linear) {
                fillUpContainerWithDetailView()
            }
            expandingAnimation.startAnimation()
        }

        baseAnimator.addCompletion { (_) in
            finalizeAnimation()
        }

        self.animator = baseAnimator
    }
}
