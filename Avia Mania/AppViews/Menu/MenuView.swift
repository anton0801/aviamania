//
//  MenuView.swift
//  Avia Mania
//
//  Created by Anton on 26/3/24.
//

import SwiftUI

struct MenuView: View {
    
    @StateObject var appData: AppData = AppData()
    
    @State private var rotation: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: SettingsView().navigationBarBackButtonHidden(true)) {
                        Image("settings")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.leading)
                    Spacer()
                    NavigationLink(destination: ContactUsView().navigationBarBackButtonHidden(true)) {
                        Image("contact_us")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.trailing)
                }
                
                Spacer()
                
                NavigationLink(destination: GameView()
                    .environmentObject(appData)
                    .navigationBarBackButtonHidden(true), label: {
                    ZStack {
                        Image("move")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(rotation))
                            .onAppear {
                                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                                    self.rotation = 360.0
                                }
                            }
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 38, height: 42)
                            .foregroundColor(.red)
                    }
                })
                .padding([.leading, .trailing])
                
                
                NavigationLink(destination: MissionsView()
                    .environmentObject(appData)
                    .navigationBarBackButtonHidden(true)) {
                    Text("Missions")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.red)
                        )
                }
                .padding([.leading, .trailing])
                
                HStack {
                    NavigationLink(destination: RulesView().navigationBarBackButtonHidden(true)) {
                        Text("Rules")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .bold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .fill(.red)
                            )
                    }
                    NavigationLink(destination: PlaneStoreView()
                        .environmentObject(appData)
                        .navigationBarBackButtonHidden(true)) {
                        Text("Store")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .bold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .fill(.red)
                            )
                    }
                }
                .padding([.leading, .trailing])
                
                Spacer()
            }
            .background(
                Image("background")
                    .ignoresSafeArea()
            )
            .onAppear {
                appData.checkFirstStartAndSetFirstConfigurationApp()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MenuView()
}
