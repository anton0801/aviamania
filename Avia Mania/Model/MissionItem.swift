//
//  MissionItem.swift
//  Avia Mania
//
//  Created by Anton on 27/3/24.
//

import Foundation

struct MissionItem: Identifiable {
    let id: String
    let missionName: String
    let missionText: String
    let reward: Int
}

let missionsUi = [
    MissionItem(id: "mission_1", missionName: "Mission 50 enemies", missionText: "to get this mission you need to destroy 50 enemy planes.", reward: 250),
    MissionItem(id: "mission_2", missionName: "Mission 100 enemies", missionText: "to get this mission you need to destroy 100 enemy planes.", reward: 600),
    MissionItem(id: "mission_3", missionName: "Mission 200 enemies", missionText: "to get this mission you need to destroy 200 enemy planes.", reward: 1500),
    MissionItem(id: "mission_4", missionName: "Mission 500 enemies", missionText: "to get this mission you need to destroy 500 enemy planes.", reward: 10000),
    MissionItem(id: "mission_boss_1", missionName: "Mission 1 BOSS", missionText: "To get this mission you need to destroy 1 enemy boss.", reward: 100),
    MissionItem(id: "mission_boss_2", missionName: "Mission 2 BOSS", missionText: "To get this mission you need to destroy 2 enemy bosses.", reward: 350),
    MissionItem(id: "mission_boss_3", missionName: "Mission 5 BOSS", missionText: "To get this mission you need to destroy 5 enemy bosses.", reward: 1000),
    MissionItem(id: "mission_boss_4", missionName: "Mission 10 BOSS", missionText: "To get this mission you need to destroy 10 enemy bosses.", reward: 10000),
]
