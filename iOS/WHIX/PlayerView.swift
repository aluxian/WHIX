//
//  PlayerView.swift
//  Gemini
//
//  Created by shoheiyokoyama on 2017/07/02.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

final class PlayerView: UIView {
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        return playerLayer.player
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    func setVideoURL(_ url: URL) {
        let playerItem = AVPlayerItem(asset: AVURLAsset(url: url))
        playerLayer.player = AVPlayer(playerItem: playerItem)
        
        // Register as an observer of the player item's status property
        var observer: NSKeyValueObservation? = nil
        
        print("setting status listener")
        observer = playerItem.observe(\.status, options:  [.new, .old], changeHandler: { (playerItem, change) in
            print("got player item status \(playerItem.status.rawValue)")
            print(playerItem.error)
            if playerItem.status == .readyToPlay {
                print("ready")
                self.playerLayer.player!.play()
                observer?.invalidate()
            }
        })
    }
    
//    func clearVideo() {
//        playerLayer.player = nil
//    }
    
    func play() {
        player!.play()
    }
    
    func pause() {
        player?.pause()
    }

}
