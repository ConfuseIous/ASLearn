//
//  OrientationView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 17/4/22.
//

import SwiftUI
import Foundation

struct OrientationView: View {
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Spacer()
					Image(systemName: "ipad")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.padding(.top, 20)
					Spacer()
					Image(systemName: "ipad.homebutton")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.padding(.top, 20)
					Spacer()
				}.padding(.bottom, 50)
				Text("ASLearn has been optimised to work on all iPad models.")
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Text("On iPad Pro models with Face ID, ASLearn also includes Augmented Reality for a truly immersive experience.")
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.padding(.bottom, 20)
					.fixedSize(horizontal: false, vertical: true)
				(
					Text("For the best possible experience, please run ASLearn in ")
					+
					Text("Portrait Mode")
						.foregroundColor(.red)
					+
					Text(".")
					)
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				NavigationLink(destination: MainViewController(), label: {
					Image(systemName: "arrow.right.circle.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.foregroundColor(.blue)
				})
				Spacer()
				Text("This feature requires the TrueDepth front camera, which is only available on Face ID supported devices.")
					.font(.system(size: 15))
					.multilineTextAlignment(.center)
					.foregroundColor(.secondary)
					.padding()
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.navigationBarHidden(true)
		.navigationViewStyle(.stack)
	}
}