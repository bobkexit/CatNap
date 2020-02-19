//
//  BedNode.swift
//  CatNap
//
//  Created by Николай Маторин on 29.01.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.bed
        physicsBody?.collisionBitMask = PhysicsCategory.none
    }
}
