import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0

    var body: some View {
        Group {
            if currentStep == 0 {
                VeganLevelSelectView(onNext: { currentStep = 1 })
            } else {
                ChallengePeriodView()
            }
        }
    }
}
