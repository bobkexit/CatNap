//
//  CatNode.swift
//  CatNap
//
//  Created by Николай Маторин on 29.01.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class CatNode: SKSpriteNode, EventListenerNode {
    
    func didMoveToScene() {
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.cat
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge
        parent!.physicsBody!.contactTestBitMask = PhysicsCategory.bed | PhysicsCategory.edge
    }
    
    func wakeUp() {
        children.forEach { $0.removeFromParent() }
        texture = nil
        color = .clear
        
        guard let catAwake = SKSpriteNode(fileNamed: "CatWakeUp")?.childNode(withName: "cat_awake") else { return }
        catAwake.move(toParent: self)
        catAwake.position = CGPoint(x: -30, y: 100)
    }
}
