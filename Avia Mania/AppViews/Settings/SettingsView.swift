//
//  SettingsView.swift
//  Avia Mania
//
//  Created by Anton on 26/3/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    // вкл/выкл пуши, звуки
    // бос профи/не профи (boss_level_hard)
    
    @State var soundsEnabled = false
    @State var pushEnabled = false
    @State var isHardLevelEnabled = false
    
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
                
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
            }
            
            VStack {
                VStack {
                    Text("Game Preferences")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Sounds")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle(isOn: $soundsEnabled, label: {
                            
                        })
                        .onChange(of: soundsEnabled) { a in
                            UserDefaults.standard.set(a, forKey: "sounds_enabled")
                        }
                    }
                    .padding(.top) 
                    
                    HStack {
                        Text("Push notifications")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle(isOn: $pushEnabled, label: {
                            
                        })
                        .onChange(of: pushEnabled) { a in
                            UserDefaults.standard.set(a, forKey: "push_enabled")
                        }
                    }
                    .padding(.top)
                    
                    Text("Boss Game Difficulty")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    HStack {
                        Text("Normal")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                isHardLevelEnabled = false
                                UserDefaults.standard.set(isHardLevelEnabled, forKey: "boss_level_hard")
                            }
                        } label: {
                            if !isHardLevelEnabled {
                                Image("radio_on")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            } else {
                                Image("radio_off")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                        }
                    }
                    .padding(.top)
                    
                    HStack {
                        Text("Hard")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                isHardLevelEnabled = true
                                UserDefaults.standard.set(isHardLevelEnabled, forKey: "boss_level_hard")
                            }
                        } label: {
                            if isHardLevelEnabled {
                                Image("radio_on")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            } else {
                                Image("radio_off")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
            .border(.white)
            .cornerRadius(12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .fill(.black)
            )
            .padding()
            .onAppear {
                soundsEnabled = UserDefaults.standard.bool(forKey: "sounds_enabled")
                isHardLevelEnabled = UserDefaults.standard.bool(forKey: "boss_level_hard")
                pushEnabled = UserDefaults.standard.bool(forKey: "push_enabled")
            }
        }
        .background(
            Image("background")
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SettingsView()
}
