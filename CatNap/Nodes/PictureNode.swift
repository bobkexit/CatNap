//
//  PictureNode.swift
//  CatNap
//
//  Created by Николай Маторин on 02.03.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class PictureNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let pictureNode = SKSpriteNode(imageNamed: "picture")
        let maskNode = SKSpriteNode(imageNamed: "picture-frame-mask")
        
        let cropeNode = SKCropNode()
        cropeNode.addChild(pictureNode)
        cropeNode.maskNode = maskNode
        addChild(cropeNode)
    }
    
    func interact() {
        isUserInteractionEnabled = false
        physicsBody!.isDynamic = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
