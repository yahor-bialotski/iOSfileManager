//
//  AppModeManager.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 24.08.22.
//

import Foundation

class AppModeManager {
    var appMode: AppMode = .view
    var manager = ElementsManager()
    var delegate: AppModeDelegate?
    
    func changeAppMode(_ mode: AppMode) {
        self.appMode = mode
        self.updateViewForAppMode()
    }
    
    func updateViewForAppMode() {
        switch appMode {
        case .view:
            delegate?.viewMode()
            manager.reloadFolderContent()
        case .edit:
            delegate?.editMode()
        }
    }
}
