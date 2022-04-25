//
//  SuccessView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 24/4/22.
//

import SwiftUI

struct SuccessView: View {
	@ObservedObject var sharedViewModel: SharedViewModel
	
	@Binding var viewShown: Int
	
	var body: some View {
		VStack {
			BaseViewTwo(isMainView: false, sharedViewModel: sharedViewModel)
			Image(systemName: "hand.thumbsup.circle")
				.resizable()
				.frame(width: 100, height: 100)
				.padding()
				.padding(.bottom, 50)
			Text("Great Job!")
				.font(.system(size: 30))
				.padding()
			Text("You got it right!")
				.font(.system(size: 25))
				.padding()
			Spacer()
			Button(action: {
				if sharedViewModel.currentAlphabetIndex != sharedViewModel.alphabets.count - 1 {
					sharedViewModel.shouldShowMainView.toggle()
					DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
						// Prevents next letter from being shown prematurely
						sharedViewModel.currentAlphabetIndex += 1
					})
				} else {
					withAnimation {
						viewShown = 4
					}
				}
			}, label: {
				Text("Continue")
					.padding()
					.foregroundColor(.white)
					.background(Color.blue)
					.cornerRadius(10)
			}).buttonStyle(DefaultButtonStyle())
			Spacer()
		}
	}
}
