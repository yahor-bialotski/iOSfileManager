//
//  Manager.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 8.07.22.
//

import Foundation
import UIKit

class ElementsManager {
    var elements = [Element]()
    var selectedElements = [Element]()
    
    var delegate: ElementsManagerDelegate?
    
    var currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func createNewFolder(name: String) {
        guard let currentFolderDirectoryURL = currentDirectory else { return }
        
        let newFolderPath = currentFolderDirectoryURL.appendingPathComponent(name)
        
        try? FileManager.default.createDirectory(at: newFolderPath,
                                                 withIntermediateDirectories: false,
                                                 attributes: nil)
        reloadFolderContent()
    }
    
    func createImage(_ image: UIImage, name: String) {
        guard let currentDirectory = currentDirectory,
              let dataImage = image.jpegData(compressionQuality: 1) else { return }
        
        let newImagePath = currentDirectory.appendingPathComponent(name)
        
        try? dataImage.write(to: newImagePath)
        
        reloadFolderContent()
    }
    
    func reloadFolderContent() {
        guard let currentDirectory = self.currentDirectory,
              let filesURLs = try? FileManager.default.contentsOfDirectory(at: currentDirectory, includingPropertiesForKeys: nil) else { return }
        
        self.elements = filesURLs.map {
            let name = $0.lastPathComponent
            
            let type: ElementType = name.contains(".png") || name.contains(".jpeg") ? .photo : .folder
            return Element(name: name, path: $0, type: type)
        }
        
        delegate?.reloadData()
    }
}
