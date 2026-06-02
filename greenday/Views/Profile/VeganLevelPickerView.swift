import SwiftUI

struct VeganLevelPickerView: View {

    @EnvironmentObject private var challengeVM: ChallengeViewModel
    @AppStorage("veganLevel") private var veganLevelRaw = 0
    @Environment(\.presentationMode) private var presentationMode
    @State private var selected: VeganLevel = .flexitarian

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("비건 단계를 변경하면\n레시피 추천도 함께 바뀌어요")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                VStack(spacing: 12) {
                    ForEach(VeganLevel.allCases, id: \.self) { level in
                        HStack(spacing: 14) {
                            Text(level.emoji).font(.title2)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(level.displayName)
                                    .font(.body).fontWeight(.semibold)
                                    .foregroundColor(
                                        selected == level
                                        ? Color(red: 0.06, green: 0.43, blue: 0.33)
                                        : .primary
                                    )
                                Text(level.description)
                                    .font(.caption)
                                    .foregroundColor(
                                        selected == level
                                        ? Color(red: 0.12, green: 0.55, blue: 0.42)
                                        : .secondary
                                    )
                            }
                            Spacer()
                            if selected == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(red: 0.11, green: 0.62, blue: 0.46))
                                    .font(.title3)
                            }
                        }
                        .padding(.horizontal, 18).padding(.vertical, 16)
                        .background(
                            selected == level
                            ? Color(red: 0.88, green: 0.97, blue: 0.93)
                            : Color(.systemGray6)
                        )
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selected == level
                                    ? Color(red: 0.11, green: 0.62, blue: 0.46)
                                    : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                        .onTapGesture { selected = level }
                        .animation(.easeInOut(duration: 0.15))
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                Button(action: {
                    veganLevelRaw = selected.rawValue
                    challengeVM.veganLevel = selected
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("변경하기")
                        .font(.body).fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.11, green: 0.62, blue: 0.46))
                        .cornerRadius(14)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .navigationTitle("비건 단계 변경")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("닫기") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            selected = VeganLevel(rawValue: veganLevelRaw) ?? .flexitarian
        }
    }
}
