//
//  CompletionPage.swift
//  ASLearn
//
//  Created by Karandeep Singh on 21/4/22.
//

import SwiftUI

struct CompletionPage: View {
	var body: some View {
		VStack {
			Text("Machine Learning models can take months to build and tune.")
				.multilineTextAlignment(.center)
				.font(.system(size:30, weight: .bold))
				.padding()
				.padding(.vertical)
				.fixedSize(horizontal: false, vertical: true)
			Text("ASLearn's ML Model was built in just 10 days with a CoreML Image Classifier - not a custom solution. And the dataset used is still not perfect either, despite my best efforts to pre-process it.")
				.multilineTextAlignment(.center)
				.font(.system(size: 20))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
			Text("At the moment, ASLearn acts as a proof of concept with a functional interface but less than ideal accuracy.")
				.multilineTextAlignment(.center)
				.font(.system(size: 20))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
			Text("But not for long.")
				.foregroundColor(.red)
				.multilineTextAlignment(.center)
				.font(.system(size: 25))
				.padding()
				.padding(.vertical, 20)
				.fixedSize(horizontal: false, vertical: true)
			Text("Even after this submission, I plan to keep working on ASLearn and launching it on the App Store at some point to make learning ASL easy for everyone and thus helping to solve a very real issue.")
				.multilineTextAlignment(.center)
				.font(.system(size: 20))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
			Spacer()
			Image("Thank")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.padding([.top, .horizontal])
				.frame(width: UIScreen.main.bounds.width - 40)
			Text("for using ASLearn. I hope you learnt something useful today!")
				.multilineTextAlignment(.center)
				.font(.system(size: 25))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
			Text("~ Karandeep Singh")
				.foregroundColor(.secondary)
				.multilineTextAlignment(.leading)
				.font(.system(size: 20))
				.padding()
				.fixedSize(horizontal: false, vertical: true)
			Spacer()
		}.statusBar(hidden: true)
	}
}
