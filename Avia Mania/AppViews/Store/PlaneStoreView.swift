//
//  PlaneStoreView.swift
//  Avia Mania
//
//  Created by Anton on 26/3/24.
//

import SwiftUI

struct PlaneStoreView: View {
    
    @EnvironmentObject var appData: AppData
    
    @Environment(\.presentationMode) var presMode
    
    @State var currentTypeStoreItems = "planes"
    @State var showNoMoneyAlert = false
    
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
                
                Text("Store")
                    .foregroundColor(.white)
                    .font(.system(size: 26, weight: .bold))
                
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
            
            HStack {
                if self.currentTypeStoreItems == "planes" {
                    Text("Planes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .fill(.green)
                        )
                } else {
                    Button {
                        withAnimation {
                            self.currentTypeStoreItems = "planes"
                        }
                    } label: {
                        Text("Planes")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                    .fill(.red)
                            )
                    }
                }
                
                Spacer().frame(width: 12)
                
                if self.currentTypeStoreItems == "buster" {
                    Text("Buster")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .fill(.green)
                        )
                } else {
                    Button {
                        withAnimation {
                            self.currentTypeStoreItems = "buster"
                        }
                    } label: {
                        Text("Buster")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.red)
                            )
                    }
                }
            }
            .padding([.leading, .trailing])
            
            if self.currentTypeStoreItems == "planes" {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 140)),
                        GridItem(.flexible(minimum: 140))
                    ]) {
                        ForEach(appData.storePlanes, id: \.self) { plane in
                            let planePrice = appData.planePrices[plane]!
                            VStack {
                                VStack {
                                    Image(plane)
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    
                                    if !appData.buiedPlanes.contains(plane) {
                                        HStack {
                                            Image("coin")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                            
                                            Text("\(planePrice)")
                                                .font(.system(size: 24, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                    } else {
                                        Spacer().frame(height: 38)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.red)
                                )
                                
                                VStack {
                                    if appData.currentPlane == plane {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .foregroundColor(.green)
                                            
                                            Text("Selected")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    if appData.buiedPlanes.contains(plane) {
                                        if appData.currentPlane != plane {
                                            Button {
                                                appData.setCurrentPlane(plane: plane)
                                            } label: {
                                                Text("Select")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    } else if !appData.buiedPlanes.contains(plane) {
                                        Button {
                                            if !appData.buyPlane(planeId: plane) {
                                                showNoMoneyAlert = true
                                            }
                                        } label: {
                                            Text("Buy")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.red)
                                )
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                }
            } else {
                VStack {
                    VStack {
                        HStack {
                            Image("booster")
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            VStack(alignment: .leading) {
                                Text("Booster Fire (x\(appData.boostersCount))")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                Text("This booster gives you the ability to shoot 4 times faster than normal")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.white)
                            }
                        }
                        Button {
                            if !appData.buyBooster() {
                                showNoMoneyAlert = true
                            }
                        } label: {
                            Text("Buy")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                        .fill(.green)
                                )
                        }
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                        .fill(.red)
                )
                .padding()
                
                Spacer()
            }
        }
        .background(
            Image("background")
                .ignoresSafeArea()
        )
        .alert(isPresented: $showNoMoneyAlert) {
            Alert(
                title: Text("Error"),
                message: Text("You do not have enough points to purchase this item"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    PlaneStoreView()
        .environmentObject(AppData())
}
