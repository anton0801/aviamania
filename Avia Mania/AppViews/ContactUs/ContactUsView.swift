//
//  ContactUsView.swift
//  Avia Mania
//
//  Created by Anton on 26/3/24.
//

import SwiftUI
import WebKit

struct ContactUsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    let contactUs = "https://forms.gle/vTBQeNMiHzobv9JN7"
    
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
                
                Text("Contact Form")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold))
                
                Spacer()
            }
            
            ContactForm(url: URL(string: contactUs)!)
        }
        .background(
            Image("background")
                .ignoresSafeArea()
        )
    }
}

struct ContactForm: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    ContactUsView()
}
