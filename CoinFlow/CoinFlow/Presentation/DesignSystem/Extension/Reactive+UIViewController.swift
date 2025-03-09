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
    
    var viewWillAppear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in () }
      return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { _ in () }
      return ControlEvent(events: source)
    }
}
