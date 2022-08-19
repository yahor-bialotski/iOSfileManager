//
//  AppMode.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 30.06.22.
//

import Foundation

enum AppMode {
    case view
    case edit
}

enum CellSelection {
    case isSelected
    case notSelected
}

enum DisplayViewMode: String {
    case tableView
    case collectionView
}
