//
//  ListViewController.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


class ListViewController: UIViewController {

    private var collectionView: ListCollectionView

    private var dataSource: ListDataSource?

    private var listDelegate: ListDelegate?

    var transition: StoreTransition?

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = ListCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        prepareListCollectionView(collectionView: collectionView)
        view = collectionView
        assert(dataSource != nil)
        assert(listDelegate != nil)
        showData(in: collectionView)
    }

    private func prepareListCollectionView(collectionView: ListCollectionView) {
        dataSource = ListDataSource()
        listDelegate = ListDelegate(cellSelectionCallback: { [weak self] indexPath in
            self?.showElement(at: indexPath)
        })
        collectionView.dataSource = dataSource
        collectionView.delegate = listDelegate
        collectionView.backgroundColor = .green
    }

    private func showElement(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCollectionViewCell,
            let currentCellFrame = cell.layer.presentation()?.frame,
            let absoluteFrame = cell.superview?.convert(currentCellFrame, to: nil) else {
                return
        }

        guard let element = dataSource?.elements[indexPath.row] else {
            return
        }
        let viewController = DetailViewController(element: element)

        let cellInformation = StoreTransition.CellInformation(absoluteCellFrame: absoluteFrame, cell: cell)
        let transition = StoreTransition(cellInformation: cellInformation)
        viewController.transitioningDelegate = transition

        viewController.modalPresentationStyle = .custom

        self.transition = transition

        self.present(viewController, animated: true, completion: nil)
    }

    private func showData(in collectionView: ListCollectionView) {
        let elements: [ListElement] = [
            ListElement(imageName: "", title: "", subtitle: "", description: "", color: .yellow),
            ListElement(imageName: "", title: "", subtitle: "", description: "", color: .green),
            ListElement(imageName: "", title: "", subtitle: "", description: "", color: .blue),
        ]
        showElements(elements: elements, in: collectionView)
    }

    private func showElements(elements: [ListElement], in collectionView: ListCollectionView) {
        dataSource?.elements = elements
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
    }

}
