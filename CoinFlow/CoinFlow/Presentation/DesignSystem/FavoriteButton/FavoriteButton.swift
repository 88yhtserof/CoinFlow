//
//  FavoriteButton.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/10/25.
//

import UIKit

import RxSwift
import RxCocoa

final class FavoriteButton: UIButton {
    
    private var nomalConfiguration = UIButton.Configuration.plain()
    private var selectedConfiguration = UIButton.Configuration.plain()
    
    private var viewModel: FavoriteButtonViewModel?
    var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        
        configurationUpdateHandler = { [weak self] button in
            switch button.state {
            case .normal:
                button.configuration = self?.nomalConfiguration
            case .selected:
                button.configuration = self?.selectedConfiguration
            default:
                break
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSelected.toggle()
    }
    
    func bind(viewModel: FavoriteButtonViewModel) {
        
        self.viewModel = viewModel
        
        let input = FavoriteButtonViewModel.Input(isSelectedState: rx.isSelectedState,
                                                  selectButton: rx.tap)
        let output = viewModel.transform(input: input)
        
        output.selectedState
            .drive(rx.isSelected)
            .disposed(by: disposeBag)

    }
}

//MARK: - Configuration
private extension FavoriteButton {
    
    func configureView() {
        
        nomalConfiguration.image = UIImage(systemName: "star")
        nomalConfiguration.baseForegroundColor = CoinFlowColor.title
        
        selectedConfiguration.image = UIImage(systemName: "star.fill")
        selectedConfiguration.baseForegroundColor = CoinFlowColor.title
        selectedConfiguration.baseBackgroundColor = .clear
    }
}

extension Reactive where Base: FavoriteButton {
    var isSelectedState: ControlProperty<Bool> {
        return controlProperty(editingEvents: [.touchUpInside]) { button in
            return button.isSelected
        } setter: { button, value in
            button.isSelected = value
        }
    }
}
