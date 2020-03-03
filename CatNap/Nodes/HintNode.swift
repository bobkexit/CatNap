//
//  HintNode.swift
//  CatNap
//
//  Created by Николай Маторин on 03.03.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class HintNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    var arrowPath: CGPath = {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0.5, y: 65.69))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 1.5))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 38.66))
        bezierPath.addLine(to: CGPoint(x: 257.5, y: 38.66))
        bezierPath.addLine(to: CGPoint(x: 257.5, y: 92.72))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 92.72))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 126.5))
        bezierPath.addLine(to: CGPoint(x: 0.5, y: 65.69))
        bezierPath.close()
        
        return bezierPath.cgPath
    } ()
    
    var shape: SKShapeNode!
    var shapeFillColors: [SKColor] = [.red, .yellow, .orange]
    
    func didMoveToScene() {
        
        isUserInteractionEnabled = true
        
        color = .clear
        
        shape = SKShapeNode(path: arrowPath)
        shape.strokeColor = .gray
        shape.lineWidth = 4
        shape.fillColor = .white
        shape.fillTexture = SKTexture(imageNamed: "wood_tinted")
        shape.alpha = 0.8
        addChild(shape)
        
        let move = SKAction.moveBy(x: -40, y: 0, duration: 1.0)
        let bounce = SKAction.sequence([move, move.reversed()])
        let bounceAction = SKAction.repeat(bounce, count: 3)
        
        shape.run(bounceAction) {
            self.removeFromParent()
        }
    }
    
    func interact() {
        shape.fillColor = randomFillColor()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
    private func randomFillColor() -> SKColor {
        let index = Int.random(min: 0, max: shapeFillColors.count - 1)
        return shapeFillColors[index]
    }
    
}
