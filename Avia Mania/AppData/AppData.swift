//
//  AppData.swift
//  Avia Mania
//
//  Created by Anton on 26/3/24.
//

import Foundation

class AppData: ObservableObject {
    
    @Published var score = UserDefaults.standard.integer(forKey: "score")
    @Published var missionsCompleted: [String] = []
    @Published var claimedMissions: [String] = []
    // planes: reward mission
    var allMissions: [Int: Int] = [
        50: 250,
        100: 600,
        200: 1500,
        500: 10000
    ]
    var allBossMissions: [Int: Int] = [
        1: 100,
        2: 350,
        5: 1000,
        10: 10000
    ]
    var missionsIds = ["mission_1", "mission_2", "mission_3", "mission_4", "mission_boss_1", "mission_boss_2", "mission_boss_3", "mission_boss_4"]
    
    var storePlanes = ["plane", "plane_3", "plane_4", "plane_5", "plane_6", "plane_7", "plane_8", "plane_9"]
    var planePrices = [
        "plane": 0,
        "plane_3": 400,
        "plane_4": 1000,
        "plane_5": 1500,
        "plane_6": 2000,
        "plane_7": 3000,
        "plane_8": 5000,
        "plane_9": 10000
    ]
    
    @Published var buiedPlanes: [String] = []
    @Published var currentPlane: String = UserDefaults.standard.string(forKey: "currentPlane") ?? "plane"
    
    @Published var boostersCount: Int = UserDefaults.standard.integer(forKey: "boostersCount")
    
    init() {
        let savedMissions = UserDefaults.standard.string(forKey: "missions_completed")?.components(separatedBy: ",") ?? []
        for mission in savedMissions {
            missionsCompleted.append(mission)
        }
        
        let claimedSaved = UserDefaults.standard.string(forKey: "claimed_completed")?.components(separatedBy: ",") ?? []
        for mission in claimedSaved {
            claimedMissions.append(mission)
        }
        
        let savedBuiedPlanes = UserDefaults.standard.string(forKey: "buied_planes")?.components(separatedBy: ",") ?? []
        for plane in savedBuiedPlanes {
            buiedPlanes.append(plane)
        }
    }
    
    func buyBooster() -> Bool {
        if score >= 500 {
            boostersCount += 1
            UserDefaults.standard.set(boostersCount, forKey: "boostersCount")
            return true
        }
        return false
    }
    
    func setCurrentPlane(plane: String) {
        currentPlane = plane
        UserDefaults.standard.set(plane, forKey: "currentPlane")
    }
    
    func buyPlane(planeId: String) -> Bool {
        let planePrice = planePrices[planeId]!
        if score >= planePrice {
            var savedBuiedPlanes = UserDefaults.standard.string(forKey: "buied_planes")?.components(separatedBy: ",") ?? []
            savedBuiedPlanes.append(planeId)
            buiedPlanes = savedBuiedPlanes
            UserDefaults.standard.set(savedBuiedPlanes.joined(separator: ","), forKey: "buied_planes")
            addScore(score: -(planePrice))
            return true
        }
        return false
    }
    
    func checkFirstStartAndSetFirstConfigurationApp() {
        let isNotFirstLaunch = UserDefaults.standard.bool(forKey: "isNotFirstLaunch")
        if !isNotFirstLaunch {
            UserDefaults.standard.set(true, forKey: "sounds_enabled")
            UserDefaults.standard.set(true, forKey: "push_enabled")
            UserDefaults.standard.set(false, forKey: "boss_level_hard")
            UserDefaults.standard.set("plane", forKey: "currentPlane")
            UserDefaults.standard.set("plane,", forKey: "buied_planes")
            UserDefaults.standard.set(true, forKey: "isNotFirstLaunch")
        }
    }
    
    func claimMission(missionId: String, missionReward: Int) {
        claimedMissions.append(missionId)
        addScore(score: missionReward)
        var savedMissions = UserDefaults.standard.string(forKey: "claimed_completed")?.components(separatedBy: ",") ?? []
        savedMissions.append(missionId)
        UserDefaults.standard.set(savedMissions.joined(separator: ","), forKey: "claimed_completed")
    }
    
    func checkIfAnyMissionPassed() {
        let currentPlanesDestroyedCount = UserDefaults.standard.integer(forKey: "currentPlanesDestroyedCount")
        for (index, mission) in allMissions.enumerated() {
            if !missionsCompleted.contains("mission_\(index + 1)") {
                if currentPlanesDestroyedCount >= mission.key {
                    addMissionCompleted(missionId: "mission_\(index + 1)", missionValue: mission.value)
                }
            }
        }
    }
    
    func checkIfAnyBossMissionCompleted() {
        let currentBossPlanesDestroyedCount = UserDefaults.standard.integer(forKey: "currentBossPlanesDestroyedCount")
        for (index, mission) in allBossMissions.enumerated() {
            if !missionsCompleted.contains("mission_boss_\(index + 1)") {
                if currentBossPlanesDestroyedCount >= mission.key {
                    addMissionCompleted(missionId: "mission_boss_\(index + 1)", missionValue: mission.value)
                }
            }
        }
    }
    
    func addEnemyCountDestroyed() {
        var currentPlanesDestroyedCount = UserDefaults.standard.integer(forKey: "currentPlanesDestroyedCount")
        currentPlanesDestroyedCount += 1
        UserDefaults.standard.set(currentPlanesDestroyedCount, forKey: "currentPlanesDestroyedCount")
    }
    
    func addBossCountDestroyed() {
        var currentBossPlanesDestroyedCount = UserDefaults.standard.integer(forKey: "currentBossPlanesDestroyedCount")
        currentBossPlanesDestroyedCount += 1
        UserDefaults.standard.set(currentBossPlanesDestroyedCount, forKey: "currentBossPlanesDestroyedCount")
    }
    
    private func addMissionCompleted(missionId: String, missionValue: Int) {
        self.missionsCompleted.append(missionId)
        addScore(score: missionValue)
        var savedMissions = UserDefaults.standard.string(forKey: "missions_completed")?.components(separatedBy: ",") ?? []
        savedMissions.append(missionId)
        UserDefaults.standard.set(savedMissions.joined(separator: ","), forKey: "missions_completed")
    }
    
    func addScore(score: Int) {
        if score >= UserDefaults.standard.integer(forKey: "best_score") {
            UserDefaults.standard.set(score, forKey: "best_score")
        }
        self.score += score
        UserDefaults.standard.set(self.score, forKey: "score")
    }
    
}
