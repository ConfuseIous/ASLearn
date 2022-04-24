//
//  SharedViewModel.swift
//  ASLearn
//
//  Created by Karandeep Singh on 23/4/22.
//

import Foundation

// This ViewModel is used to sync data between UIKit and SwiftUI.
class SharedViewModel: ObservableObject {
	let alphabets = ["H", "E", "L", "L", "O", "W", "O", "R", "L", "D"]
	
	@Published var shouldShowMainView = false
	@Published var shouldMoveToCompletionView = false
	
	@Published var currentAlphabetIndex = 0
	@Published var predictedLetter = ""
	@Published var confidence: Float = 0
}
