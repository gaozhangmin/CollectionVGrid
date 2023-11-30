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
        NavigationView {
            CollectionVGrid(
                $colors,
                layout: .columns(7, insets: .init(10))
            ) { color in
                color
                    .aspectRatio(2 / 3, contentMode: .fill)
                    .cornerRadius(5)
            }
            .navigationTitle("Test")
        }
    }
}
