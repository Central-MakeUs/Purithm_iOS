//
//  ReviewTermsAgreementComponent.swift
//  Review
//
//  Created by 이숭인 on 8/11/24.
//


import UIKit
import CoreUIKit
import CoreCommonKit
import Combine
import SnapKit

struct ReviewTermsAgreementComponentModel {
    let identifier: String
    let title: String
    let description: String
}

struct ReviewTermsAgreementComponent: Component {
    var identifier: String
    let title: String
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
    }
}

extension ReviewTermsAgreementComponent {
    typealias ContentType = ReviewTermsAgreementView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(title: context.title, description: context.description)
    }
}

final class ReviewTermsAgreementView: BaseView {
    let titleLabel = PurithmLabel(typography: Constants.titleTypo)
    
    let container = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .white
    }
    
    let descriptionLabel = PurithmLabel(typography: Constants.descriptionTypo).then {
        $0.numberOfLines = 0
    }
    
    let firstBulit = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = " • "
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    let firstLabel = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = "작성하신 수기는 퓨리즘 이용자에게 공개됩니다."
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let secondBulit = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = " • "
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    let secondLabel = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = "후기 작성 시 스탬프 1개가 지급됩니다. 8개 이상의 스탬프를 모을 시 premium 필터를 열람 권한이 부여되고, 16개 이상의 스탬프를 모을 시 premium+ 필터의 열람 권한이 부여됩니다."
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let thirdBulit = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = " • "
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    let thirdLabel = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = "아래에 해당할 경우 지급받은 스탬프가 회수될 수 있습니다."
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let fourthBulit = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = "   "
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    let fourthLabel = PurithmLabel(typography: Constants.smallContentTypo).then {
        $0.text = "-문자 및 기호의 단순 나열, 반복된 내용의 후기\n-필터와 관련 없는 내용의 후기\n-개인정보 및 광고, 비속어가 포함된 내용의 후기\n-관련 없는 사진, 타인의 사진을 도용한 후기"
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let fifthBulit = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = " • "
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    let fifthLabel = PurithmLabel(typography: Constants.contentTypo).then {
        $0.text = "원활한 서비스 이용을 위해 후기 도용 시 스탬프 회수 및 3개월 간의 후기 스탬프 적립 지급이 중단되며, 퓨리즘 서비스 이용에 제한이 발생될 수 있습니다."
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    override func setup() {
        super.setup()
        
        self.backgroundColor = .gray100
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
        addSubview(container)
        
        container.addSubview(descriptionLabel)
        
        container.addSubview(firstBulit)
        container.addSubview(firstLabel)
        
        container.addSubview(secondBulit)
        container.addSubview(secondLabel)
        
        container.addSubview(thirdBulit)
        container.addSubview(thirdLabel)
        
        container.addSubview(fourthBulit)
        container.addSubview(fourthLabel)
        
        container.addSubview(fifthBulit)
        container.addSubview(fifthLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        firstBulit.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(firstLabel.snp.top)
            make.trailing.equalTo(firstLabel.snp.leading)
        }
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(firstBulit.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
        }
        
        secondBulit.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(secondLabel.snp.leading)
            make.top.equalTo(secondLabel.snp.top)
        }
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(20)
            make.leading.equalTo(secondBulit.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
        }
        
        thirdBulit.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(thirdLabel.snp.leading)
            make.top.equalTo(thirdLabel.snp.top)
        }
        thirdLabel.snp.makeConstraints { make in
            make.top.equalTo(secondLabel.snp.bottom).offset(20)
            make.leading.equalTo(thirdBulit.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
        }
        
        fourthBulit.snp.makeConstraints { make in
            make.top.equalTo(fourthLabel.snp.top)
            make.trailing.equalTo(fourthLabel.snp.leading)
            make.leading.equalToSuperview().inset(20)
        }
        fourthLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdLabel.snp.bottom).offset(10)
            make.leading.equalTo(fourthBulit.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
        }
        
        fifthBulit.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(fifthLabel.snp.top)
        }
        fifthLabel.snp.makeConstraints { make in
            make.top.equalTo(fourthLabel.snp.bottom).offset(20)
            make.leading.equalTo(fifthBulit.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

extension ReviewTermsAgreementView {
    private enum Constants {
        static let titleTypo = Typography(size: .size18, weight: .semibold, color: .gray500, applyLineHeight: true)
        static let descriptionTypo = Typography(size: .size14, weight: .semibold, color: .gray400, applyLineHeight: true)
        static let contentTypo = Typography(size: .size14, weight: .semibold, color: .gray300, applyLineHeight: true)
        static let smallContentTypo = Typography(size: .size12, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}
