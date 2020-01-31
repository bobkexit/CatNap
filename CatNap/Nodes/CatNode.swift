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
        print("cat added to scene")
    }
}
