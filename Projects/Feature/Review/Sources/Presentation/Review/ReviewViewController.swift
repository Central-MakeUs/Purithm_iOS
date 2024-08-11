//
//  ReviewViewController.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreUIKit
import CoreCommonKit
import Combine

extension ReviewViewController {
    private enum Constants {
        static let backImageIdentifier = "left_back_bar_button"
        static let questionImageIdentifier = "right_question_bar_button"
    }
}

public final class ReviewViewController: ViewController<ReviewView> {
    var cancellables = Set<AnyCancellable>()
    
    private let viewModel: ReviewViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    public init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
        super.init()
        
        initNavigationBar(with: .page)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        let input = ReviewViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            adapterActionEvent: adapter.actionEventPublisher,
            conformButtonTapEvent: contentView.conformButtonTapEvent
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.galleryOpenEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                self?.present(imagePickerController, animated: true, completion: nil)
            }
            .store(in: &cancellables)
        
        output.conformStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.contentView.updateConformButtonState(with: isEnabled)
            }
            .store(in: &cancellables)
        
        output.completeReviewPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentCompleteAlert()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Image Picker
extension ReviewViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.didFinishPickingImageSubject.send(selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - BottomSheet
extension ReviewViewController {
    private func presentContentBottomSheet() {
        let bottomSheetVC = PurithmContentBottomSheet()
        bottomSheetVC.contentModel = PurithmContentModel(
            contentType: .satisfaction,
            title: "필터 만족도",
            description: "퓨어지수는 퓨리즘만의 별점 시스템입니다. 구매 만족도가 높을수록 100%에 가까워요."
        )
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return bottomSheetVC.preferredContentSize.height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        self.present(bottomSheetVC, animated: true, completion: nil)
    }
}

//MARK: - Complete Alert
extension ReviewViewController {
    private func presentCompleteAlert() {
        let stampViewController  = PurithmAnimateAlert<StampAnimateView>()
        stampViewController.modalPresentationStyle = .overCurrentContext
        
        self.present(stampViewController, animated: false)
    }
}

//MARK: - Navigation
extension ReviewViewController: NavigationBarApplicable {
    public func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case Constants.questionImageIdentifier:
            presentContentBottomSheet()
        default:
            break
        }
    }
    
    public var leftButtonItems: [NavigationBarButtonItemType] {
        return [
            .backImage(
                identifier: Constants.backImageIdentifier,
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
    
    public var rightButtonItems: [NavigationBarButtonItemType] {
        return [
            .image(
                identifier: Constants.questionImageIdentifier,
                image: .icQuestion,
                color: .gray500
            )
        ]
    }
}
