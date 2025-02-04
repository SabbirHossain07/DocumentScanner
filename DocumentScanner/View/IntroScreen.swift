//
//  IntroScreen.swift
//  DocumentScanner
//
//  Created by Sopnil Sohan on 19/1/25.
//

import SwiftUI

struct IntroScreen: View {
    @AppStorage("showIntroView") private var showIntroView = true
    
    var body: some View {
        VStack(spacing: 15) {
            Text("What's New in \nDocument scanner?")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            VStack(alignment: .leading, spacing: 25) {
                PointView(title: "Scan Documents", image: "scanner", description: "Scan any document with ease")
                PointView(title: "Save Documents", image: "tray.full.fill", description: "Persist scanned document with the new SwiftData Model")
                PointView(title: "Lock Documents", image: "faceid", description: "Protect your documents with biometric authentication")
            }
            .padding(.horizontal, 25)
            
            Spacer(minLength: 0)
            
            //MARK: Continue Button
            Button {
                showIntroView = false
            } label: {
                Text("Start Using Documment Scanner")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(.blue.gradient, in: .capsule)
            }
        }
        .padding(15)
    }
    @ViewBuilder
    private func PointView(title: String, image: String, description: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    IntroScreen()
}
