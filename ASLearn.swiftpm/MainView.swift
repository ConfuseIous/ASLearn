//
//  MainView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 23/4/22.
//

import UIKit
import SwiftUI
import Foundation

struct MainView: UIViewControllerRepresentable {
	@ObservedObject var sharedViewModel: SharedViewModel
	
	func makeUIViewController(context: Context) -> MainViewController {
		let mainViewController = MainViewController(sharedViewModel: sharedViewModel)
		return mainViewController
	}
	
	func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
		
	}
	
	typealias UIViewControllerType = MainViewController
}
