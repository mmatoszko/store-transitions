//
//  DetailViewController.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


final class DetailViewController: UIViewController {

    private let element: ListElement

    let zoomOutInteractor = ZoomOutInteractor()

    init(element: ListElement) {
        self.element = element
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = DetailView()
        view.backgroundColor = element.color
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButtonAction()
        configureZoomOutInteractor()
    }

    private func addCloseButtonAction() {
        guard let detailView = viewIfLoaded as? DetailView,
            let closeButton = detailView.closeButton else {
            assertionFailure("No detail view or close button")
            return
        }
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    private func configureZoomOutInteractor() {
        zoomOutInteractor.didZoomOut = { [weak self] in
            self?.dismiss(animated: true)
        }
        view.addGestureRecognizer(zoomOutInteractor.panGesture)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
