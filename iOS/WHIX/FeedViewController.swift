//
//  SecondViewController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit
import Gemini

enum Resource {
    case image
    case movie
}

extension Resource {
    var images: [UIImage] {
        return resourceNames.compactMap { UIImage(named: $0) }
    }
    
    var urls: [URL] {
        return resourceNames.compactMap(URL.init)
    }
    
    private var resourceNames: [String] {
        switch self {
        case .image:
            return ["building", "food", "japan", "minions", "nature", "people"]
        case .movie:
            return ["https://yt-dash-mse-test.commondatastorage.googleapis.com/media/car-20120827-85.mp4",
                    "https://yt-dash-mse-test.commondatastorage.googleapis.com/media/motion-20120802-85.mp4",
                    "https://yt-dash-mse-test.commondatastorage.googleapis.com/media/oops-20120802-85.mp4"]
        }
    }
}

class FeedViewController: UIViewController, UICollectionViewDelegate {
    
    // Inherite GeminiCollectionView
    @IBOutlet weak var collectionView: GeminiCollectionView! {
        didSet {
            let nib = UINib(nibName: "PlayerCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "PlayerCollectionViewCell")
            collectionView.delegate   = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            
            if #available(iOS 11.0, *) {
                collectionView.contentInsetAdjustmentBehavior = .never
            }
            
            collectionView.gemini
                .cubeAnimation()
                .shadowEffect(.fadeIn)
        }
    }
    
    var movieURLs: [URL] = Resource.movie.urls
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting of UICollectionViewFlowLayout
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            collectionView.collectionViewLayout = layout
//        }
    }
    
}

extension FeedViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
        
        // Pause movie during scrolling
//        collectionView.visibleCells
//            .compactMap { $0 as? PlayerCollectionViewCell }
//            .forEach { $0.playerView.pause() }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        (collectionView.visibleCells.first as? PlayerCollectionViewCell)?.playerView.play()
    }
}

// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCollectionViewCell", for: indexPath) as! PlayerCollectionViewCell
        cell.configure(with: movieURLs[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
