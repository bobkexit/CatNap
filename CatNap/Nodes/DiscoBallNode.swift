//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by Николай Маторин on 02.03.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    static private(set) var isDiscoTime = false
    
    private var player: AVPlayer!
    private var video: SKVideoNode!
    private var isDiscoTime: Bool = false {
        didSet {
            DiscoBallNode.isDiscoTime = isDiscoTime
            
            video.isHidden = !isDiscoTime
            if isDiscoTime {
                video.play()
                run(spinAction)
            } else {
                video.pause()
                removeAllActions()
            }
            
            SKTAudio.sharedInstance().playBackgroundMusic(
                isDiscoTime ? "disco-sound.m4a" : "backgroundMusic.mp3"
            )
            
            if isDiscoTime {
                video.run(.wait(forDuration: 5.0)) {
                    self.isDiscoTime = false
                }
            }
        }
    }
    
    private let spinAction: SKAction = .repeatForever(
        .animate(with: [
            SKTexture(imageNamed: "discoball1"),
            SKTexture(imageNamed: "discoball2"),
            SKTexture(imageNamed: "discoball3"),
        ], timePerFrame: 0.2))
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let fileUrl = Bundle.main.url(forResource: "discolights-loop",
                                      withExtension: "mov")!
        
        player = AVPlayer(url: fileUrl)
        
        video = SKVideoNode(avPlayer: player)
        
        video.size = scene!.size
        video.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY)
        video.zPosition = -1
        video.alpha = 0.75
        video.isHidden = true
        video.pause()
        scene!.addChild(video)
        
        video.play()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReachEndOfVideo),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    func interact() {
        if !isDiscoTime {
            isDiscoTime = true
        }
    }
    
    @objc func didReachEndOfVideo() {
        print("rewind!")
        player.currentItem!.seek(to: CMTime.zero) { [weak self] _ in
            self?.player.play()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
