import OrderedCollections
import SwiftUI

public struct CollectionVGrid<Element: Hashable>: UIViewRepresentable {

    public typealias UIViewType = UICollectionVGrid<Element>

    var data: Binding<OrderedSet<Element>>
    var layout: Binding<CollectionVGridLayout>
    var onReachedBottomEdge: () -> Void
    var onReachedBottomEdgeOffset: CGFloat
    var onReachedTopEdge: () -> Void
    var onReachedTopEdgeOffset: CGFloat
    let viewProvider: (Element) -> any View

    init(
        data: Binding<OrderedSet<Element>>,
        layout: Binding<CollectionVGridLayout>,
        onReachedBottomEdge: @escaping () -> Void = {},
        onReachedBottomEdgeOffset: CGFloat = 0,
        onReachedTopEdge: @escaping () -> Void = {},
        onReachedTopEdgeOffset: CGFloat = 0,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.data = data
        self.layout = layout
        self.onReachedBottomEdge = onReachedBottomEdge
        self.onReachedBottomEdgeOffset = onReachedBottomEdgeOffset
        self.onReachedTopEdge = onReachedTopEdge
        self.onReachedTopEdgeOffset = onReachedTopEdgeOffset
        self.viewProvider = viewProvider
    }

    public func makeUIView(context: Context) -> UIViewType {
        UICollectionVGrid(
            data: data,
            layout: layout,
            onReachedBottomEdge: onReachedBottomEdge,
            onReachedBottomEdgeOffset: onReachedBottomEdgeOffset,
            onReachedTopEdge: onReachedTopEdge,
            onReachedTopEdgeOffset: onReachedTopEdgeOffset,
            viewProvider: viewProvider
        )
    }

    public func updateUIView(_ view: UIViewType, context: Context) {
        view.update(
            with: data,
            layout: layout
        )
    }
}
