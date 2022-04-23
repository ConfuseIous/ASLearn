//
//  SharedViewModel.swift
//  ASLearn
//
//  Created by Karandeep Singh on 23/4/22.
//

import Foundation

class SharedViewModel: ObservableObject {
	@Published var shouldShowMainView = false
	@Published var shouldNavigateToFinalView = false
}
