//
//  PhotoEditController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit
import Firebase
import CoreMedia

class PhotoEditController: UIViewController {
    
    lazy var storage = Storage.storage()
    @IBOutlet weak var progressView: UIProgressView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var functions = Functions.functions(region:"europe-west1")
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var image: UIImage!
    var videoUrl: URL!
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).editFinished = true
        
        progressView.alpha = 0.8
        progressView.progress = 0
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        
        var imgRef: StorageReference! = nil
        var data: Data! = nil
        
        if image != nil {
            imgRef = storage.reference().child(randomString(length: 10) + ".jpg")
            data = image.jpegData(compressionQuality: 0.8)!
        } else {
            imgRef = storage.reference().child(randomString(length: 10) + ".mp4")
            data = try! Data(contentsOf: videoUrl!)
        }
        
        imgRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("errrororororororororo :((((")
                return
            }
            
            if let error = error {
                print(error)
            }
            
            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            
            print(metadata)
            
            // You can also access to download URL after upload.
            let contentUrl = "gs://\(metadata.bucket)/\(metadata.path!)"
            
            self.functions.httpsCallable("post").call([
                "contenturl": contentUrl,
                "username": UserDefaults.standard.string(forKey: "loggedInUsername")!,
                "lat": 0.0,
                "lon": 0.0,
                ]) { (result, error) in
                    if let error = error as NSError? {
                        print(error)
                        return
                    }
                    
                    if let _ = result?.data as? String {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("failed post :/ null")
                    }
            }
        }
            .observe(.progress) { snapshot in
                print("progress \(snapshot.progress!)")
                self.progressView.progress = Float(snapshot.progress!.fractionCompleted)
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func onCloseClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.alpha = 0.0
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
        
        if let image = image {
            imgView.image = image
            imgView.contentMode = .scaleAspectFill
        } else {
            imgView.image = nil
        }
        
        if let url = videoUrl {
            playerView.setVideoURL(url)
            playerView.play()
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerView.player!.currentItem, queue: .main) { [weak self] _ in
                self?.playerView.player!.seek(to: CMTime.zero)
                self?.playerView.player!.play()
            }
        } else {
            playerView.pause()
            // clear playerview
        }
        
        nextBtn.layer.cornerRadius = nextBtn.frame.height / 2
        nextBtn.layer.shadowColor = UIColor.black.cgColor
        nextBtn.layer.shadowRadius = 30
        nextBtn.layer.shadowOpacity = 0.5
    }
    
}
