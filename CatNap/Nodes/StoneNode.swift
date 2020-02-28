//
//  StoneNode.swift
//  CatNap
//
//  Created by Николай Маторин on 27.02.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class StoneNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    func didMoveToScene() {
        guard let scene = scene else {
            return
        }
        if parent == scene {
            scene.addChild(StoneNode.makeCompoundNode(in: scene))
        }
    }
    
    func interact() {
        isUserInteractionEnabled = false
        let actions: [SKAction] = [
            .playSoundFileNamed("pop.mp3", waitForCompletion: false),
            .removeFromParent()
        ]
        run(.sequence(actions))
    }
    
    static func makeCompoundNode(in scene: SKScene) -> SKNode {
        let compound = StoneNode()
        
        scene.children.filter { $0 is StoneNode }.forEach {
            $0.removeFromParent()
            compound.addChild($0)
        }
        let bodies = compound.children.map {
            SKPhysicsBody(rectangleOf: $0.frame.size, center: $0.position)
        }
        compound.physicsBody = SKPhysicsBody(bodies: bodies)
        compound.physicsBody!.collisionBitMask = PhysicsCategory.edge | PhysicsCategory.cat | PhysicsCategory.block
        compound.physicsBody!.categoryBitMask = PhysicsCategory.block
        compound.isUserInteractionEnabled = true
        compound.zPosition = 1
        
        return compound
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
