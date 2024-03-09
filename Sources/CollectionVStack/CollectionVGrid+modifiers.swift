import SwiftUI

public extension CollectionVGrid {

    func onReachedBottomEdge(offset: CGFloat = 0, action: @escaping () -> Void) -> Self {
        copy(modifying: \.onReachedBottomEdge, to: action)
            .copy(modifying: \.onReachedBottomEdgeOffset, to: offset)
    }

    func onReachedTopEdge(offset: CGFloat = 0, action: @escaping () -> Void) -> Self {
        copy(modifying: \.onReachedTopEdge, to: action)
            .copy(modifying: \.onReachedTopEdgeOffset, to: offset)
    }

    func proxy(_ proxy: CollectionVGridProxy<Element>) -> Self {
        copy(modifying: \.proxy, to: proxy)
    }
}
