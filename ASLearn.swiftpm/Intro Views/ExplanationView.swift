//
//  ExplanationView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 21/4/22.
//

import SwiftUI

struct ExplanationView: View {
	var body: some View {
		NavigationView {
			VStack {
				Image(systemName: "camera.viewfinder")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 100)
				HStack {
					Spacer()
					Image(systemName: "hand.raised.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
					Spacer()
					Image(systemName: "textformat.size")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
					Spacer()
				}.padding(.bottom)
				Text("Three simple steps!")
					.multilineTextAlignment(.center)
					.font(.system(size: 30, weight: .bold))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
					.padding(.bottom)
				Text("1. An alphabet and the corresponding gesture appears on your screen")
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Text("2. Try to copy the gesture and show it to your camera")
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Text("3. ASLearn will use Machine Learning to determine the accuracy of your gesture")
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.padding(.bottom, 50)
					.fixedSize(horizontal: false, vertical: true)
				Text("Machine Learning is not perfect and may occasionally guess incorrectly.\nFactors such as lighting conditions may affect prediction accuracy.")
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
					.font(.system(size: 20))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				NavigationLink(destination: BaseView().navigationBarHidden(true).navigationViewStyle(.stack), label: {
					Image(systemName: "arrow.right.circle.fill")
						.font(.system(size: 60))
						.foregroundColor(.blue)
				})
				Spacer()
			}
		}
	}
}
