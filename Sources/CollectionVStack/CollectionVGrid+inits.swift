import OrderedCollections
import SwiftUI

// MARK: Binding<OrderedSet>

public extension CollectionVGrid {

    init(
        _ data: Binding<OrderedSet<Element>>,
        layout: Binding<CollectionVGridLayout>,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: data,
            layout: layout,
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: Binding<OrderedSet<Element>>,
        layout: CollectionVGridLayout,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: data,
            layout: .constant(layout),
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: Binding<OrderedSet<Element>>,
        layout: Binding<CollectionVGridLayout>,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: data,
            layout: layout,
            viewProvider: viewProvider
        )
    }

    init(
        _ data: Binding<OrderedSet<Element>>,
        layout: CollectionVGridLayout,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: data,
            layout: .constant(layout),
            viewProvider: viewProvider
        )
    }
}

// MARK: Range

public extension CollectionVGrid where Element == Int {

    init(
        _ data: Range<Int>,
        layout: Binding<CollectionVGridLayout>,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: layout,
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: Range<Int>,
        layout: CollectionVGridLayout,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: .constant(layout),
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: Range<Int>,
        layout: Binding<CollectionVGridLayout>,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: layout,
            viewProvider: viewProvider
        )
    }

    init(
        _ data: Range<Int>,
        layout: CollectionVGridLayout,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: .constant(layout),
            viewProvider: viewProvider
        )
    }
}

// MARK: Sequence

public extension CollectionVGrid {

    init(
        _ data: some Sequence<Element>,
        layout: Binding<CollectionVGridLayout>,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: layout,
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: some Sequence<Element>,
        layout: CollectionVGridLayout,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: .constant(layout),
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: some Sequence<Element>,
        layout: Binding<CollectionVGridLayout>,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: layout,
            viewProvider: viewProvider
        )
    }

    init(
        _ data: some Sequence<Element>,
        layout: CollectionVGridLayout,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            layout: .constant(layout),
            viewProvider: viewProvider
        )
    }
}
