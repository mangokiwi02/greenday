import SwiftUI

struct VeganLevelSelectView: View {

    var onNext: () -> Void

    @AppStorage("veganLevel") private var savedVeganLevel = 0
    @State private var selected: VeganLevel = .flexitarian

    var body: some View {
        VStack(spacing: 0) {
            ProgressDotsView(current: 0, total: 2)
                .padding(.top, 60)
                .padding(.bottom, 40)

            VStack(alignment: .leading, spacing: 8) {
                Text("비건 단계를 선택하세요")
                    .font(.title2).fontWeight(.bold)
                Text("나에게 맞는 단계로 시작해요.\n나중에 프로필에서 언제든 바꿀 수 있어요.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.bottom, 32)

            VStack(spacing: 12) {
                ForEach(VeganLevel.allCases, id: \.self) { level in
                    VeganLevelCard(level: level, isSelected: selected == level)
                        .onTapGesture { selected = level }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Button(action: {
                savedVeganLevel = selected.rawValue
                onNext()
            }) {
                Text("다음")
                    .font(.body).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green.opacity(0.85))
                    .cornerRadius(14)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

private struct VeganLevelCard: View {
    let level: VeganLevel
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            Text(level.emoji).font(.title2)
            VStack(alignment: .leading, spacing: 3) {
                Text(level.displayName)
                    .font(.body).fontWeight(.semibold)
                    .foregroundColor(isSelected ? Color(red: 0.06, green: 0.43, blue: 0.33) : .primary)
                Text(level.description)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color(red: 0.12, green: 0.55, blue: 0.42) : .secondary)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))
                    .font(.title3)
            }
        }
        .padding(.horizontal, 18).padding(.vertical, 16)
        .background(isSelected ? Color(red: 0.88, green: 0.97, blue: 0.93) : Color(.systemGray6))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color(red: 0.11, green: 0.62, blue: 0.46) : Color.clear, lineWidth: 1.5)
        )
        .animation(.easeInOut(duration: 0.15))
    }
}
