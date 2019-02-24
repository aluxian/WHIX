//
//  PlayerCollectionViewCell.swift
//  Gemini
//
//  Created by shoheiyokoyama on 2017/07/02.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import Firebase
import Disk
import SDWebImage
import CoreMedia

class PlayerCollectionViewCell: UICollectionViewCell {
    
    lazy var storage = Storage.storage()
    lazy var db = Firestore.firestore()
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    let formatter = DateFormatter()
    
    func configure(with doc: QueryDocumentSnapshot) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = nil
        playerView.alpha = 0
        
        usernameLabel.text = ""
        timestampLabel.text = ""
        avatarView.image = nil
        
        avatarView.layer.cornerRadius = avatarView.frame.height / 2
        avatarView.layer.masksToBounds = true
        
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm"
        
        let contentUrl = doc.data()["content"] as! String
        let gsReference = storage.reference(forURL: contentUrl)
        
        let uid = doc["userid"]
        
        (uid as! DocumentReference).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
            }
            
            let gravatarUrl = snapshot!.data()?["gravatar"]! as! String
            self.avatarView.sd_setImage(with: URL(string: gravatarUrl))
            
            self.usernameLabel.text = "@\(snapshot!.data()?["username"] as! String)"
        }
        
        let timestamp = doc.data()["date"]! as! Timestamp
        timestampLabel.text = "University of Southampton \(formatter.string(from: timestamp.dateValue()))"
        
        if contentUrl.contains(".jpg") {
            if let retrievedData = try? Disk.retrieve(gsReference.fullPath, from: .caches, as: Data.self) {
                self.imageView.image = UIImage(data: retrievedData)
                print("loaded jpg from cache")
                return
            }
        }
        
        if contentUrl.contains(".mp4") {
            if let retrievedData = try? Disk.retrieve(gsReference.fullPath, from: .caches, as: Data.self) {
                print("retrieved mp4 url \(retrievedData != nil)")
                self.playerView.alpha = 1
                self.playerView.setVideoURL(getAVAsset(retrievedData))
                self.playerView.play()
                
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playerView.player!.currentItem, queue: .main) { [weak self] _ in
                    self?.playerView.player!.seek(to: CMTime.zero)
                    self?.playerView.player!.play()
                }
                
                print("loaded mp4 from cache")
                return
            }
        }
        
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
                
                if contentUrl.contains(".jpg") {
                    self.imageView.image = UIImage(data: data!)
                }
                
                if contentUrl.contains(".mp4") {
                    self.playerView.alpha = 1
                    self.playerView.setVideoURL(self.getAVAsset(data!))
                    self.playerView.play()
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playerView.player!.currentItem, queue: .main) { [weak self] _ in
                        self?.playerView.player!.seek(to: CMTime.zero)
                        self?.playerView.player!.play()
                    }
                }
            }
        }
        
    }
    
    func getAVAsset(_ data: Data) -> URL {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).mp4"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        try! data.write(to: fullURL!)
        return fullURL!
    }
    
}
