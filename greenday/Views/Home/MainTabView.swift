import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("홈", systemImage: "house") }

            CalendarView()
                .tabItem { Label("달력", systemImage: "calendar") }

            RecipeListView()          
                .tabItem { Label("레시피", systemImage: "book") }

            ProfileView()
                .tabItem { Label("프로필", systemImage: "person") }
        }
        .accentColor(Color(red: 0.11, green: 0.62, blue: 0.46))
    }
}
