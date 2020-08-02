//
//  GameScene.swift
//  Project11
//
//  Created by Damnjan Markovic on 31/07/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//


import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var ballimages: [String] = ["daks", "mati", "maks", "damnj"]
    var numberOfRemainingBalls: SKLabelNode!
    
    var ballCounter = 0 {
        didSet {
            numberOfRemainingBalls.text = "Balls: \(ballCounter)"
        }
    }
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var restartButton: SKLabelNode!
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    var box = SKSpriteNode()
    var boxArray = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        setEnvironment()
        
    }
    
    func setEnvironment() {
        
        
        let background = SKSpriteNode(imageNamed: "bckgd")
        background.size = CGSize(width: 2200, height: 1700)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        restartButton = SKLabelNode(fontNamed: "Chalkduster")
        restartButton.text = "Restart"
        restartButton.horizontalAlignmentMode = .left
        restartButton.position = CGPoint(x: 850, y: 640)
        addChild(restartButton)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 850, y: 600)
        addChild(scoreLabel)
        
        numberOfRemainingBalls = SKLabelNode(fontNamed: "Chalkduster")
        ballCounter = 20
        numberOfRemainingBalls.text = "Balls: \(ballCounter)"
        numberOfRemainingBalls.horizontalAlignmentMode = .left
        numberOfRemainingBalls.position = CGPoint(x: 850, y: 560)
        addChild(numberOfRemainingBalls)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 640)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlots(at: CGPoint(x: 128, y: 90), isGood: true)
        makeSlots(at: CGPoint(x: 384, y: 90), isGood: false)
        makeSlots(at: CGPoint(x: 640, y: 90), isGood: true)
        makeSlots(at: CGPoint(x: 896, y: 90), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 90))
        makeBouncer(at: CGPoint(x: 256, y: 90))
        makeBouncer(at: CGPoint(x: 512, y: 90))
        makeBouncer(at: CGPoint(x: 768, y: 90))
        makeBouncer(at: CGPoint(x: 1024, y: 90))
    }
    
    
    
    
    func touchesFunc(location: CGPoint) {
        let objects = nodes(at: location)
        if objects.contains(editLabel) {
            editingMode.toggle()

        } else if objects.contains(restartButton) {
            score = 0
            editingMode = false
            self.removeAllChildren()
            setEnvironment()
            
            
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "obstacle"
                boxArray.append(box)
                addChild(box)

            } else {
    
                let ball = SKSpriteNode(imageNamed: ballimages.randomElement()!)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location

                if location.y > 400 && ballCounter > 0 {
                    ball.name = "ball"
                    ballCounter -= 1
                    numberOfRemainingBalls.text = "Balls: \(ballCounter)"
                    addChild(ball)
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        touchesFunc(location: location)

//        let box = SKSpriteNode(color: .red, size: CGSize(width: 54, height: 64))
//        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
//        box.position = location
//        addChild(box)
    }

    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer1")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
        let spin = SKAction.rotate(byAngle: -.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        bouncer.run(spinForever)
    }
    
    
    func makeSlots(at position: CGPoint, isGood: Bool) {
        
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "glowStarGreen")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "glowStarRed")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroyWithSnow(object: ball)
            score += 1
            ballCounter += 1
            numberOfRemainingBalls.text = "Balls: \(ballCounter)"
        } else if object.name == "bad" {
            destroyWithFire(object: ball)
            score -= 1
        } else if object.name == "obstacle" {
            destroyWithSmoke(object: object)
        }
    }
    
    func destroyWithSmoke(object: SKNode) {
        
        if let fireParticles = SKEmitterNode(fileNamed: "SmokeParticle") {
            fireParticles.position = object.position
            addChild(fireParticles)
        }
        object.removeFromParent()
        
    }
    
    
    func destroyWithFire(object: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = object.position
            addChild(fireParticles)
        }
        object.removeFromParent()
    }
    
    
    func destroyWithSnow(object: SKNode) {
        if let snowParticles = SKEmitterNode(fileNamed: "SnowParticle") {
            snowParticles.position = object.position
            addChild(snowParticles)
        }
        object.removeFromParent()
    }
    
//    func destroyObstacle(obstacle)
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
    
    
    
    
    
}
