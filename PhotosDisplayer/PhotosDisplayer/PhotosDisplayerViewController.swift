//
//  PhotosDisplayerViewController.swift
//  PhotosDisplayer
//
//  Created by Asaad Jaber on 24/06/2025.
//

import UIKit
import PhotosUI

class PhotosDisplayerViewController: UIViewController {

    @IBOutlet var photosCollectionView: UICollectionView!
    
    var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    var images: [UIImage] = []
    
    enum Section: Int {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.collectionViewLayout = createCompositionalLayout()
        
        createDataSource()
        
        updateInitialSnapshot()
        
        configurePhotoPicker()
    }
    
    var photoPicker: PHPickerViewController!
    
    @IBAction func presentImagePicker(_ sender: UIBarButtonItem) {
        present(photoPicker, animated: true)
    }
    
    func configurePhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
        photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                           heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // 1. Connect the data source to the collection view, 2. Configure dequeuing the collection view cell.
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: photosCollectionView) { collectionView, indexPath, identifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
                fatalError("Could do not dequeue reusable cell, PhotoCell")
            }
                    
            cell.backgroundColor = .magenta.withAlphaComponent(0.13)
            
            cell.photoImageView.image = identifier
            
            return cell
        }
    }
    
    func updateInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        
        snapshot.appendSections([.main])
                
        snapshot.appendItems(images, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PhotosDisplayerViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        images = []
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                let type: NSItemProviderReading.Type = UIImage.self
                itemProvider.loadObject(ofClass: type) { image, error in
                    if let image = image {
                        if !self.images.contains(image as! UIImage) {
                            self.images.append(image as! UIImage)
                            print(self.images.count)
                            self.updateInitialSnapshot()
                        }
                    }
                }
            }
        }
    }
}
