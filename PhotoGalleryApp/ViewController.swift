//
//  ViewController.swift
//  PhotoGalleryApp
//
//  Created by chungwoolee on 2023/01/02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo Gallery App"
        makeNavigationItem()
        
 
    }
    
    func makeNavigationItem() {
        let photoItem = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle"), style: .done, target: self, action: #selector(showGallery))
        photoItem.tintColor = .black.withAlphaComponent(0.7)
        self.navigationItem.rightBarButtonItem = photoItem
        
        let refreshItem  = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(showGallery))
        self.navigationItem.leftBarButtonItem = refreshItem
    }
    
    @objc func showGallery() {
        
    }

    @objc func refresh() {
        
    }

}

