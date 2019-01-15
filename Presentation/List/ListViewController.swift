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
            guard let element = self?.dataSource?.elements[indexPath.row] else {
                assertionFailure("can't get selected element")
                return
            }
            let viewController = DetailViewController()
            self?.present(viewController, animated: true, completion: nil)
            print(element)
        })
        collectionView.dataSource = dataSource
        collectionView.delegate = listDelegate
        collectionView.backgroundColor = .green
    }

    func showData(in collectionView: ListCollectionView) {
        let elements: [ListElement] = [
            ListElement(imageName: "", title: "", subtitle: "", description: ""),
            ListElement(imageName: "", title: "", subtitle: "", description: "")
        ]
        showElements(elements: elements, in: collectionView)
    }

    func showElements(elements: [ListElement], in collectionView: ListCollectionView) {
        dataSource?.elements = elements
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }

}
