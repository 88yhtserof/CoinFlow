//
//  Reactive+UIViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
}
