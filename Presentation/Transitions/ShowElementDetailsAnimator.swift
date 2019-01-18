//
//  ShowElementDetailsAnimator.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit

final class ShowElementDetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let cellInformation: StoreTransition.CellInformation

    private let presentAnimationDuration: TimeInterval
    private let springAnimator: UIViewPropertyAnimator
    private var showTransition: ShowElementDetailsTransition?

    init(cellInformation: StoreTransition.CellInformation) {
        self.cellInformation = cellInformation
        self.springAnimator = UIViewPropertyAnimator(cellInformation: cellInformation)
        self.presentAnimationDuration = springAnimator.duration
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        showTransition = ShowElementDetailsTransition(params: cellInformation,
                                        transitionContext: transitionContext,
                                        baseAnimator: springAnimator)
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        showTransition = nil
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return showTransition!.animator
    }
}

private extension UIViewPropertyAnimator {

    convenience init(cellInformation: StoreTransition.CellInformation) {
        let positionY = cellInformation.absoluteCellFrame.minY
        let distanceToBounce = abs(positionY)
        let screenHeight = UIScreen.main.bounds.height
        let extentToBounce = positionY < 0 ? cellInformation.absoluteCellFrame.height : screenHeight
        let dampFactorInterval: CGFloat = 0.3
        let damping: CGFloat = 1.0 - dampFactorInterval * (distanceToBounce / extentToBounce)

        let minDuration: TimeInterval = 0.5
        let maxDuration: TimeInterval = 0.9
        let duration: TimeInterval = minDuration + (maxDuration - minDuration) * TimeInterval(distanceToBounce / screenHeight)

        let springTiming = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0, dy: 0))
        self.init(duration: duration, timingParameters: springTiming)
    }

}
