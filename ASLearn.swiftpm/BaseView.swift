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
					BaseViewTwo(isMainView: true, sharedViewModel: sharedViewModel)
				case 2:
					SuccessView(sharedViewModel: sharedViewModel, viewShown: $viewShown)
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
				viewShown = sharedViewModel.isLetterCorrect ? 2 : 3
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
			Text("When learning a new programming language, it's typical to start with displaying the words \"Hello World\".")
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
	var isMainView: Bool
	
	@ObservedObject var sharedViewModel: SharedViewModel
	
	var instructions = [
		"Let's start with the letter H!",
		"Next, let's do E.",
		"Third letter, L.",
		"It's L again!",
		"Last one, O.",
		"Next word, first letter. W.",
		"Let's try O again.",
		"Great, on to R.",
		"Almost there! L.",
		"Final letter, D.",
		"And we're done!"
	]
	
	var body: some View {
		VStack {
			HStack {
				Text("H")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 0 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("E")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 1 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("L")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 2 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("L")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 3 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("O")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 4 ? .blue : .secondary)
					.font(.system(size: 30))
					.padding(.trailing)
				Text("W")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 5 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("O")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 6 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("R")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 7 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("L")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 8 ? .blue : .secondary)
					.font(.system(size: 30))
				Text("D")
					.foregroundColor(sharedViewModel.currentAlphabetIndex == 9 ? .blue : .secondary)
					.font(.system(size: 30))
			}
			
			Text(instructions[(isMainView || !sharedViewModel.isLetterCorrect) ? sharedViewModel.currentAlphabetIndex : sharedViewModel.currentAlphabetIndex + 1])
				.multilineTextAlignment(.center)
				.font(.system(size: 25))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
		}
		.onAppear(perform: {
			if isMainView {
				DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
					withAnimation {
						sharedViewModel.shouldShowMainView.toggle()
					}
				})
			}
		})
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification, object: nil)) { notification in
			print(notification)
		}
	}
}
