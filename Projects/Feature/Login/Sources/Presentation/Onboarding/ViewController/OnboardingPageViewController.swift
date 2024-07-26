//
//  OnboardingPageViewController.swift
//  Login
//
//  Created by 이숭인 on 7/24/24.
//

import UIKit
import SnapKit
import Then
import CoreCommonKit
import CoreUIKit

extension OnboardingPageViewController {
    enum Constants {
        static let loginButtonTypo = Typography(size: .size16, weight: .semibold, color: .white, applyLineHeight: true)
    }
}

public final class OnboardingPageViewController: UIPageViewController {
    private let viewModel: OnboardingViewModel?
    
    private let pageControl = UIPageControl()
    
    let button = PlainButton(type: .filled, variant: .default, size: .xlarge, theme: .default).then {
        $0.text = "로그인"
    }
    private let onboardingPages: [OnboardingViewController] = {
        let page1 = OnboardingViewController(
            image: .bgOnboarding1,
            title: "다양한 감성 필터",
            subTitle: "색감, 장소, 시간 등 다양한 상황에\n어울리는 필터를 찾을 수 있어요."
        )
        
        let page2 = OnboardingViewController(
            image: .bgOnboarding2,
            title: "쉬운 필터 탐색",
            subTitle: "다양한 예시 사진과 원본 비교 기능으로\n원하는 분위기의 필터를 쉽게 찾을 수 있어요."
        )
        
        let page3 = OnboardingViewController(
            image: .bgOnboarding3,
            title: "상세 보정값 무료 열람",
            subTitle: "필터에 쓰인 상세 보정값을 무료로 열람하고\n내 사진에 바로 적용해 보세요."
        )
        
        let page4 = OnboardingViewController(
            image: .bgOnboarding4,
            title: "후기 남기고 프리미엄 필터 열람",
            subTitle: "보정값을 사진에 적용해보고 후기를 남기면 더 다양한 필터의 보정값을 알 수 있어요."
        )
        
        return [page1, page2, page3, page4]
    }()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        view.backgroundColor = .gray100
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupSubviews()
        setupConstraints()
        setupPageControl()
        bindViewModel()
        
        setViewControllers([onboardingPages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        let input = OnboardingViewModel.Input(loginTapEvent: button.tap)
        
        viewModel?.transform(input: input)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = onboardingPages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray200
        pageControl.currentPageIndicatorTintColor = .blue400
    }
    
    private func setupSubviews() {
        [pageControl, button].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).offset(-16)
        }
        
        button.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(where: { $0 === viewController }) else { return nil }
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? onboardingPages[previousIndex] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(where: { $0 === viewController }) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < onboardingPages.count ? onboardingPages[nextIndex] : nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = viewControllers?.first as? OnboardingViewController {
            if let currentIndex = onboardingPages.firstIndex(where: { $0 === currentVC }) {
                pageControl.currentPage = currentIndex
            }
        }
    }
}
