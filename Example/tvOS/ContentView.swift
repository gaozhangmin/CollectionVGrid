import CollectionVGrid
import OrderedCollections
import SwiftUI

func colorWheel(radius: Int) -> Color {
    Color(hue: Double(radius) / 360, saturation: 1, brightness: 1)
}

struct ContentView: View {

    @State
    var colors = OrderedSet((0 ..< 360).map { colorWheel(radius: $0) })

    var body: some View {
        CollectionVGrid(
            $colors,
            layout: .columns(7, insets: .init(50), itemSpacing: 50, lineSpacing: 50)
        ) { color in
            Button {} label: {
                color
                    .aspectRatio(2 / 3, contentMode: .fill)
                    .cornerRadius(5)
            }
            .buttonStyle(.card)
        }
        .onReachedBottomEdge(offset: 100) {
            print("Reached bottom")
        }
        .onReachedTopEdge(offset: 100) {
            print("Reached top")
        }
        .ignoresSafeArea()
    }
}
