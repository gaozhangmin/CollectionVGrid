import SwiftUI

struct ListRow: View {

    @State
    private var contentWidth: CGFloat = 0

    let color: Color
    let orientation: LayoutOrientation

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack(alignment: .center) {
                GridItem(color: color, orientation: orientation)
                    .frame(width: orientation == .landscape ? 110 : 60)
                    .padding(.vertical, 10)

                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(color.description)
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        Text(String(repeating: "A", count: Int.random(in: 4 ..< 12)))
                            .font(.caption)
                            .foregroundColor(Color(UIColor.lightGray))
                            .redacted(reason: .placeholder)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .onSizeChanged { newSize in
                    contentWidth = newSize.width
                }
            }

            Color.secondary
                .opacity(0.75)
                .frame(width: contentWidth, height: 1)
        }
        .padding(.horizontal)
    }
}
