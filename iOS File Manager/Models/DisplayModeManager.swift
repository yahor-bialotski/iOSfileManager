//
//  DisplayModeManager.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 23.08.22.
//

import Foundation

class DisplayModeManager {
    var delegate: DisplayModeDelegate?
    var displayMode: DisplayViewMode = .tableView
    
    func setUpDisplayViewMode() {
        let mode = UserDefaultService.shared.getDisplayMode(key: "key")
        
        self.displayMode = mode == DisplayViewMode.tableView.rawValue ? .tableView : .collectionView
        
        switch displayMode {
        case .tableView:
            delegate?.tableViewMode()
        case .collectionView:
            delegate?.collectionViewMode()
        }
    }
}
