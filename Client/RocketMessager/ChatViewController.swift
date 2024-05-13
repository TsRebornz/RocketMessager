//
//  ChatViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 04.04.24.
//

import UIKit

// MARK: - Extract to model
enum MessageType {
    case currentUser
    case other
}

struct MessageModel {
    let text: String
    let senderName: String
    let sendDate: Date
    let type: MessageType = .other
}

protocol MessageBuilder {
    func build() -> [MessageModel]
}

// MARK: - Test
final class TestMessageBuilder: MessageBuilder {
    func build() -> [MessageModel] {
        return [
            .init(text: "t1", senderName: "s1", sendDate: Date.now),
            .init(text: "t2", senderName: "s2", sendDate: Date.now),
            .init(text: "t3", senderName: "s3", sendDate: Date.now)
        ]
    }
}

// extract to own file
final class ChatViewCollectionViewCell: UICollectionViewCell {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    func setModel(_ model: MessageModel) {
        textLabel.text = model.text
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .yellow
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate(
            [
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }
}

// TODO: Extract

enum ChatCollectionViewLayoutAlignment {
    case left, right
}

protocol ChatCollectionViewLayoutDelegate: AnyObject {
    var alignment: ChatCollectionViewLayoutAlignment { get }
    func contentSizeFotItem(_ item: IndexPath) -> CGSize
}

private extension MessageType {
    var chatLayoutType: ChatCollectionViewLayoutAlignment {
        switch self {
        case .currentUser:
            .right
        case .other:
            .left
        }
    }
}

final class ChatCollectionViewLayout: UICollectionViewLayout {
    
    enum Constants {
        static let leftRightInset = 16.0
        static let cellVerticalInset = 8.0
    }
    
    let itemEdgeSize: CGFloat = 50.0
    let itemSize = CGSize(width: 50.0, height: 50.0)
    var attributesList = [UICollectionViewLayoutAttributes]()
    weak var delegate: ChatCollectionViewLayoutDelegate?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = attributesList[indexPath.row]
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return self.collectionView?.bounds.size ?? CGSize.zero
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
    }
    
    override func prepare() {
        super.prepare()
    
        self.attributesList = []
        let _: CGFloat = 10.0
        
        guard let collectionView, let delegate else {
            return
        }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        var cellsYPositionsDictionary = [Int: CGFloat]()
        let cellsYPositions = (0...itemsCount).reduce(CGFloat(0.0), { partialResult, itemNum in
            let indexPath = IndexPath(row: itemNum, section: 0)
            let currentLayoutHeight = Constants.cellVerticalInset + delegate.contentSizeFotItem(indexPath).height
            // FIXME: - Need to debug
            let currentLayout = partialResult + currentLayoutHeight
            cellsYPositionsDictionary[itemNum] = currentLayout
            return currentLayout
        })
        
        for i in 0..<itemsCount {
            let indexPath = IndexPath(row: i, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let section = 0
            attributes.size = delegate.contentSizeFotItem(indexPath)
                        
            switch delegate.alignment {
            case .left:
                attributes.frame.origin.x = Constants.leftRightInset
            case .right:
                attributes.frame.origin.x = collectionView.bounds.width
                    - Constants.leftRightInset
                    - delegate.contentSizeFotItem(indexPath).width
            }
            attributes.frame.origin.y = cellsYPositionsDictionary[i] ?? 0.0
            attributesList.append(attributes)
        }
    }
}

final class ChatViewController: UIViewController {
    
    private let messageBuilder: MessageBuilder = TestMessageBuilder()
    private lazy var messages: [MessageModel] = messageBuilder.build()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        setupLayout()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    // MARK: - Private methods
    
    private func setupLayout() {
        // FIXME: - Extract UICollectionView building
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cell: ChatViewCollectionViewCell.self)
        collectionView.dataSource = self
        view.addSubview(collectionView)
                        
        NSLayoutConstraint.activate(
            [
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ChatViewCollectionViewCell = collectionView.dequeue(for: indexPath) else {
            return UICollectionViewCell()
        }
        let model = messages[indexPath.row]
        cell.setModel(model)
        return cell
    }
}
