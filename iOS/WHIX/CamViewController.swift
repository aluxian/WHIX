//
//  CamViewController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit
import SwiftyCam
import iOSPhotoEditor

class CamViewController: SwiftyCamViewController, PhotoEditorDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func doneEditing(image: UIImage) {
        print("done editing!!!!!!!!!!!!!!!!!!!!!!!")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showEditScreen", sender: image)
        }
    }
    
    func canceledEditing() {
        
    }
    
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton : UIButton!
    @IBOutlet weak var flashButton : UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBAction func onCloseClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        //flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
    
    override func viewDidLoad() {
        videoGravity = .resizeAspectFill
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = false
        allowAutoRotate = false
        audioEnabled = true
        flashMode = .auto
        captureButton.buttonEnabled = false
        videoQuality = .high
        defaultCamera = .rear
        pinchToZoom = false
        swipeToZoom = true
        
        super.viewDidLoad()
        
        captureButton.delegate = self
        
        flipCameraButton.layer.shadowColor = UIColor.black.cgColor
        flipCameraButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        flipCameraButton.layer.shadowRadius = 7
        flipCameraButton.layer.shadowOpacity = 0.5
        
        closeBtn.layer.shadowColor = UIColor.black.cgColor
        closeBtn.layer.shadowRadius = 7
        closeBtn.layer.shadowOpacity = 0.5
        
        flashButton.layer.shadowColor = UIColor.black.cgColor
        flashButton.layer.shadowRadius = 7
        flashButton.layer.shadowOpacity = 0.5
        flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (UIApplication.shared.delegate as! AppDelegate).editFinished {
            (UIApplication.shared.delegate as! AppDelegate).editFinished = false
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue \(segue.identifier)")
        if segue.identifier == "showEditScreen" {
            let vc = segue.destination as! PhotoEditController
            if let sender = sender as? UIImage {
                vc.image = (sender as! UIImage)
            } else if let sender = sender as? URL {
                vc.videoUrl = (sender as! URL)
            } else {
                print("sender not recognised")
            }
        }
    }

}

extension CamViewController: SwiftyCamViewControllerDelegate {
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
//        (UIApplication.shared.delegate as! AppDelegate).takenImage = photo
//        dismiss(animated: false, completion: nil)
        
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController", bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        photoEditor.image = photo

        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }

        present(photoEditor, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
//        let newVC = VideoViewController(videoURL: url)
//        self.present(newVC, animated: true, completion: nil)
        // TODO
        performSegue(withIdentifier: "showEditScreen", sender: url)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
}

// UI Animations
extension CamViewController {
    
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func toggleFlashAnimation() {
        //flashEnabled = !flashEnabled
        if flashMode == .auto {
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        }else if flashMode == .on{
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }else if flashMode == .off{
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        }
    }
}
