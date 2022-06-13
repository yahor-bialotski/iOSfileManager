//
//  ElementCollectionViewCell.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 13.06.22.
//

import UIKit

class ElementCollectionViewCell: UICollectionViewCell {

    static let id = "ElementCollectionViewCell"
    
    var label: UILabel!
    var elementImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createElement()
    }

    func createElement() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 5
         
        addSubview(verticalStack)
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            verticalStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            verticalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
        ])
        
        let imageView = UIImageView()
        self.elementImageView = imageView
        verticalStack.addArrangedSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)])
        
        let label = UILabel()
        self.label = label
        
        verticalStack.addArrangedSubview(label)
    }
    
    func updateData(element: Element) {
        updateImage(element: element)
         
        self.label.text = element.name
    }
    
    func updateImage(element: Element) {
        let image: UIImage?
        
        switch element.type {
        case .folder:
            image = UIImage( systemName: "folder")
        case .photo:
            guard let data = try? Data(contentsOf: element.path.absoluteURL) else {
                return
            }
            image = UIImage(data: data)
        }
        self.elementImageView.image = image
    }
}
