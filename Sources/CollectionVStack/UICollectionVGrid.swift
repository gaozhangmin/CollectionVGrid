import DifferenceKit
import OrderedCollections
import SwiftUI

// TODO: sections of items?
// TODO: animation on layout change parameter

public class UICollectionVGrid<Element: Hashable>: UIView,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{

    private var currentHashes: [Int]
    private var currentLayout: CollectionVGridLayout
    private var data: Binding<OrderedSet<Element>>
    private var itemSize: CGSize!
    private var layout: Binding<CollectionVGridLayout>
    private let onReachedBottomEdge: () -> Void
    private let onReachedBottomEdgeOffset: CGFloat
    private let onReachedTopEdge: () -> Void
    private let onReachedTopEdgeOffset: CGFloat
    private var onReachedEdgeStore: Set<Edge>
    private let viewProvider: (Element) -> any View

    // MARK: init

    public init(
        data: Binding<OrderedSet<Element>>,
        layout: Binding<CollectionVGridLayout>,
        onReachedBottomEdge: @escaping () -> Void,
        onReachedBottomEdgeOffset: CGFloat,
        onReachedTopEdge: @escaping () -> Void,
        onReachedTopEdgeOffset: CGFloat,
        viewProvider: @escaping (Element) -> any View
    ) {
        self.currentHashes = []
        self.currentLayout = layout.wrappedValue
        self.data = data
        self.layout = layout
        self.onReachedBottomEdge = onReachedBottomEdge
        self.onReachedBottomEdgeOffset = onReachedBottomEdgeOffset
        self.onReachedTopEdge = onReachedTopEdge
        self.onReachedTopEdgeOffset = onReachedTopEdgeOffset
        self.onReachedEdgeStore = []
        self.viewProvider = viewProvider

        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = layout.wrappedValue.insets.asUIEdgeInsets
        flowLayout.minimumLineSpacing = layout.wrappedValue.lineSpacing
        flowLayout.minimumInteritemSpacing = layout.wrappedValue.itemSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HostingCollectionViewCell.self, forCellWithReuseIdentifier: HostingCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        return collectionView
    }()

    // MARK: update

    func update(
        with newData: Binding<OrderedSet<Element>>,
        layout: Binding<CollectionVGridLayout>
    ) {

        // data

        let newHashes = newData.wrappedValue.map(\.hashValue)

        let changes = StagedChangeset(
            source: currentHashes,
            target: newHashes,
            section: 0
        )

        data = newData

        collectionView.reload(using: changes) { _ in
            self.currentHashes = newHashes
        }

        // layout

        if layout.wrappedValue != currentLayout {
            currentLayout = layout.wrappedValue

            self.itemSize = nil

            collectionView.flowLayout.sectionInset = layout.wrappedValue.insets.asUIEdgeInsets
            collectionView.flowLayout.minimumLineSpacing = layout.wrappedValue.lineSpacing
            collectionView.flowLayout.minimumInteritemSpacing = layout.wrappedValue.itemSpacing

            // little animation to make instant change a little prettier
            // TODO: - figure out cell size animation if desired

            guard let snapshot = collectionView.snapshotView(afterScreenUpdates: false) else {
                collectionView.reloadData()
                return
            }

            addSubview(snapshot)

            NSLayoutConstraint.activate([
                snapshot.topAnchor.constraint(equalTo: topAnchor),
                snapshot.bottomAnchor.constraint(equalTo: bottomAnchor),
                snapshot.leadingAnchor.constraint(equalTo: leadingAnchor),
                snapshot.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])

            collectionView.alpha = 0
            collectionView.reloadData()

            UIView.animate(withDuration: 0.2) {
                snapshot.alpha = 0
                self.collectionView.alpha = 1
            } completion: { _ in
                snapshot.removeFromSuperview()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentHashes.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HostingCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! HostingCollectionViewCell

        let item = data.wrappedValue[indexPath.row % data.wrappedValue.count]
        cell.setupHostingView(with: viewProvider(item))
        return cell
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if let itemSize {
            return itemSize
        } else {

            let width: CGFloat = switch layout.wrappedValue.layoutType {
            case .columns:
                itemWidth(columns: layout.wrappedValue.layoutValue)
            case .minWidth:
                itemWidth(minWidth: layout.wrappedValue.layoutValue)
            }

            let s = singleItemSize(width: width)
            itemSize = s
            return s
        }
    }

    // MARK: UICollectionViewDelegate

    // required for tvOS
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        false
    }

    // MARK: UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // bottom edge

        let reachBottomPosition = scrollView.contentSize.height - scrollView.bounds.height - onReachedBottomEdgeOffset
        let reachedBottom = scrollView.contentOffset.y >= reachBottomPosition

        if reachedBottom {
            if !onReachedEdgeStore.contains(.bottom) {
                onReachedEdgeStore.insert(.bottom)
                onReachedBottomEdge()
            }
        } else {
            onReachedEdgeStore.remove(.bottom)
        }

        // top edge

        let reachTopPosition = onReachedTopEdgeOffset
        let reachedTop = scrollView.contentOffset.y <= reachTopPosition

        if reachedTop {
            if !onReachedEdgeStore.contains(.top) {
                onReachedEdgeStore.insert(.top)
                onReachedTopEdge()
            }
        } else {
            onReachedEdgeStore.remove(.top)
        }
    }

    // MARK: item sizing

    private func singleItemSize(width: CGFloat) -> CGSize {

        guard !data.wrappedValue.isEmpty else { return .init(width: width, height: 0) }

        let view: AnyView

        if width > 0 {
            view = AnyView(viewProvider(data.wrappedValue[0]).frame(width: width))
        } else {
            view = AnyView(viewProvider(data.wrappedValue[0]))
        }

        let singleItem = UIHostingController(rootView: view)
        singleItem.view.sizeToFit()
        // sizeToFit will sometimes round up, need to account for in CollectionHStack?
        let changeRatio = width / singleItem.view.bounds.size.width
        return singleItem.view.bounds.size * changeRatio
    }

    /// Precondition: columns > 0
    private func itemWidth(columns: CGFloat, trailingInset: CGFloat = 0) -> CGFloat {

        precondition(columns > 0, "Given `columns` is less than or equal to 0")

        let itemSpaces: CGFloat
        let sectionInsets: CGFloat

        if floor(columns) == columns {
            itemSpaces = columns - 1
            sectionInsets = collectionView.flowLayout.sectionInset.horizontal
        } else {
            itemSpaces = floor(columns)
            sectionInsets = collectionView.flowLayout.sectionInset.left
        }

        let itemSpacing = itemSpaces * collectionView.flowLayout.minimumInteritemSpacing
        let totalNegative = sectionInsets + itemSpacing + trailingInset

        return (collectionView.frame.width - totalNegative) / columns
    }

    /// Precondition: minWidth > 0
    private func itemWidth(minWidth: CGFloat) -> CGFloat {

        precondition(minWidth > 0, "Given `minWidth` is less than or equal to 0")

        // Ensure that each item has a given minimum width
        let layout = collectionView.flowLayout
        var columns = CGFloat(Int((collectionView.frame.width - layout.sectionInset.horizontal) / minWidth))

        guard columns != 1 else { return itemWidth(columns: 1) }

        let preItemSpacing = (columns - 1) * layout.minimumInteritemSpacing

        let totalNegative = layout.sectionInset.horizontal + preItemSpacing

        // if adding negative space with current column count would result in column sizes < minWidth
        if columns * minWidth + totalNegative > bounds.width {
            columns -= 1
        }

        return itemWidth(columns: columns)
    }
}
