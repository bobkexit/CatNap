//
//  HookBaseNode.swift
//  CatNap
//
//  Created by Николай Маторин on 26.02.2020.
//  Copyright © 2020 bobkexit. All rights reserved.
//

import SpriteKit

class HookBaseNode: SKSpriteNode, EventListenerNode {
    private var hookNode = SKSpriteNode(imageNamed: "hook")
    private var ropeNode = SKSpriteNode(imageNamed: "rope")
    private var hookJoint: SKPhysicsJointFixed!
    
    var isHooked: Bool { hookJoint != nil }
    
    func didMoveToScene() {
        guard let scene = scene else {
            return
        }
        let ceilingFix = SKPhysicsJointFixed.joint(
            withBodyA: scene.physicsBody!,
            bodyB: physicsBody!,
            anchor: .zero)
        scene.physicsWorld.add(ceilingFix)
        
        ropeNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        ropeNode.zRotation = CGFloat(270).degreesToRadians()
        ropeNode.position = position
        scene.addChild(ropeNode)
        
        hookNode.position = CGPoint(x: position.x,
                                    y: position.y - ropeNode.size.width)
        hookNode.physicsBody = SKPhysicsBody(circleOfRadius: hookNode.size.width/2)
        hookNode.physicsBody!.categoryBitMask = PhysicsCategory.hook
        hookNode.physicsBody!.contactTestBitMask = PhysicsCategory.cat
        hookNode.physicsBody!.collisionBitMask = PhysicsCategory.none
        
        scene.addChild(hookNode)
        
        let hookPosition = CGPoint(x: hookNode.position.x,
                                   y: hookNode.position.y + hookNode.size.height/2)
        let ropeJoint = SKPhysicsJointSpring.joint(
            withBodyA: physicsBody!,
            bodyB: hookNode.physicsBody!,
            anchorA: position,
            anchorB: hookPosition)
        scene.physicsWorld.add(ropeJoint)
        
        let range = SKRange(lowerLimit: 0.0, upperLimit: 0.0)
        let orientConstraint: SKConstraint = .orient(to: hookNode, offset: range)
        ropeNode.constraints = [orientConstraint]
        
        hookNode.physicsBody!.applyImpulse(CGVector(dx: 50, dy: 0))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(catTapped),
            name: CatNode.kCatTappedNotification,
            object: nil)
    }
    
    @objc func catTapped() {
        if isHooked { releaseCat() }
    }
    
    func hookCat(catpPysicsBody: SKPhysicsBody) {
        catpPysicsBody.velocity = CGVector(dx: 0, dy: 0)
        catpPysicsBody.angularVelocity = 0
        
        let pinPoint = CGPoint(x: hookNode.position.x,
                               y: hookNode.position.y + hookNode.size.height/2)
        
        hookJoint = SKPhysicsJointFixed.joint(
            withBodyA: hookNode.physicsBody!,
            bodyB: catpPysicsBody,
            anchor: pinPoint)
        
        scene!.physicsWorld.add(hookJoint)
        
        hookNode.physicsBody!.contactTestBitMask = PhysicsCategory.none
    }
    
    func releaseCat() {
        hookNode.physicsBody!.categoryBitMask = PhysicsCategory.none
        hookNode.physicsBody!.contactTestBitMask = PhysicsCategory.none
        hookJoint.bodyA.node!.zRotation = 0
        hookJoint.bodyB.node!.zRotation = 0
        scene!.physicsWorld.remove(hookJoint)
        hookJoint = nil
    }
}
