//
//  TableView.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 8.06.22.
//

import UIKit

extension FilesViewController: UICollectionViewDelegate {
    var collectionViewCell: String {
        "cell"
    }

    func setUpCollectionView() {
         filesСollectionView.delegate = self
        filesСollectionView.dataSource  = self
        
        filesСollectionView.register(ElementCollectionViewCell .self, forCellWithReuseIdentifier: ElementCollectionViewCell.id )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleCellTap(indexPath: indexPath)
    }
}

extension FilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 80, height: 80)
    }
}

extension FilesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ElementCollectionViewCell.id, for: indexPath) as? ElementCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let element = elements[indexPath.row]
        collectionViewCell.updateData(element: element)
        
        return collectionViewCell
    }
}

