//
//  ComponentContainerCell.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/13/24.
//

import UIKit
import Combine
import SnapKit
import Then

public class ComponentContainerCell<Wrapped: Component>: ItemModelBindable {
    private weak var content: Wrapped.Content? // view
    private var context: Wrapped? // component
    private var cancellable = Set<AnyCancellable>()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellable = Set<AnyCancellable>()
        
        if let content = content {
            context?.prepareForReuse(content: content)
        }
    }
    
    public func bind(with itemModel: ItemModelType) {
        guard let component = itemModel as? Wrapped else { return }
        context = component
    
        bindContent(with: component)
        componentRedering(with: component)
    }
}

extension ComponentContainerCell {
    private func bindContent(with component: Wrapped) {
        content = content ?? component.createContent().then { content in
            contentView.addSubview(content)
            
            content.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.top)
                make.leading.equalTo(contentView.snp.leading)
                make.trailing.equalTo(contentView.snp.trailing)
                make.bottom.equalTo(contentView.snp.bottom)
            }
        }
    }
    
    private func componentRedering(with component: Wrapped) {
        if let content = content, let context = component as? Wrapped.Context {
            component.render(content: content,
                             context: context,
                             cancellable: &cancellable)
        }
    }
}
