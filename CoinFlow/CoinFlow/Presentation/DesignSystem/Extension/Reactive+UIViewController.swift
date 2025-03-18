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
    
    var showErrorAlert: Binder<NetworkError.ErrorDescription> {
        return Binder(base) { base, value in
            let alert = UIAlertController(title: "오류", message: value, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
            base.present(alert, animated: true)
        }
    }
}
