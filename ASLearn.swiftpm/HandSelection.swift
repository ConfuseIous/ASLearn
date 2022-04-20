//
//  HandSelectionView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 19/4/22.
//

import SwiftUI

struct HandSelectionView: View {
	
	@AppStorage("selectedHandIndex") var selectedHandIndex = 0
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Spacer()
					Image(systemName: "hand.wave.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.transformEffect(CGAffineTransform(scaleX: -1, y: 1))
					Spacer()
					Image(systemName: "hand.wave.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
					
					Spacer()
				}
				.padding(.top, 20)
				.padding(.bottom, 50)
				Text("For maximum accuracy, please specify the hand you'd like to create gestures with.")
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Picker("Preferred Hand", selection: $selectedHandIndex, content: {
					Text("Left").tag(0)
					Text("Right").tag(1)
				})
				.pickerStyle(SegmentedPickerStyle())
				.padding()
				Text("You may find it easier to select your dominant hand.")
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
					.font(.system(size: 20))
					.padding()
					.padding(.bottom)
					.fixedSize(horizontal: false, vertical: true)
				NavigationLink(destination: MainViewController().navigationBarHidden(true).navigationViewStyle(.stack), label: {
					Text("Save and Go")
						.padding()
						.foregroundColor(.white)
						.background(Color.blue)
				})
				.buttonStyle(PlainButtonStyle())
				.cornerRadius(10)
				Spacer()
			}
		}
	}
}
