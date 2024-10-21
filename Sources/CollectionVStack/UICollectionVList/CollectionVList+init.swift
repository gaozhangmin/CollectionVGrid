import OrderedCollections
import SwiftUI

// MARK: Binding<OrderedSet>

public extension CollectionVList {
    
    init(
        _ data: Binding<OrderedSet<Element>>,
        @ViewBuilder headerProvider: @escaping () -> any View,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: data,
            headerProvider: headerProvider,
            viewProvider: { e, _ in viewProvider(e) }
        )
    }
    
    init(
        _ data: Binding<OrderedSet<Element>>,
        @ViewBuilder headerProvider: @escaping () -> any View,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: data,
            headerProvider: headerProvider,
            viewProvider: viewProvider
        )
    }
}

// MARK: Range

public extension CollectionVList where Element == Int {

    init(
        _ data: Range<Int>,
        @ViewBuilder headerProvider: @escaping () -> any View,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            headerProvider: headerProvider,
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: Range<Int>,
        @ViewBuilder headerProvider: @escaping () -> any View,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            headerProvider: headerProvider,
            viewProvider: viewProvider
        )
    }
}

// MARK: Sequence

public extension CollectionVList {

    init(
        _ data: some Sequence<Element>,
        @ViewBuilder headerProvider: @escaping () -> any View,
        @ViewBuilder viewProvider: @escaping (Element) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            headerProvider: headerProvider,
            viewProvider: { e, _ in viewProvider(e) }
        )
    }

    init(
        _ data: some Sequence<Element>,
        @ViewBuilder headerProvider: @escaping () -> any View,
        @ViewBuilder viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.init(
            data: .constant(OrderedSet(data)),
            headerProvider: headerProvider,
            viewProvider: viewProvider
        )
    }
}
