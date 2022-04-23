//
//  BaseView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 23/4/22.
//

import SwiftUI
import Foundation

struct BaseView: View {
	
	@State var viewShown = 0
	@ObservedObject var sharedViewModel = SharedViewModel()
	
	var body: some View {
		NavigationView {
			VStack {
				switch viewShown {
				case 0:
					BaseViewOne(sharedViewModel: sharedViewModel)
				case 1:
					BaseViewTwo(sharedViewModel: sharedViewModel)
				case 2:
					SuccessView(sharedViewModel: sharedViewModel)
				case 3:
					IncorrectView(sharedViewModel: sharedViewModel, viewShown: $viewShown)
				case 4:
					CompletionPage()
				default:
					fatalError()
				}
				Spacer()
			}
			.onAppear(perform: {
				DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
					withAnimation {
						viewShown = 1
					}
				})
			})
			.fullScreenCover(isPresented: $sharedViewModel.shouldShowMainView, onDismiss: {
				if sharedViewModel.currentAlphabetIndex == sharedViewModel.alphabets.count - 1 && sharedViewModel.alphabets[sharedViewModel.currentAlphabetIndex] == sharedViewModel.predictedLetter {
					viewShown = 4
				}
				viewShown = sharedViewModel.alphabets[sharedViewModel.currentAlphabetIndex] == sharedViewModel.predictedLetter ? 2 : 3
			}, content: {
				MainView(sharedViewModel: sharedViewModel).interactiveDismissDisabled()
			})
			.fullScreenCover(isPresented: $sharedViewModel.shouldMoveToCompletionView, content: {
				CompletionPage()
			})
		}
	}
}

struct BaseViewOne: View {
	@ObservedObject var sharedViewModel: SharedViewModel
	
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 150)
				.padding()
				.padding(.bottom, 50)
			Text("Hello World.")
				.font(.system(size: 35, weight: .bold))
				.padding()
				.padding(.bottom, 50)
				.fixedSize(horizontal: false, vertical: true)
			Text("When learning a new programming language, it's typical to start with displaying the words \"Hello World\"")
				.multilineTextAlignment(.center)
				.font(.system(size: 25))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
			Text("Let's try it in American Sign Language!")
				.font(.system(size: 25))
				.padding()
			Spacer()
		}
	}
}

struct BaseViewTwo: View {
	@ObservedObject var sharedViewModel: SharedViewModel
	
	@State var currentInstruction = 0
	
	var instructions = [
		"Let's start with the letter H!",
		"Next, let's do E.",
		"Third letter, L.",
		"It's L again!",
		"Last one, O.",
	]
	
	var body: some View {
		VStack {
			Text(instructions[currentInstruction])
				.multilineTextAlignment(.center)
				.font(.system(size: 25))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
			Spacer()
			Button {
				if sharedViewModel.currentAlphabetIndex != sharedViewModel.alphabets.count - 1 {
					sharedViewModel.shouldShowMainView.toggle()
				}
			} label: {
				Image(systemName: "checkmark.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 50)
					.foregroundColor(.blue)
			}
			Spacer()
		}
	}
}

struct SuccessView: View {
	@ObservedObject var sharedViewModel: SharedViewModel
	
	var body: some View {
		VStack {
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
					sharedViewModel.currentAlphabetIndex += 1
					sharedViewModel.shouldShowMainView.toggle()
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

struct IncorrectView: View {
	@ObservedObject var sharedViewModel: SharedViewModel
	@Binding var viewShown: Int
	
	var body: some View {
		VStack {
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
			Text("ASLearn is \(String(format:"%.1f", sharedViewModel.confidence * 100))% sure that your gesture represents the letter \(sharedViewModel.predictedLetter).")
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
						sharedViewModel.currentAlphabetIndex += 1
						sharedViewModel.shouldShowMainView.toggle()
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
