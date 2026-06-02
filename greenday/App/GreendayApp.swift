import SwiftUI

@main
struct GreendayApp: App {

    @AppStorage("isOnboardingDone") private var isOnboardingDone = false
    @StateObject private var challengeVM = ChallengeViewModel()
    @StateObject private var recipeVM    = RecipeViewModel()

    var body: some Scene {
        WindowGroup {
            if isOnboardingDone {
                MainTabView()
                    .environmentObject(challengeVM)
                    .environmentObject(recipeVM)
            } else {
                OnboardingView()
                    .environmentObject(challengeVM)
            }
        }
    }
}
