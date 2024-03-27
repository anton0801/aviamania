//
//  RulesView.swift
//  Avia Mania
//
//  Created by Anton on 26/3/24.
//

import SwiftUI

struct RulesView: View {
    
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
                
                Text("Rules")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
            }
            Spacer()
            
            VStack {
                Text("""
                     During the game you need to shoot down as many planes as possible with your shots and also you will have to fight with the boss, which is not so easy to destroy.
                     You also have the opportunity to buy boosters in the store.
                     Boosters give you the ability to shoot 4 times faster than usual for 10 seconds.
                     """)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .fill(.black)
            )
            
            Spacer()
        }
        .background(
            Image("background")
                .ignoresSafeArea()
        )
    }
}

#Preview {
    RulesView()
}
