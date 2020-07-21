//
//  ZoomOutInteractor.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 20/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


/** Manages the zoom out process which happens before we use the `UIViewControllerTransitioningDelegate`. */
final class ZoomOutInteractor {

    typealias ZoomOutAction = () -> Void

    var didZoomOut: ZoomOutAction = {}

    private var interactiveStartingPoint: CGPoint?

    private var dismissalAnimator: UIViewPropertyAnimator?

    let panGesture: UIPanGestureRecognizer

    init() {
        self.panGesture = createPanGesture()
        panGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
    }

    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        guard let zoomedOutView = gesture.view else { return }

        let progress = moveProgress(for: gesture)

        switch gesture.state {
        case .began:
            dismissalAnimator = interactiveDismissalAnimator(for: zoomedOutView, progress: progress)

        case .changed:
            dismissalAnimator = interactiveDismissalAnimator(for: zoomedOutView, progress: progress)

            dismissalAnimator?.fractionComplete = progress

            if progress >= 1.0 {
                dismissalAnimator?.stopAnimation(false)
                dismissalAnimator?.addCompletion { [weak self] _ in
                    self?.didZoomOut()
                }
                dismissalAnimator?.finishAnimation(at: .end)
            }

        case .ended, .cancelled:
            guard let dismissalAnimator = dismissalAnimator, progress < 1 else {
                print("No need to animate back")
                cancelDismissal()
                return
            }
            /** Animate back to full screen. */
            gesture.isEnabled = false
            animateBack(dismissalAnimator: dismissalAnimator) { [cancelDismissal = self.cancelDismissal] in
                cancelDismissal()
                gesture.isEnabled = true
            }
        default:
            assertionFailure("Gesture error \(gesture.state.rawValue)")
        }
    }

    /** Calculates the move progress for pan gesture. Move progress is in a range <0; 1>. */
    private func moveProgress(for gesture: UIPanGestureRecognizer) -> CGFloat {
        let startingPoint = startingPointFor(gesture: gesture)

        let currentLocation = gesture.location(in: nil)
        let screenHeight = UIScreen.main.bounds.height
        /** Screen needs to be dragged down by 1/4 in order to be dismissed. */
        let requiredMove = screenHeight / 4
        return (currentLocation.y - startingPoint.y) / requiredMove
    }

    /** Returns a starting point for the animation. */
    private func startingPointFor(gesture: UIPanGestureRecognizer) -> CGPoint {
        if let point = interactiveStartingPoint {
            return point
        } else {
            let startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
            return startingPoint
        }
    }

    /** Returns an interactive dismissal animator. Creates a new one in case it doesn't exist. */
    private func interactiveDismissalAnimator(for view: UIView, progress: CGFloat) -> UIViewPropertyAnimator {
        let targetShrinkScale: CGFloat = 0.85
        let targetCornerRadius: CGFloat = cellCornerRadius

        guard let animator = dismissalAnimator else {
            let newAnimator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                view.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                view.layer.cornerRadius = targetCornerRadius
            })
            newAnimator.pauseAnimation()
            newAnimator.isReversed = false
            newAnimator.fractionComplete = progress
            return newAnimator
        }
        return animator
    }

    /** Animates back the dismissal animator. */
    private func animateBack(dismissalAnimator: UIViewPropertyAnimator, completion: @escaping () -> Void) {
        dismissalAnimator.pauseAnimation()
        dismissalAnimator.isReversed = true

        dismissalAnimator.addCompletion { _ in completion() }
        dismissalAnimator.startAnimation()
    }

    private func cancelDismissal() {
        interactiveStartingPoint = nil
        dismissalAnimator = nil
    }

}

private func createPanGesture() -> UIPanGestureRecognizer {
    let gesture = UIPanGestureRecognizer()
    gesture.maximumNumberOfTouches = 1
    return gesture
}
