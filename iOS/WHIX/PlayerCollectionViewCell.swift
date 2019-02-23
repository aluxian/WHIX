//
//  PlayerCollectionViewCell.swift
//  Gemini
//
//  Created by shoheiyokoyama on 2017/07/02.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playerView: PlayerView!

    func configure(with url: URL) {
        playerView.setVideoURL(url)
        playerView.play()
    }
}
