//
//  PurithmLabel.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import Combine

public class PurithmLabel: UILabel {
    private var textPublisher = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    public override var text: String? {
        didSet { updateFont(with: text) }
    }
    
    private func updateFont(with text: String?) {
        typography?.updateFontTypeForLanguage(for: text)
        
        guard let typography =  typography else { return }
        
        font = typography.font
        textAlignment = typography.alignment
        textColor = typography.color
        applyLineHeight(with: typography, fontLineHeight: font.lineHeight)
    }
}
