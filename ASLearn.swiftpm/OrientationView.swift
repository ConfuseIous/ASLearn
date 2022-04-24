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
					Spacer()
					Image(systemName: "ipad.homebutton")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
					Spacer()
				}
				.padding(.top, 20)
				.padding(.bottom, 50)
				Text("ASLearn has been optimised to work on all iPad models.")
				 	.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				(
					Text("For the best possible experience, please run ASLearn in ")
					+
					Text("Portrait Mode")
						.foregroundColor(.red)
					+
					Text(". This allows you to be centered in relation to the camera.")
					)
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				NavigationLink(destination: HandSelectionView().navigationBarHidden(true).navigationViewStyle(.stack), label: {
					Image(systemName: "arrow.right.circle.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.foregroundColor(.blue)
				})
				Spacer()
				Text("ASLearn requires iOS 15 or newer.")
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
