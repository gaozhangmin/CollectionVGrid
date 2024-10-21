import OrderedCollections
import SwiftUI

/// - Important: Currently experimental.
public struct CollectionVList<Element: Hashable>: UIViewRepresentable {

    public typealias UIViewType = UICollectionVList<Element>

    var data: Binding<OrderedSet<Element>>
    var deleteActionProvider: ((Element, CollectionVGridLocation) -> Void)?
    var deleteActionTitle: String
    var headerProvider: () -> any View
    var scrollIndicatorsVisible: Bool
    var viewProvider: (Element, CollectionVGridLocation) -> any View
    
    init(
        data: Binding<OrderedSet<Element>>,
        deleteActionProvider: ((Element, CollectionVGridLocation) -> Void)? = nil,
        deleteActionTitle: String = "Delete",
        headerProvider: @escaping () -> any View,
        scrollIndicatorsVisible: Bool = true,
        viewProvider: @escaping (Element, CollectionVGridLocation) -> any View
    ) {
        self.data = data
        self.deleteActionProvider = deleteActionProvider
        self.deleteActionTitle = deleteActionTitle
        self.headerProvider = headerProvider
        self.scrollIndicatorsVisible = scrollIndicatorsVisible
        self.viewProvider = viewProvider
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        UICollectionVList(
            data: data,
            deleteActionProvider: deleteActionProvider,
            deleteActionTitle: deleteActionTitle,
            headerProvider: headerProvider,
            scrollIndicatorsVisible: scrollIndicatorsVisible,
            viewProvider: viewProvider
        )
    }
    
    public func updateUIView(_ view: UIViewType, context: Context) {
        view.update(with: data)
    }
}
