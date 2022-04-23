//
//  SharedViewModel.swift
//  ASLearn
//
//  Created by Karandeep Singh on 23/4/22.
//

import Foundation

// This ViewModel is used to sync data between UIKit and SwiftUI.
class SharedViewModel: ObservableObject {
	@Published var shouldShowMainView = false
	
	@Published var actualLetter = ""
	@Published var predictedLetter = ""
	@Published var confidence: Float = 0
}
