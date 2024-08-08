//
//  PurithmMenuBottomSheetView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import SnapKit
import Then
import Combine
import CoreCommonKit

public final class PurithmMenuBottomSheetView: BaseView {
    private var cancellables = Set<AnyCancellable>()
    let container = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.backgroundColor = .gray100
    }
    private let tapEventSubject = PassthroughSubject<String, Never>()
    var menuTapEvent: AnyPublisher<String, Never> {
        tapEventSubject.eraseToAnyPublisher()
    }
    
    public override func setupSubviews() {
        addSubview(container)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configure(with menus: [PurithmMenuModel]) {
        let menuList: [PurithmMenuBottomSheetMenuView] = menus.map { menu in
            let menuView = PurithmMenuBottomSheetMenuView()
            menuView.snp.makeConstraints { make in
                make.height.equalTo(58)
            }
            menuView.configure(with: menu)
            menuView.labelTapGesture.tapPublisher
                .sink { [weak self] _ in
                    self?.tapEventSubject.send(menu.identifier)
                }
                .store(in: &cancellables)
            return menuView
        }
        
        menuList.forEach {
            container.addArrangedSubview($0)
        }
    }
}
