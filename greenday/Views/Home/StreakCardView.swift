import SwiftUI

struct StreakCardView: View {

    let streak: Int
    let elapsedDays: Int
    let challengeDays: Int
    let completionRate: Double

    private var progress: Double {
        guard challengeDays > 0 else { return 0 }
        return Double(elapsedDays) / Double(challengeDays)
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))

                VStack(alignment: .leading, spacing: 3) {
                    Text("\(streak)일 연속 달성 중")
                        .font(.body).fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.06, green: 0.43, blue: 0.33))
                    Text("챌린지 진행 중")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.12, green: 0.55, blue: 0.42))
                }
                Spacer()
                Text("\(challengeDays)일 중")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.12, green: 0.55, blue: 0.42))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.11, green: 0.62, blue: 0.46).opacity(0.2))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.11, green: 0.62, blue: 0.46))
                        .frame(width: geo.size.width * min(progress, 1.0), height: 6)
                        .animation(.easeInOut(duration: 0.5))
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .background(Color(red: 0.88, green: 0.97, blue: 0.93))
        .cornerRadius(14)
    }
}
