//
//  FeedImageContainerComponent.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import Combine
import CoreCommonKit
import Then
import SnapKit
import Kingfisher

public struct FeedToDetailMoveAction: ActionEventItem {
    public let identifier: String
}

public struct FeedReportAction: ActionEventItem {
    public let identifier: String
}

public struct FeedDetailImageContainerComponent: Component {
    public var identifier: String
    let review: FeedReviewModel
    let filterInformation: (name: String, thumbnail: String)?
    
    public init(
        identifier: String,
        review: FeedReviewModel,
        filterInformation: (name: String, thumbnail: String)? = nil
    ) {
        self.identifier = identifier
        self.review = review
        self.filterInformation = filterInformation
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(review.imageURLStrings)
        hasher.combine(review.authorProfileURL)
        hasher.combine(review.author)
        hasher.combine(review.content)
        hasher.combine(review.satisfactionLevel)
        hasher.combine(filterInformation?.name)
        hasher.combine(filterInformation?.thumbnail)
    }
    
    public func prepareForReuse(content: FilterDetailImageContainerView) {
        content.imageContainer = nil
    }
}

extension FeedDetailImageContainerComponent {
    public typealias ContentType = FilterDetailImageContainerView
    
    public func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(
            with: context.review,
            information: context.filterInformation
        )
        
        content.blurButton.tap
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(FeedToDetailMoveAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
        
        content.reportButton.tap
            .sink { [weak content] _ in
                content?.actionEventEmitter.send(FeedReportAction(identifier: context.identifier))
            }
            .store(in: &cancellable)
    }
}

public final class FilterDetailImageContainerView: BaseView, ActionEventEmitable {
    public var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    var imageContainer: ImageContainerPageViewController?
    let profileView = PurithmHorizontalProfileView()
    let contentLabel = PurithmLabel(typography: Constants.contentTypo).then {
        $0.numberOfLines = 0
    }
    let reportButton = UIButton().then {
        $0.setImage(.icReport.withTintColor(.red), for: .normal)
    }
    
    let blurButton = PurithmBlurButton(size: .normal).then {
        $0.additionalImage = .icMove.withTintColor(.white)
        $0.shape = .circle
        $0.hasContentShdaow = true
    }
    
    public override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    public override func setupSubviews() {
        guard let imageContainer = imageContainer else { return }
        
        addSubview(imageContainer.view)
        addSubview(profileView)
        addSubview(reportButton)
        addSubview(contentLabel)
        addSubview(blurButton)
    }
    
    public override func setupConstraints() {
        guard let imageContainer = imageContainer else { return }
        
        imageContainer.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(1.25)
        }
        
        blurButton.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.view.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.view.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalTo(reportButton.snp.leading).offset(-16)
        }
        
        reportButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(profileView.snp.centerY)
            make.trailing.equalToSuperview()
            make.leading.equalTo(profileView.snp.trailing).offset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public func configure(
        with review: FeedReviewModel,
        information: (name: String, thumbnail: String)?
    ) {
        imageContainer = ImageContainerPageViewController(imageURLs: review.imageURLStrings)
        contentLabel.text = review.content
        
        profileView.configure(with: PurithmHorizontalProfileModel(
            type: .user,
            satisfactionLevel: review.satisfactionLevel,
            name: review.author,
            profileURLString: review.authorProfileURL
        ))
        
        setupSubviews()
        setupConstraints()
        
        guard let info = information else {
            blurButton.isHidden = true
            return
        }
        
        blurButton.isHidden = false
        blurButton.text = info.name
        
        if let url = URL(string: info.thumbnail) {
            blurButton.image = .placeholderSquareLg
            downloadImageToUIImage(url: url) { [weak self] image in
                self?.blurButton.image = image
            }
        }
    }
    
    private func downloadImageToUIImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        // Kingfisher의 ImageDownloader를 사용하여 이미지를 다운로드
        ImageDownloader.default.downloadImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(nil)
            }
        }
    }
}

extension FilterDetailImageContainerView {
    private enum Constants {
        static let contentTypo = Typography(size: .size16, weight: .medium, color: .gray500, applyLineHeight: true)
    }
}

//MARK: - PageViewController
public final class ImageContainerPageViewController: UIPageViewController {
    private let pageControl = UIPageControl()
    
    private var imagePages: [ImageContainerViewController] = []
    
    init(imageURLs: [String]) {
        imagePages = imageURLs.map { ImageContainerViewController(imageURL: $0) }
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .gray100
        
        if let firstPage = imagePages[safe: 0] {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
        
        setupSubviews()
        setupConstraints()
        setupPageControl()
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = imagePages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray200
        pageControl.currentPageIndicatorTintColor = .blue400
    }
    
    private func setupSubviews() {
        [pageControl].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension ImageContainerPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = imagePages.firstIndex(where: { $0 === viewController }) else { return nil }
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? imagePages[previousIndex] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = imagePages.firstIndex(where: { $0 === viewController }) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < imagePages.count ? imagePages[nextIndex] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = viewControllers?.first as? ImageContainerViewController {
            if let currentIndex = imagePages.firstIndex(where: { $0 === currentVC }) {
                pageControl.currentPage = currentIndex
            }
        }
    }
}


//MARK: - Content Container ViewController
public final class ImageContainerViewController: ViewController<ImageContainerView> {
    var imageURL: String?
    
    init(imageURL: String) {
        self.imageURL = imageURL
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: imageURL ?? "") {
            contentView.imageView.kf.setImage(with: url)
        }
    }
}

public final class ImageContainerView: BaseView {
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    public override func setupSubviews() {
        self.backgroundColor = .gray100
        addSubview(imageView)
    }
    
    public override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
