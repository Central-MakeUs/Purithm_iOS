//
//  TermsNoticeComponent.swift
//  Login
//
//  Created by 이숭인 on 7/18/24.
//

import UIKit
import Combine

import CoreUIKit
import CoreCommonKit

struct TermsNoticeComponent: Component {
    var identifier: String
    let notice: String
    
    init(identifier: String, notice: String) {
        self.identifier = identifier
        self.notice = notice
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(notice)
    }
}

extension TermsNoticeComponent {
    typealias ContentType = TermsNoticeView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.configure(notice: context.notice)
    }
}

final class TermsNoticeView: BaseView {
    let noticeLabel = UILabel(typography: Constants.noticeTypo).then {
        $0.numberOfLines = 0
    }
    
    override func setupSubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        addSubview(noticeLabel)
    }
    
    override func setupConstraints() {
        noticeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(notice: String) {
        noticeLabel.text = notice
    }
}

extension TermsNoticeView {
    enum Constants {
        static let noticeTypo = Typography(size: .size14, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}
