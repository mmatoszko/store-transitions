//
//  DetailViewController.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


final class DetailViewController: UIViewController, ZoomOutDelegate {

    private let element: ListElement

    let zoomOutInteractor = ZoomOutInteractor()

    init(element: ListElement) {
        self.element = element
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
        addCloseButtonAction()
        enableZoomOutInteractor()
    }

    private func addCloseButtonAction() {
        guard let detailView = viewIfLoaded as? DetailView,
            let closeButton = detailView.closeButton else {
            assertionFailure("No detail view or close button")
            return
        }
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    private func enableZoomOutInteractor() {
        zoomOutInteractor.zoomOutDelegate = self
        view.addGestureRecognizer(zoomOutInteractor.panGesture)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - ZoomOutDelegate

    func didZoomOut() {
        dismiss(animated: true)
    }

}
