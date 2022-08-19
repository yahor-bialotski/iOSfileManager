//
//  foldersListCell.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 1.06.22.
//
//
import UIKit

class FoldersListViewCell: UITableViewCell {
    
    static let id = "FoldersListViewCell"
    
    var label: UILabel!
    var elementImageView: UIImageView!
    
    var addMode: AppMode! = .view
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createElement()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func createElement() {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        
        addSubview(horizontalStack)
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            horizontalStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            horizontalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        ])
        
        let imageView = UIImageView()
        self.elementImageView = imageView
        
        horizontalStack.addArrangedSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)])
        
        let label = UILabel()
        self.label = label
        
        horizontalStack.addArrangedSubview(label)
    }
    
    func updateData(element: Element, isSelected: Bool) {
        updateImage(element: element)
        
        self.backgroundColor = isSelected ? .yellow : .clear
         
        self.label.text = element.name
    }
    
    func updateImage(element: Element) {
        let image: UIImage?
        
        switch element.type {
        case .folder:
            image = UIImage(systemName: "folder")
        case .photo:
            guard let data = try? Data(contentsOf: element.path.absoluteURL) else {
                return
            }
            image = UIImage(data: data)
        }
        self.elementImageView.image = image
    }
    
    func editModeImageSettings(element: Element) {
        elementImageView.image = UIImage(systemName: "checkmark.square.fill")
        
        print("click works")
    }
}
