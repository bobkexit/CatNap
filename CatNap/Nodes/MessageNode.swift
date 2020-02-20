//
//  MessageNode.swift
//  CatNap
//
//  Created by Николай Маторин on 19.02.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode {
    
    private var numberOfBounces: Int = 0
    
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        
        text = message
        fontSize = 256.0
        fontColor = .gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = .white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody?.collisionBitMask = PhysicsCategory.edge
        physicsBody?.categoryBitMask = PhysicsCategory.label
        physicsBody?.contactTestBitMask = PhysicsCategory.edge
        physicsBody?.restitution = 0.7
    }
    
    func didBounce() {
        numberOfBounces += 1
  
        if numberOfBounces == 4 {
            run(.removeFromParent())
        }
    }
}
