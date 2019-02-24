//
//  PlayerCollectionViewCell.swift
//  Gemini
//
//  Created by shoheiyokoyama on 2017/07/02.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

class PlayerCollectionViewCell: UICollectionViewCell {
    
    lazy var storage = Storage.storage()
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    func configure(with doc: QueryDocumentSnapshot) {
        let contentUrl = doc.data()["content"] as! String
        let gsReference = storage.reference(forURL: contentUrl)
        
        
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
            }
        }
        
    }
}
