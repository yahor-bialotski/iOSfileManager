//
//  ViewController.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 1.06.22.
//

import UIKit

class FilesViewController: UIViewController {
    
    var elements = [Element]()
    
    @IBOutlet weak var filesСollectionView: UICollectionView!
    
    @IBOutlet weak var foldersListTableView: UITableView!
    
    var currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: menuTitle)
        
        setUpTableView()
        reloadFolderContent()
        
        setUpCollectionView()
    }
    
    private func setUpTableView() {
        foldersListTableView.delegate = self
        foldersListTableView.dataSource = self
        
        foldersListTableView.register(FoldersListViewCell.classForCoder(),
                                      forCellReuseIdentifier: FoldersListViewCell.id)
    }
    
    // MARK: - Buttons
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Create folder", image: UIImage(systemName: "folder.fill"), handler: { (_) in
                self.showNewFolderAlert()
            }),
            UIAction(title: "Add image", image: UIImage(systemName: "bus.fill"), handler: { (_) in
                self.uploadImage()
            })
        ]
    }
    
    var menuTitle: UIMenu {
        return UIMenu(title: "Choose action", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    // MARK: - Upload image
    
    func uploadImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    func createImage(_ image: UIImage, name: String) {
        guard let currentDirectory = currentDirectory,
              let dataImage = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        let newImagePath = currentDirectory.appendingPathComponent(name)
        
        try? dataImage.write(to: newImagePath)
        
        reloadFolderContent()
    }
      
    func showNewFolderAlert() {
        let alertController = UIAlertController(title: "New folder",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField()
        
        let createAction = UIAlertAction(title: "Ok",
                                         style: .default) { _ in
            guard let folderName = alertController.textFields?.first?.text, !folderName.isEmpty else { return }
            
            self.createNewFolder(name: folderName)
            self.reloadFolderContent()
        }
         
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        present(alertController, animated: true)
    }
    
    func createNewFolder(name: String) {
        guard let currentFolderDirectoryURL = FileManager.default.urls(for: .documentDirectory,
                                                                       in: .userDomainMask).first else { return }
        
        let newFolderPath = currentFolderDirectoryURL.appendingPathComponent(name)
        
        try? FileManager.default.createDirectory(at: newFolderPath,
                                                 withIntermediateDirectories: false,
                                                 attributes: nil)
        print(currentFolderDirectoryURL)
    }
    
    private func reloadFolderContent() {
        guard let currentDirectory = self.currentDirectory,
              let filesURLs = try? FileManager.default.contentsOfDirectory(at: currentDirectory, includingPropertiesForKeys: nil) else { return }
        
        self.elements = filesURLs.map {
            let name = $0.lastPathComponent
        
        let type: ElementType = name.contains(".png") || name.contains(".jpeg") ? .photo : .folder
            return Element(name: name, path: $0, type: type)
        }
        
        foldersListTableView.reloadData()
        filesСollectionView.reloadData()
    }  
}
// MARK: - Nagigation

extension FilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCellTap(indexPath: indexPath)
    }
    
    func handleCellTap(indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilesVC") as? FilesViewController else {
            return
        }
        
        let element = elements[indexPath.row]
        viewController.currentDirectory = element.path
         
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - Table view

extension FilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        switch element.type {
        case .folder, .photo:
            return getDeictoryCell(tableView, element: element)
        }
    }
    
    private func getDeictoryCell(_ tableView: UITableView, element: Element) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: FoldersListViewCell.id) as? FoldersListViewCell else {
            return UITableViewCell()
        }
        
        tableViewCell.updateData(element: element)
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            50
    }
}

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage,
              let imageURL = (info[.imageURL] as? URL)?.lastPathComponent else {
            return
        }
        
        createImage(image, name: imageURL)
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
 
