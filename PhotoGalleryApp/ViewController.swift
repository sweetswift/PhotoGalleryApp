//
//  ViewController.swift
//  PhotoGalleryApp
//
//  Created by chungwoolee on 2023/01/02.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    


    var fetcResults: PHFetchResult<PHAsset>?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo Gallery App"
        makeNavigationItem()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 1) / 2, height: 200)
        
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        photoCollectionView.collectionViewLayout = layout
        
        photoCollectionView.dataSource = self
    }
    
    func makeNavigationItem() {
        let photoItem = UIBarButtonItem(image: UIImage(systemName: "photo.on.rectangle"), style: .done, target: self, action: #selector(checkPermission))
        photoItem.tintColor = .black.withAlphaComponent(0.7)
        self.navigationItem.rightBarButtonItem = photoItem
        
        let refreshItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(refresh))
        self.navigationItem.leftBarButtonItem = refreshItem
    }
    
    @objc func checkPermission() {
        if PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .limited {
            DispatchQueue.main.async {
                self.showGallery()
            }
           
            
        }else if PHPhotoLibrary.authorizationStatus() == .denied {
            DispatchQueue.main.async {
                self.showAuthorizationDeniedAlert()
            }
            
        }else if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                self.checkPermission()
            }
            
        }
        
    }
    
    func showAuthorizationDeniedAlert() {
        let alert = UIAlertController(title: "?????? ?????? ????????? ????????? ????????????", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "??????", style: .cancel))
        alert.addAction(UIAlertAction(title: "???????????? ??????", style: .default, handler: { action in
            
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    func showGallery() {
        let libray = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: libray)
        configuration.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
        
        
    }
    
    @objc func refresh() {
        self.photoCollectionView.reloadData()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetcResults?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        if let asset = self.fetcResults?[indexPath.row] {
            cell.loadImage(asset: asset)
            
        }
      
        return cell
    }
    
    
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
      
        let identifiers = results.map{
            $0.assetIdentifier ?? ""
        }
            
        self.fetcResults = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        self.photoCollectionView.reloadData()
      
        
        self.dismiss(animated: true)
    }
    
    
}
