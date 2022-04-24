//
//  AccuracyView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 25/4/22.
//

import SwiftUI

struct AccuracyView: View {
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					VStack {
						Image("ideal")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: (UIScreen.main.bounds.width/2) - 60)
							.padding(.horizontal, 20)
						Text("Ideal")
							.foregroundColor(.green)
					}
					VStack {
						Image("not_ideal")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: (UIScreen.main.bounds.width/2) - 60)
							.padding(.trailing, 20)
						Text("Not Ideal")
							.foregroundColor(.red)
					}
				}
				Spacer()
				Text("For the best results, please use ASLearn with a solid background, ideally white or light in colour.")
					.multilineTextAlignment(.center)
					.font(.system(size: 25))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Text("When performing a gesture, please ensure that only your hand is visible in the frame of the camera. Faces and unnecessary objects should ideally not be visible.")
					.multilineTextAlignment(.center)
					.font(.system(size: 25))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				NavigationLink(destination: ExplanationView().navigationBarHidden(true).navigationViewStyle(.stack), label: {
					Image(systemName: "arrow.right.circle.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.foregroundColor(.blue)
				})
				Spacer()
			}
		}
	}
}
