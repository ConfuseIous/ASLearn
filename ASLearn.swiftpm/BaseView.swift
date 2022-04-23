//
//  BaseView.swift
//  ASLearn
//
//  Created by Karandeep Singh on 23/4/22.
//

import SwiftUI
import Foundation

struct BaseView: View {
	
	@ObservedObject var sharedViewModel = SharedViewModel()
	
	var body: some View {
		NavigationView {
			VStack {
				EmptyView()
					.sheet(isPresented: $sharedViewModel.shouldShowMainView) {
						MainView(sharedViewModel: sharedViewModel)
					}
				Button {
					sharedViewModel.shouldShowMainView.toggle()
					print(sharedViewModel.shouldShowMainView)
				} label: {
					Image(systemName: "arrow.right.circle.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.foregroundColor(.blue)
				}
			}.fullScreenCover(isPresented: $sharedViewModel.shouldShowMainView, content: {
				MainView(sharedViewModel: sharedViewModel).interactiveDismissDisabled()
			})
		}
	}
}
