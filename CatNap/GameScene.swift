/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
  static let none:  UInt32 = 0
  static let cat:   UInt32 = 0b1 // 1
  static let block: UInt32 = 0b10 // 2
  static let bed:   UInt32 = 0b100 // 4
  static let edge:  UInt32 = 0b1000 // 8
  static let label: UInt32 = 0b10000 // 16
  static let spring:UInt32 = 0b100000 // 32
  static let hook:  UInt32 = 0b1000000 // 64
}

class GameScene: SKScene {
    
    var bedNode: BedNode!
    var catNode: CatNode!
    var playable = true
    var currentLevel: Int = 0
    
    override func didMove(to view: SKView) {
        isPaused = true
        isPaused = false
        
        setupPhysicsBody()
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        }
        
        bedNode = childNode(withName: "bed") as? BedNode
        catNode = childNode(withName: "//cat_body") as? CatNode
        
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func didSimulatePhysics() {
        if !playable { return }
        if abs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
            lose()
        }
    }
    
    private func setupPhysicsBody() {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        
        let playableRect = CGRect(x: 0, y: playableMargin,
                                  width: size.width, height: size.height - playableMargin * 2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody?.categoryBitMask = PhysicsCategory.edge
    }
    
    private func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    private func newGame() {
        view?.presentScene(GameScene.level(levelNum: currentLevel))
    }
    
    private func lose() {
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        
        inGameMessage(text: "Try again...")
        
        run(.afterDelay(5, runBlock: newGame))
        
        catNode.wakeUp()
    }
    
    private func win() {
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice job!")
        
        run(.afterDelay(5, runBlock: newGame))
        
        catNode.curlAt(bedNode.position)
    }
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .aspectFill
        return scene
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.label | PhysicsCategory.edge {
            let labelNode = contact.bodyA.categoryBitMask == PhysicsCategory.label ? contact.bodyA.node : contact.bodyB.node
            (labelNode as? MessageNode)?.didBounce()
        }
        
        guard playable else { return }
        
        if collision == PhysicsCategory.cat | PhysicsCategory.bed {
            win()
        } else if collision == PhysicsCategory.cat | PhysicsCategory.edge {
            lose()
        }
    }
}
