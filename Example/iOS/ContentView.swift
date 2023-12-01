import CollectionVGrid
import OrderedCollections
import SwiftUI

func colorWheel(radius: Int) -> Color {
    Color(hue: Double(radius) / 360, saturation: 1, brightness: 1)
}

struct ContentView: View {

    @State
    var colors = OrderedSet((0 ..< 360).map { colorWheel(radius: $0) })

    @State
    var layout: CollectionVGridLayout = .columns(6)

    @State
    var columnCount = 3

    var body: some View {
        NavigationView {
            CollectionVGrid(
                $colors,
                layout: $layout
            ) { color in
                color
                    .aspectRatio(1.77, contentMode: .fill)
                    .cornerRadius(5)
            }
            .navigationTitle("Test")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        columnCount += 1
                        layout = .columns((columnCount % 4) + 3)
                    } label: {
                        Text("Toggle")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
