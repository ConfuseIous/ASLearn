//
//  IncorrectView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 24/4/22.
//

import SwiftUI

struct IncorrectView: View {
	@ObservedObject var sharedViewModel: SharedViewModel
	@Binding var viewShown: Int
	
	var body: some View {
		VStack {
			BaseViewTwo(isMainView: false, sharedViewModel: sharedViewModel)
			Image(systemName: "exclamationmark.triangle.fill")
				.resizable()
				.foregroundColor(.yellow)
				.frame(width: 100, height: 100)
				.padding()
				.padding(.bottom, 50)
			Text("Oops!")
				.font(.system(size: 30))
				.padding()
			Text("That doesn't seem to have worked.")
				.font(.system(size: 25))
				.padding()
			Text("ASLearn thinks that your gesture may represent the letter \(sharedViewModel.mostConfidentLetter).")
				.foregroundColor(.secondary)
				.font(.system(size: 25))
				.padding()
			HStack {
				Button(action: {
					sharedViewModel.shouldShowMainView.toggle()
				}, label: {
					Text("Try Again")
						.frame(width: 100)
						.padding()
						.foregroundColor(.white)
						.background(Color.blue)
						.cornerRadius(10)
				}).buttonStyle(DefaultButtonStyle())
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
					Text("Skip")
						.frame(width: 100)
						.padding()
						.foregroundColor(.black)
						.background(Color.yellow)
						.cornerRadius(10)
				}).buttonStyle(DefaultButtonStyle())
			}
			.padding()
			.padding(.bottom, 50)
			Text("Sometimes, you may have the right gesture and the guess is inaccurate.\n\nIf this happens frequently, you may want to move somewhere with better lighting and an even background.\n\nMake sure only your hand is visible in frame.\n\nThe accuracy of these guesses will go up over time as I tune and enhance ASLearn further!")
				.font(.system(size: 16))
				.multilineTextAlignment(.center)
				.foregroundColor(.secondary)
			Spacer()
		}
	}
}
