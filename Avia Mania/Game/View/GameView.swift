//
//  GameView.swift
//  Avia Mania
//
//  Created by Anton on 25/3/24.
//

import SwiftUI
import SpriteKit
import GameKit

struct GameView: View {
    
    @EnvironmentObject var appData: AppData
    
    let scene = GameScene()
    
    @State var gameIdScoreAdded: String? = nil
    @State var bossIdScoreAdded: String? = nil
    @State var enemyIdScoreAdded: String? = nil
    
    @State var gameOver = false
    @State var score = 0
    
    var body: some View {
        if gameOver {
            GameOverView(score: score)
        } else {
            VStack {
               SpriteView(scene: scene)
                   .ignoresSafeArea()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GAME_OVER"))) { notification in
                if let score = notification.userInfo?["data"] as? Int {
                    if let gameId = notification.userInfo?["gameId"] as? String {
                        if gameId != gameIdScoreAdded {
                            self.score = score
                            appData.addScore(score: score)
                            gameOver = true
                            self.gameIdScoreAdded = gameId
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("BOSS_DESTROYED"))) { notification in
                if let bossId = notification.userInfo?["bossId"] as? String {
                    if bossId != bossIdScoreAdded {
                        appData.addBossCountDestroyed()
                        appData.checkIfAnyBossMissionCompleted()
                        self.bossIdScoreAdded = bossId
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ENEMY_DESTROYED"))) { notification in
                if let enemyId = notification.userInfo?["planeId"] as? String {
                    if enemyId != enemyIdScoreAdded {
                        appData.addEnemyCountDestroyed()
                        appData.checkIfAnyMissionPassed()
                        self.enemyIdScoreAdded = enemyId
                    }
                }
            }
        }
    }
}

#Preview {
    GameView()
        .environmentObject(AppData())
}
