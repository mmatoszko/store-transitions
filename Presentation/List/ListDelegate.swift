//
//  ListDelegate.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 15/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit


class ListDelegate: NSObject, UICollectionViewDelegateFlowLayout {

    typealias CellSelectionCallback = (IndexPath) -> Void

    private let cellSelectionCallback: CellSelectionCallback

    init(cellSelectionCallback: @escaping CellSelectionCallback) {
        self.cellSelectionCallback = cellSelectionCallback
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelectionCallback(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // not everyone likes the magic numbers, but they fit well in this use case
        let width = UIScreen.main.bounds.width - 50
        let height = UIScreen.main.bounds.height / 1.75
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }

}
