//
//  GameScene.swift
//  flappyclone
//
//  Created by HuangMing on 2017/4/20.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var backGroundNode = SKSpriteNode()

    var gameOver = true
    var gameStart = false
    var pipeMaking = Timer()
    var intervalTime = Timer()
    var deletePipe = Timer()
    var score = 0
    var scoreLabel = SKLabelNode()
    
    
    enum collisionType: UInt32 {
        case bird = 1
        case object = 2
        case scoreGap = 4
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == collisionType.scoreGap.rawValue || contact.bodyB.categoryBitMask == collisionType.scoreGap.rawValue {
            print("contact Begin")
            
        } else {
            
            gameOver = true
            
            if gameOver == true {
                
                print("Game Over!")
                
                
                
                pipeMaking.invalidate()
                
                intervalTime.invalidate()
                
                deletePipe.invalidate()
                
                self.removeAllChildren()
                
                setUpGame()
                
                gameStart = false
                
                
                
            }
        }
        

        
        
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == collisionType.scoreGap.rawValue || contact.bodyB.categoryBitMask == collisionType.scoreGap.rawValue {
            print("contact End")
            score += 1
            scoreLabel.text = "Your Score = \(score)"
            
            

        }
    }
    @objc func deletingTimeInterval() {
        deletePipe = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(deletingPipe), userInfo: nil, repeats: true)
    }
    @objc func deletingPipe() {
        
       
    }
    
    @objc func makingPipe() {
        
        
        let movepipe = SKAction.move(by: CGVector(dx: -2 * self.frame.width ,dy: 0), duration: TimeInterval(10))
        
        let gapHeight = bird.size.height * 3
        let moveAmount = CGFloat(arc4random_uniform(UInt32(self.frame.height * 2 / 3))) - self.frame.height / 3
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe = SKSpriteNode(texture: pipeTexture)
        pipe.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight + moveAmount)
        pipe.run(movepipe)
        pipe.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.contactTestBitMask = collisionType.object.rawValue
        pipe.physicsBody?.collisionBitMask = collisionType.object.rawValue
        pipe.physicsBody?.categoryBitMask = collisionType.object.rawValue
        pipe.name = "pipe"
        self.addChild(pipe)
        
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture2.size().height / 2 - gapHeight + moveAmount)
        pipe2.run(movepipe)
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture2.size())
        pipe2.physicsBody?.isDynamic = false
        pipe2.physicsBody?.contactTestBitMask = collisionType.object.rawValue
        pipe2.physicsBody?.collisionBitMask = collisionType.object.rawValue
        pipe2.physicsBody?.categoryBitMask = collisionType.object.rawValue
        pipe2.name = "pipe2"
        self.addChild(pipe2)
        
        let scoreGap = SKSpriteNode()
        scoreGap.name = "Score Gap"
        scoreGap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + moveAmount)
        scoreGap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        
        scoreGap.run(movepipe)
        scoreGap.physicsBody?.isDynamic = false
        
        scoreGap.physicsBody?.contactTestBitMask = collisionType.bird.rawValue
        scoreGap.physicsBody?.categoryBitMask = collisionType.scoreGap.rawValue
        scoreGap.physicsBody?.collisionBitMask = collisionType.scoreGap.rawValue
        
        self.addChild(scoreGap)
        
        
        print(moveAmount)

        
        
    }
    
    func setUpGame() {
        
        scoreLabel.text = "Your Score = \(score)"
        let backGround = SKTexture(imageNamed: "bg.png")
        
        let backGroundAnimation = SKAction.move(by: CGVector(dx: -backGround.size().width,dy: 0), duration: 10)
        let backGroundAnimation2 = SKAction.move(by: CGVector(dx: backGround.size().width,dy: 0), duration: 0)
        let makeBackGroundAnimation = SKAction.repeatForever(SKAction.sequence([backGroundAnimation, backGroundAnimation2]))
        
        var i:CGFloat = 0
        
        while i < 2 {
            backGroundNode = SKSpriteNode(texture: backGround)
            backGroundNode.position = CGPoint(x: (backGround.size().width - 1) * i, y: self.frame.midY)
            backGroundNode.size.height = self.frame.height
            
            backGroundNode.run(makeBackGroundAnimation)
            backGroundNode.zPosition = -1
            backGroundNode.name = "backGroundNode"
            self.addChild(backGroundNode)
            
            i += 1
        }
        
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        bird = SKSpriteNode(texture: birdTexture)
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.2)
        let makeFlappy = SKAction.repeatForever(animation)
        
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: (bird.texture?.size().width)! / 2)
        bird.physicsBody?.isDynamic = false
        bird.run(makeFlappy)
        bird.physicsBody?.contactTestBitMask = collisionType.object.rawValue
        bird.physicsBody?.collisionBitMask = collisionType.bird.rawValue
        bird.physicsBody?.categoryBitMask = collisionType.bird.rawValue
        bird.name = "bird"
        self.addChild(bird)
        
        
        
        
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 2))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.contactTestBitMask = collisionType.object.rawValue
        ground.physicsBody?.collisionBitMask = collisionType.object.rawValue
        ground.physicsBody?.categoryBitMask = collisionType.object.rawValue
        ground.name = "ground"
        self.addChild(ground)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.text = "Your Score = \(score)"
        scoreLabel.fontColor = UIColor.blue
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: self.frame.midX, y: ((self.frame.height / 2) - 100))
        scoreLabel.zPosition = 1
        scoreLabel.name = "scoreLabel"
        self.addChild(scoreLabel)
        

        print(self.children.count)

    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setUpGame()
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        if gameStart == true {
            
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
            
            
            
        } else {
            pipeMaking = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(makingPipe), userInfo: nil, repeats: true)
            intervalTime = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(deletingTimeInterval), userInfo: nil, repeats: false)
            score = 0
            bird.physicsBody?.isDynamic = true
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
            print("Game Start")
        }
        
        gameStart = true
        gameOver = false
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
