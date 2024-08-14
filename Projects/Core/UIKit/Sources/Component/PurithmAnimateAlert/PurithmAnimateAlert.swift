//
//  PurithmAnimateAlert.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/11/24.
//

import UIKit
import Combine

public final class PurithmAnimateAlert<Content: BaseView>: ViewController<Content> {
    private var cancellables = Set<AnyCancellable>()
    
    public override init() {
        super.init()
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
}
