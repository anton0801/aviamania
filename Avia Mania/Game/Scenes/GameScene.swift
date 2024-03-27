//
//  GameScene.swift
//  Avia Mania
//
//  Created by Anton on 25/3/24.
//

import Foundation
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameId: String = UUID().uuidString
    let background = SKSpriteNode(imageNamed: "background")
    var player = SKSpriteNode()
    var playerFire = SKSpriteNode()
    var enemy = SKSpriteNode()
    var bossOne = SKSpriteNode()
    var bossFire = SKSpriteNode()
    var boosterNode: SKSpriteNode!
    var boosterLabel: SKLabelNode!
    
    var enemyId = ""
    var bossId = ""
    
    var bossOneLives = [25, 30, 35, 40, 45].randomElement() ?? 25
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel = SKLabelNode()
    var liveArray = [SKSpriteNode]()
    
    var enemiesPlanes = ["enemy_1", "enemy_2", "enemy_3", "enemy_4", "enemy_5", "enemy_6", "enemy_7", "enemy_8"]
    
    var fireTimer = Timer()
    var enemyTimer = Timer()
    var bossFireTimer = Timer()
    var boosterEnabledSecondsPassed = 0.0
    var boosterIsEnabled = false
    
    var boostersCount = UserDefaults.standard.integer(forKey: "boostersCount") {
        didSet {
            boosterLabel.text = "x\(boostersCount)"
            UserDefaults.standard.set(boostersCount, forKey: "boostersCount")
        }
    }
    
    struct CBitmask {
        static let playerPlane: UInt32 = 0b1 // 1
        static let playerFire: UInt32 = 0b10 // 2
        static let enemyPlane: UInt32 = 0b100 // 4
        static let bossOne: UInt32 = 0b1000 / 8
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        scene?.size = CGSize(width: 750, height: 1335)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 1
        addChild(background)
        
        makePlayer(playerC: 1)
        
        fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(makePlayerFire), userInfo: nil, repeats: true)
        enemyTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemies), userInfo: nil, repeats: true)
        
        addScore()
        
        addLives(lives: 3)
        
        createBooster()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        
        guard !object.contains(boosterNode) else {
            if boostersCount > 0 {
                fireTimer = .scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(makePlayerFire), userInfo: nil, repeats: true)
                boosterEnabledSecondsPassed = 0.0
                boosterIsEnabled = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                    self.fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.makePlayerFire), userInfo: nil, repeats: true)
//                }
                boostersCount -= 1
            }
            return
        }
    }
    
    private func createBooster() {
        boosterNode = SKSpriteNode(imageNamed: "booster")
        boosterNode.size = CGSize(width: 140, height: 130)
        boosterNode.position = CGPoint(x: size.width - boosterNode.size.width / 2 - 10, y: size.height - boosterNode.size.height - 10)
        boosterNode.name = "booster"
        boosterNode.zPosition = 11
        addChild(boosterNode)
        
        boosterLabel = SKLabelNode()
        boosterLabel.text = "x\(boostersCount)"
        boosterLabel.zPosition = 12
        boosterLabel.fontSize = 42
        boosterLabel.fontName = "Chalkduster"
        boosterLabel.position = CGPoint(x: size.width - boosterNode.size.width / 2 - 10, y: size.height - boosterNode.size.height / 2 - 10)
        addChild(boosterLabel)
    }
    
    private func addScore() {
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: 100, y: 20)
        scoreLabel.fontSize = 40
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
    }
    
    private func updateScore() {
        score += 10
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody
        let contactB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        } else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.enemyPlane {
            updateScore()
            do {
                playerFireHitEnemy(fires: contactA.node as! SKSpriteNode, enemys: contactB.node as! SKSpriteNode)
            } catch {}
            
            var prevBossAppearScore = UserDefaults.standard.integer(forKey: "prevBossAppearScore")
            if prevBossAppearScore == 0 {
                prevBossAppearScore = 150
            }
            
            NotificationCenter.default.post(name: Notification.Name("ENEMY_DESTROYED"), object: nil, userInfo: ["planeId": self.enemyId])
            
//            if score == prevBossAppearScore + 10 {
//                let numbers = [10, 20, 30, 40, 50]
//                UserDefaults.standard.set(prevBossAppearScore + (numbers.randomElement() ?? 10), forKey: "prevBossAppearScore")
//                makeBoss()
//                bossFireTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeBossFire), userInfo: nil, repeats: true)
//                if !UserDefaults.standard.bool(forKey: "boss_level_hard") {
//                    enemyTimer.invalidate()
//                }
//            }
        }
        
        if contactA.categoryBitMask == CBitmask.playerPlane && contactB.categoryBitMask == CBitmask.enemyPlane {
            if liveArray.count == 1 {
                liveArray[0].removeFromParent()
                liveArray = []
                playerHitEnemy(players: contactA.node as! SKSpriteNode, enemy: contactB.node as! SKSpriteNode)
            } else {
                let lastElement = liveArray.removeLast()
                lastElement.removeFromParent()
                addLives(lives: liveArray.count)
                player.run(SKAction.repeat(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.fadeIn(withDuration: 0.1)]), count: 8))
                contactB.node?.removeFromParent()
            }
        }
        
//        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.bossOne {
//            contactA.node?.removeFromParent()
//            
//            if let fileParticles = SKEmitterNode(fileNamed: "Fire") {
//                fileParticles.position = contactA.node!.position
//                fileParticles.zPosition = 12
//                addChild(fileParticles)
//            }
//            
//            addSoundEffect(for: "explosion")
//            
//            bossOneLives -= 1
//            
//            if bossOneLives == 0 {
//                NotificationCenter.default.post(name: Notification.Name("BOSS_DESTROYED"), object: nil, userInfo: ["bossId": self.bossId])
//                if let fileParticles = SKEmitterNode(fileNamed: "Fire") {
//                    fileParticles.position = contactB.node!.position
//                    fileParticles.zPosition = 12
//                    fileParticles.setScale(2)
//                    addChild(fileParticles)
//                }
//                contactB.node?.removeFromParent()
//                bossFireTimer.invalidate()
//                enemyTimer =  .scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(makeEnemies), userInfo: nil, repeats: true)
//            }
//        }
    }
    
    private func playerHitEnemy(players: SKSpriteNode, enemy: SKSpriteNode) {
        enemy.removeFromParent()
        players.removeFromParent()
        
        fireTimer.invalidate()
        enemyTimer.invalidate()
        
        if let fileParticles = SKEmitterNode(fileNamed: "Fire") {
            fileParticles.position = players.position
            fileParticles.zPosition = 12
            addChild(fileParticles)
        }
        
        addSoundEffect(for: "explosion")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: Notification.Name("GAME_OVER"), object: nil, userInfo: ["data": self.score, "gameId": self.gameId])
        }
    }
    
    private func playerFireHitEnemy(fires: SKSpriteNode, enemys: SKSpriteNode) {
        fires.removeFromParent()
        enemys.removeFromParent()
        if let fileParticles = SKEmitterNode(fileNamed: "Fire") {
            fileParticles.position = enemy.position
            fileParticles.zPosition = 12
            addChild(fileParticles)
        }
        addSoundEffect(for: "explosion")
    }
    
    private func addSoundEffect(for file: String) {
        if UserDefaults.standard.bool(forKey: "sounds_enabled") {
            let soundAction = SKAction.playSoundFileNamed(file, waitForCompletion: false)
            run(soundAction)
        }
    }
    
    private func addLives(lives: Int) {
        for i in liveArray {
            i.removeFromParent()
        }
        liveArray = []
        for live in 1...lives {
            let liveNode = SKSpriteNode(imageNamed: "life")
            liveNode.size = CGSize(width: 50, height: 50)
            liveNode.position = CGPoint(x: CGFloat(live) * liveNode.size.width + 10, y: size.height - liveNode.size.height - 10)
            liveNode.zPosition = 10
            liveNode.name = "live\(live)"
            liveArray.append(liveNode)
            addChild(liveNode)
        }
    }
    
    private func makePlayer(playerC: Int) {
        var planeName = UserDefaults.standard.string(forKey: "currentPlane")!
        player = .init(imageNamed: planeName)
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.zPosition = 10
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerPlane
        player.physicsBody?.contactTestBitMask = CBitmask.enemyPlane
        player.physicsBody?.collisionBitMask = CBitmask.enemyPlane
        addChild(player)
    }
    
    func makeBoss() {
        bossId = UUID().uuidString
        bossOne = .init(imageNamed: "plane_boss")
        bossOne.position = CGPoint(x: size.width / 2, y: size.height + bossOne.size.height)
        bossOne.zPosition = 10
        
        bossOne.physicsBody = SKPhysicsBody(rectangleOf: bossOne.size)
        bossOne.physicsBody?.affectedByGravity = false
        bossOne.physicsBody?.isDynamic = true
        bossOne.physicsBody?.categoryBitMask = CBitmask.bossOne
        bossOne.physicsBody?.contactTestBitMask = CBitmask.playerPlane | CBitmask.playerFire
        bossOne.physicsBody?.collisionBitMask = CBitmask.playerPlane | CBitmask.playerFire
        
        let move1 = SKAction.moveTo(y: size.height / 1.3, duration: 2)
        let move2 = SKAction.moveTo(x: size.height - bossOne.size.width / 2, duration: 2)
        let move3 = SKAction.moveTo(x: 0 + bossOne.size.width / 2, duration: 2)
        let move4 = SKAction.moveTo(x: size.width / 2, duration: 1.5)
        let move5 = SKAction.fadeOut(withDuration: 0.2)
        let move6 = SKAction.fadeIn(withDuration: 0.2)
        let move7 = SKAction.moveTo(y: 0 + bossOne.size.height / 2, duration: 2)
        let move8 = SKAction.moveTo(y: size.height / 1.3, duration: 2)
        
        let action = SKAction.repeat(SKAction.sequence([move5, move6]), count: 6)
        let repeateForever = SKAction.repeatForever(SKAction.sequence([move2, move3, move4, action, move7, move8]))
        let sequence = SKAction.sequence([move1, repeateForever])
        bossOne.run(sequence)
        addChild(bossOne)
    }
    
    @objc func makeBossFire() {
        bossFire = .init(imageNamed: "bullet_green")
        bossFire.position = bossOne.position
        bossFire.zPosition = 5
        
        let move1 = SKAction.moveTo(y: 0 - bossFire.size.height, duration: 1.5)
        let removeAction = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([move1, removeAction])
        bossFire.run(sequence)
        addChild(bossFire)
    }
    
    @objc func makePlayerFire() {
        playerFire = .init(imageNamed: "bullet_red")
        playerFire.position.x = player.position.x
        playerFire.position.y = player.position.y
        playerFire.zPosition = 3
        playerFire.physicsBody = SKPhysicsBody(rectangleOf: playerFire.size)
        playerFire.physicsBody?.affectedByGravity = false
        playerFire.physicsBody?.categoryBitMask = CBitmask.playerFire
        playerFire.physicsBody?.contactTestBitMask = CBitmask.enemyPlane | CBitmask.bossOne
        playerFire.physicsBody?.collisionBitMask = CBitmask.enemyPlane | CBitmask.bossOne
        addChild(playerFire)
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        playerFire.run(combine)
        if boosterIsEnabled {
            boosterEnabledSecondsPassed += 0.125
            if boosterEnabledSecondsPassed >= 10.0 {
                fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(makePlayerFire), userInfo: nil, repeats: true)
                boosterIsEnabled = false
                boosterEnabledSecondsPassed = 0.0
            }
        }
    }
    
    @objc func makeEnemies() {
        enemyId = UUID().uuidString
        let random = GKRandomDistribution(lowestValue: 50, highestValue: 700)
        enemy = .init(imageNamed: enemiesPlanes.randomElement() ?? "plane")
        enemy.position = CGPoint(x: random.nextInt(), y: 1400)
        enemy.zPosition = 5
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyPlane
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerPlane | CBitmask.playerFire
        enemy.physicsBody?.collisionBitMask = CBitmask.playerPlane | CBitmask.playerFire
        
        addChild(enemy)
        
        let moveAction = SKAction.moveTo(y: -100, duration: 2)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        enemy.run(combine)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locaation = touch.location(in: self)
            player.position.x = locaation.x
        }
    }
    
}
