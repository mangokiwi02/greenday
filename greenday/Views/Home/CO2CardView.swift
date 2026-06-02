import SwiftUI

struct CO2CardView: View {

    let totalCO2: Double
    let treesEquivalent: Double

    private var treeProgress: Double { min(totalCO2 / 54.0, 1.0) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("나의 환경 기여")
                .font(.caption).foregroundColor(.secondary)

            HStack(spacing: 10) {
                CO2StatBox(
                    value: String(format: "%.1fkg", totalCO2),
                    label: "CO₂ 절감",
                    color: Color(red: 0.15, green: 0.44, blue: 0.07)
                )
                CO2StatBox(
                    value: treesEquivalent < 1
                        ? String(format: "%.2f그루", treesEquivalent)
                        : String(format: "%.1f그루", treesEquivalent),
                    label: "나무 심은 효과",
                    color: Color(red: 0.03, green: 0.31, blue: 0.25)
                )
            }

            VStack(alignment: .leading, spacing: 4) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(height: 7)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.11, green: 0.62, blue: 0.46))
                            .frame(width: geo.size.width * treeProgress, height: 7)
                            .animation(.easeInOut(duration: 0.5))
                    }
                }
                .frame(height: 7)
                Text("나무 1그루(54kg)까지 \(Int(treeProgress * 100))%")
                    .font(.caption2).foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}

private struct CO2StatBox: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.subheadline).fontWeight(.bold).foregroundColor(color)
            Text(label).font(.caption2).foregroundColor(color.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(red: 0.88, green: 0.97, blue: 0.93))
        .cornerRadius(10)
    }
}
