//
//  ScrollViewController.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 15.06.22.
//

import UIKit

class ScrollViewController: UIViewController {
    
    var receivedImageURL: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateImage()
        setUpScrollView()
    }
    
    func updateImage() {
        guard let imageURL = receivedImageURL else { return }
        guard let imageData = try? Data(contentsOf: imageURL.absoluteURL) else { return }
        
        let image = UIImage(data: imageData)
        imageView.image = image
    }
    
    func setUpScrollView() {
        scrollView.delegate = self
    }
}

extension ScrollViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
