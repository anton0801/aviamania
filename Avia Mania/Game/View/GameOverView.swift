//
//  GameOverView.swift
//  Avia Mania
//
//  Created by Anton on 25/3/24.
//

import SwiftUI

struct GameOverView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var score: Int
    
    var body: some View {
        VStack {
            Text("Game Over")
                .foregroundColor(.white)
                .font(.system(size: 32, weight: .bold))
            
            VStack {
                VStack {
                    
                    HStack {
                        Spacer()
                    }
                    
                    Text("Your score:")
                        .foregroundColor(.white)
                        .font(.system(size: 32, weight: .bold))
                    
                    Text("\(score)")
                        .foregroundColor(.white)
                        .font(.system(size: 42, weight: .bold))
                    
                    Text("Best result: \(UserDefaults.standard.integer(forKey: "best_score"))")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 2)
                    
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                            .foregroundColor(.white)
                            .padding()
                            .font(.system(size: 24, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.red)
                            )
                    }
                    .padding([.leading, .trailing, .top], 2)
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
        }
        .background(
            Image("background")
                .ignoresSafeArea()
        )
    }
}

#Preview {
    GameOverView(score: 150)
}
