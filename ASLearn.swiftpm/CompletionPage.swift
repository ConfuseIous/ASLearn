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
			Image("ThankYou")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: UIScreen.main.bounds.width - 40)
		}
	}
}
