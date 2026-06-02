import SwiftUI

struct ProgressDotsView: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current
                          ? Color(red: 0.11, green: 0.62, blue: 0.46)
                          : Color(.systemGray4))
                    .frame(width: index == current ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 28)
    }
}
