import SwiftUI

struct IntroView: View {
	var body: some View {
		NavigationView {
			VStack {
				Image("icon")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 200)
					.padding(.top, 20)
				Spacer()
				(
					Text("By 2050, nearly ")
					+
					Text("2.5 billion ")
						.foregroundColor(.red)
					+
					Text("people will suffer from some degree of hearing loss.")
				)
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Text("As such, Sign Language is a skill of rapidly increasing importance.")
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				(
					Text("ASLearn aims to harness the power of ")
					+
					Text("Machine Learning ")
						.foregroundColor(.blue)
					+
					Text("to teach American Sign Language in a fun and interactive way")
				)
					.multilineTextAlignment(.center)
					.font(.system(size: 30))
					.padding()
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				NavigationLink(destination: OrientationView().navigationBarHidden(true).navigationViewStyle(.stack), label: {
					Image(systemName: "arrow.right.circle.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50)
						.foregroundColor(.blue)
				})
				Spacer()
				Text("Please note that this playground needs to be run on an iPad with camera access.")
					.font(.system(size: 15))
					.multilineTextAlignment(.center)
					.padding([.horizontal, .top])
				Text("Reference: Deafness and hearing loss. (2021). World Health Organisation. Retrieved April 07, 2022, from https://www.who.int/news-room/fact-sheets/detail/deafness-and-hearing-loss")
					.font(.system(size: 15))
					.multilineTextAlignment(.center)
					.foregroundColor(.secondary)
					.padding()
			}
		}
		.navigationBarHidden(true)
		.navigationViewStyle(.stack)
	}
}
