//
//  MissionsView.swift
//  Avia Mania
//
//  Created by Anton on 26/3/24.
//

import SwiftUI

struct MissionsView: View {
    
    @EnvironmentObject var appData: AppData
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("back_btn")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding(.leading)
                
                Spacer()
                
                Text("Missions")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
                
                HStack {
                    Text("\(appData.score)")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                    Image("coin")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding(.trailing)
            }
            
            ScrollView {
                ForEach(missionsUi, id: \.id) { mission in
                    VStack {
                        HStack {
                            VStack {
                                Image("coin")
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                
                                Text("\(mission.reward)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                            }
                            .frame(width: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.red)
                            )
                            VStack {
                                Text(mission.missionName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                Text(mission.missionText)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .padding()
                            .frame(width: 300, height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.red)
                            )
                        }
                        
                        if appData.missionsCompleted.contains(mission.id) && !appData.claimedMissions.contains(mission.id) {
                            Button {
                                appData.claimMission(missionId: mission.id, missionReward: mission.reward)
                            } label: {
                                Text("Claim")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.system(size: 24, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(.red)
                                    )
                            }
                            .padding([.leading, .trailing], 2)
                        }
                        
                  
                        
                        if appData.claimedMissions.contains(mission.id) {
                            ZStack {
                                Text("Done")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.system(size: 24, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(.green)
                                    )
                            }
                            .padding([.leading, .trailing], 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }
            }
        }
        .background(
            Image("background")
                .ignoresSafeArea()
        )
    }
}

#Preview {
    MissionsView()
        .environmentObject(AppData())
}
