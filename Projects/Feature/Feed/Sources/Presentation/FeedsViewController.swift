//
//  FeedsViewController.swift
//  Feed
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import SnapKit

final class FeedsViewController: ViewController<FeedsView> {
    var cancellables = Set<AnyCancellable>()
    let viewModel: FeedsViewModel
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    init(viewModel: FeedsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FeedsViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            adapterActionEvent: adapter.actionEventPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.presentOrderOptionBottomSheetEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentMenuBottomSheet()
            }
            .store(in: &cancellables)
        
        viewModel.reportEventPublisher
            .sink { [weak self] _ in
                self?.presentReportMenuBottomSheet()
            }
            .store(in: &cancellables)
        
        viewModel.presentBlockCompletePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentBlockCompleteAlert()
            }
            .store(in: &cancellables)
        
        output.sectionEmptyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                self?.contentView.showEmptyViewIfNeeded(with: isEmpty)
            }
            .store(in: &cancellables)
        
        viewModel.firstLoadingStatePublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.contentView.showLoadingViewInNeeded(with: isLoading)
            }
            .store(in: &cancellables)
    }
}

//MARK: Present Report Sheet
extension FeedsViewController {
    private func presentBlockCompleteAlert() {
        let alertController = UIAlertController(title: "차단이 완료되었습니다.", message: "해당 작성자의 모든 게시물이 더 이상 표시되지 않습니다.", preferredStyle: .alert)
        
        // 확인 액션 추가
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
        }
        alertController.addAction(okAction)
        
        // 알림 표시
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentReportMenuBottomSheet() {
        let bottomSheetVC = PurithmMenuBottomSheet()
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        bottomSheetVC.menus = viewModel.reportOption.map { option in
            PurithmMenuModel(
                identifier: option.identifier,
                title: option.title,
                isSelected: true
            )
        }
        
        bottomSheetVC.menuTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] identifier in
                let option = FeedReportOption(rawValue: identifier) ?? .report
                
                switch option {
                case .report:
                    self?.presentReportActionSheet()
                case .block:
                    self?.viewModel.requestBlock()
                }
            }
            .store(in: &self.cancellables)
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
    
    private func presentReportActionSheet() {
        let alertController = UIAlertController(
            title: "신고 사유를 선택해주세요.",
            message: "사유에 맞지 않는 신고일 경우, 해당 신고가 처리되지 않을 수 있습니다.\n누적 신고 횟수가 3회 이상인 유저는 리뷰 작성을 할 수 없게 됩니다.",
            preferredStyle: .actionSheet
        )
        
        
        let option1 = UIAlertAction(title: "잘못된 정보", style: .default) { [weak self] (action) in
            self?.presentReportCompleteAlert()
        }
        alertController.addAction(option1)
        
        
        let option2 = UIAlertAction(title: "상업적 광고", style: .default) { [weak self] (action) in
            self?.presentReportCompleteAlert()
        }
        alertController.addAction(option2)
        
        let option3 = UIAlertAction(title: "음란물", style: .default) { [weak self] (action) in
            self?.presentReportCompleteAlert()
        }
        alertController.addAction(option3)
        
        let option4 = UIAlertAction(title: "폭력성", style: .default) { [weak self] (action) in
            self?.presentReportCompleteAlert()
        }
        alertController.addAction(option4)
        
        let option5 = UIAlertAction(title: "기타", style: .default) { [weak self] (action) in
            self?.presentReportCompleteAlert()
        }
        alertController.addAction(option5)
        
        // 취소 액션 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        // 액션 시트 표시
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentReportCompleteAlert() {
        let alertController = UIAlertController(title: "신고 접수가 완료되었습니다.", message: "검토까지는 최대 24시간이 소요됩니다.\n추가 문의사항은 아래 메일로 문의주세요.\npurithm3@gmail.com", preferredStyle: .alert)
        
        // 확인 액션 추가
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
        }
        alertController.addAction(okAction)
        
        // 알림 표시
        present(alertController, animated: true, completion: nil)
    }
}

extension FeedsViewController {
    private func presentMenuBottomSheet() {
        let bottomSheetVC = PurithmMenuBottomSheet()
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        
        bottomSheetVC.menus = viewModel.orderOptions.map { option in
            PurithmMenuModel(
                identifier: option.identifier,
                title: option.option.title,
                isSelected: option.isSelected
            )
        }
        
        bottomSheetVC.menuTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] identifier in
                self?.viewModel.toggleSelectedOrderOption(target: identifier)
                
            }
            .store(in: &self.cancellables)
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}
