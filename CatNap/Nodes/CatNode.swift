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
    }
}
