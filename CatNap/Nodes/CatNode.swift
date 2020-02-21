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
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge | PhysicsCategory.spring
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
    
    func curlAt(_ scenePoint: CGPoint) {
        parent!.physicsBody = nil
        children.forEach { $0.removeFromParent() }
        texture = nil
        color = .clear
        guard let catCurl = SKSpriteNode(fileNamed: "CatCurl")?.childNode(withName: "cat_curl") else { return }
        catCurl.move(toParent: self)
        catCurl.position = CGPoint(x: -30, y: 100)
        
        var localPoint = parent!.convert(scenePoint, from: scene!)
        localPoint.y += frame.size.height/3
        
        let actions: [SKAction] = [
            .move(to: localPoint, duration: 0.66),
            .rotate(toAngle: -parent!.zRotation, duration: 0.5)
        ]
        run(.group(actions))
    }
}
