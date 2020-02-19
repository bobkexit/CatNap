//
//  BlockNode.swift
//  CatNap
//
//  Created by Николай Маторин on 19.02.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        let actions: [SKAction] = [
        .playSoundFileNamed("pop.mp3", waitForCompletion: false),
        .scale(to: 0.8, duration: 0.1),
        .removeFromParent()
        ]
        run(.sequence(actions))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("destroy block")
        interact()
    }
}
