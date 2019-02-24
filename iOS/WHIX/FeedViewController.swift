//
//  SecondViewController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit
import Firebase
import Disk

class FeedViewController: UIViewController, UICollectionViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var db = Firestore.firestore()
    lazy var storage = Storage.storage()
    var docs: [QueryDocumentSnapshot] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.black
        
        db.collection("post").order(by: "date").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.docs = querySnapshot!.documents
                print("new data!")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }

    }
}

// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return docs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("creating cell \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCollectionViewCell", for: indexPath) as! PlayerCollectionViewCell
        cell.configure(with: docs[indexPath.row % docs.count])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("will display \(indexPath.row) play")
        (cell as! PlayerCollectionViewCell).playerView.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("did display \(indexPath.row) pause")
        (cell as! PlayerCollectionViewCell).playerView.pause()
    }
}

extension FeedViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for var indexPath in indexPaths {
            let doc = docs[indexPath.row % docs.count]
            
            let contentUrl = doc.data()["content"] as! String
            let gsReference = storage.reference(forURL: contentUrl)
            
            if !Disk.exists(gsReference.fullPath, in: .caches) {
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                gsReference.getData(maxSize: 15 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        do {
                            try Disk.save(data!, to: .caches, as: gsReference.fullPath)
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }
        }
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
