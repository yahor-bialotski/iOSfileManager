//
//  ViewController.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 1.06.22.
//

import UIKit
import UserNotifications

class FilesViewController: UIViewController {
    var manager = ElementsManager()
    
    @IBOutlet weak var switchViewButton: UISegmentedControl!
    var displayMode: DisplayViewMode = .tableView

    @IBOutlet weak var foldersListTableView: UITableView!
    @IBOutlet weak var filesСollectionView: UICollectionView!
    
    var appMode: AppMode = .view
    
    var notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDisplayViewMode()

        updateViewForAppMode()
        
        setUpTableView()
        setUpCollectionView()
        manager.reloadFolderContent()
        
        notifications.requestNotificationsPermisson()
        notifications.sendLocalNotification()
        notifications.sendAnotherLocalNotification()
    }
    
    private func setUpTableView() {
        foldersListTableView.delegate = self
        foldersListTableView.dataSource = self
        //
        foldersListTableView.register(FoldersListViewCell.classForCoder(),
                                      forCellReuseIdentifier: FoldersListViewCell.id)
    }
    
    // MARK: - Buttons
    
    func changeAppMode(_ mode: AppMode) {
        self.appMode = mode
        self.updateViewForAppMode()
    }
    
    func updateViewForAppMode() {
        switch appMode {
        case .view:
            viewMode()
            manager.reloadFolderContent()
        case .edit:
            editMode()
        }
    }
    
    func viewMode() {
        let editButton = UIBarButtonItem(systemItem: .edit, primaryAction: UIAction(handler: {_ in
            self.changeAppMode(.edit)
        }))
        
        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: menuTitle)
        
        navigationItem.rightBarButtonItems = [editButton, addButton]
    }
    
    func editMode() {
        let cancelButton = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: {_ in
            // viewModel.goBackToViewMode
            self.changeAppMode(.view)
            self.manager.selectedElements.removeAll()
        }))
        
        let delButton = UIBarButtonItem(systemItem: .trash, primaryAction: UIAction(handler: {_ in
            if !self.manager.selectedElements.isEmpty {
                self.deleteAffirmationAlert()
            } else {
                return
            }
        }))
        
        self.navigationItem.rightBarButtonItems = [cancelButton, delButton]
    }
    
    func deleteAffirmationAlert() {
        let alertController = UIAlertController(title: "Delete selected items?",
                                                message: nil,
                                                preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Ok",
                                         style: .default) { _ in
            
            for element in self.manager.selectedElements {
                try? FileManager.default.removeItem(at: element.path)
            }
            
            self.manager.reloadFolderContent()
            self.viewMode()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        present(alertController, animated: true)
    }
    
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
    
    @IBAction func handleViewChangeSwitcher(_ sender: UISegmentedControl) {
        switch switchViewButton.selectedSegmentIndex {
        case 0:
            UserDefaultService.shared.saveDisplayMode(mode: .tableView, key: "key")
            
            tableViewMode()

        case 1:
            UserDefaultService.shared.saveDisplayMode(mode: .collectionView, key: "key")
            
            collectionViewMode()
        default:
            break
        }
    }
    
    func collectionViewMode() {
        switchViewButton.selectedSegmentIndex = 1
        
        foldersListTableView.isHidden = true
        filesСollectionView.isHidden = false
    }
    
    func tableViewMode() {
        switchViewButton.selectedSegmentIndex = 0
        
        filesСollectionView.isHidden = true
        foldersListTableView.isHidden = false
    }
    
    func setUpDisplayViewMode() {
        let mode = UserDefaultService.shared.getDisplayMode(key: "key")
        
        self.displayMode = mode == DisplayViewMode.tableView.rawValue ? .tableView : .collectionView
        
        switch displayMode {
        case .tableView:
            tableViewMode()
        case .collectionView:
            collectionViewMode()
        }
    }
    
    // MARK: - Upload image
    
    func uploadImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
      
    func showNewFolderAlert() {
        let alertController = UIAlertController(title: "New folder",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField()
        
        let createAction = UIAlertAction(title: "Ok",
                                         style: .default) { _ in
            guard let folderName = alertController.textFields?.first?.text, !folderName.isEmpty else { return }
            
            self.manager.createNewFolder(name: folderName)
            self.manager.reloadFolderContent()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - Navigation

extension FilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCellTap(indexPath: indexPath)
    }
    
    func handleCellTap(indexPath: IndexPath) {
        switch appMode {
        case .edit:
            handleCellTapInEditMode(indexPath: indexPath)
        case .view:
            handleCellTapInViewMode(indexPath: indexPath)
        }
    }
    
    func handleCellTapInEditMode(indexPath: IndexPath) {
        let element = manager.elements[indexPath.row]
        
        if let elementIndex = manager.selectedElements.firstIndex(where: { $0.name == element.name }) {
            manager.selectedElements.remove(at: elementIndex)
        }
        else {
            manager.selectedElements.append(element)
        }
        
        manager.reloadFolderContent()
    }
    
    func handleCellTapInViewMode(indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilesVC") as? FilesViewController else { return }
        
        let element = manager.elements[indexPath.row]
        
        switch element.type {
        case .folder:
            viewController.manager.currentDirectory = element.path
            
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case .photo:
            guard let scrollViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "ScrollVC") as? ScrollViewController else { return }
            
            navigationController?.pushViewController(scrollViewController, animated: true)
            scrollViewController.receivedImageURL = element.path
        }
    }
}

// MARK: - Table view

extension FilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = manager.elements[indexPath.row]
        
        switch element.type {
        case .folder, .photo:
            return getDerictoryCell(tableView, element: element)
        }
    }
    
    private func getDerictoryCell(_ tableView: UITableView, element: Element) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: FoldersListViewCell.id) as? FoldersListViewCell else { return UITableViewCell() }
        
        tableViewCell.updateData(element: element, isSelected: manager.selectedElements.contains(where: { $0 == element }))
        return tableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage,
              let imageURL = (info[.imageURL] as? URL)?.lastPathComponent else { return }
        
        manager.createImage(image, name: imageURL)
        
        picker.dismiss(animated: true)
    }
}

extension FilesViewController: ElementsManageDelegate {
    func reloadData() {
        foldersListTableView.reloadData()
        filesСollectionView.reloadData()
    }
}
