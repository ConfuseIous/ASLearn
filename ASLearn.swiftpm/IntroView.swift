import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack {
            Image("icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .padding(.top, 50)
            (
                Text("By 2050, nearly ")
                +
                Text("2.5 billion ")
                    .foregroundColor(.red)
                +
                Text("people will suffer from some degree of hearing loss.")
            )
                .multilineTextAlignment(.center)
                .font(.system(size: 35))
                .padding()
                .padding(.top, 50)
                .fixedSize(horizontal: false, vertical: true)
            Text("As such, Sign Language is a skill of rapidly increasing importance.")
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
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
                .font(.system(size: 25))
                .padding()
                .fixedSize(horizontal: false, vertical: true)
			Spacer()
            NavigationLink(destination: MainView(), label: {
                Image(systemName: "arrow.right.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 70)
                    .foregroundColor(.blue)
			}).onTapGesture(perform: {
				print("tapped")
			})
            Spacer()
            Text("Please note that this playground needs to be run on an iPad with camera access.")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding()
            Text("Reference: Deafness and hearing loss. (2021). World Health Organisation. Retrieved April 07, 2022, from https://www.who.int/news-room/fact-sheets/detail/deafness-and-hearing-loss")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        IntroView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}
