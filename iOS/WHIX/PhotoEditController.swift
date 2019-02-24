//
//  PhotoEditController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit
import Firebase

class PhotoEditController: UIViewController {
    
    lazy var storage = Storage.storage()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var functions = Functions.functions(region:"europe-west1")
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    var image: UIImage!
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        let imgRef = storage.reference().child(randomString(length: 10) + ".jpg")
        let data = image.jpegData(compressionQuality: 0.8)!
        let uploadTask = imgRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("errrororororororororo :((((")
                return
            }
            
            if let error = error {
                print(error)
            }
            
            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            
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
                    
                    if let postId = result?.data as? String {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("failed post :/ null")
                    }
            }
        }
        
        uploadTask.enqueue()
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
        imgView.image = image
        nextBtn.layer.cornerRadius = nextBtn.frame.height / 2
        nextBtn.layer.shadowColor = UIColor.black.cgColor
        nextBtn.layer.shadowRadius = 30
        nextBtn.layer.shadowOpacity = 0.5
    }
    
}
