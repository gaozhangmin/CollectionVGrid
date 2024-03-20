import Foundation

public class CollectionVGridProxy<Element: Hashable>: ObservableObject {

    weak var collectionVGrid: UICollectionVGrid<Element>?

    public init() {
        self.collectionVGrid = nil
    }

    /// Forces the `CollectionVGrid` to re-layout its views.
    /// This is useful if the layout is the same, but the views
    /// have changed and require re-drawing.
    public func layout() {
        collectionVGrid?.snapshotReload()
    }
}
