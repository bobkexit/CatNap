//
//  SpringNode.swift
//  CatNap
//
//  Created by Николай Маторин on 21.02.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class SpringNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        let vector = CGVector(dx: 0, dy: 250)
        let point = CGPoint(x: size.width/2, y: size.height)
        physicsBody?.applyImpulse(vector, at: point)
        let actions: [SKAction] = [.wait(forDuration: 1),
                                   .removeFromParent()]
        run(.sequence(actions))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
