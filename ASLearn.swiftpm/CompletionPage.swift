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
			// Talk about how I know it's not perfect but this is just the first iteration
			Image("ThankYou")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: UIScreen.main.bounds.width - 40)
		}
	}
}
