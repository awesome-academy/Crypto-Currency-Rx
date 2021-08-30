//
//  ExchangeRatesViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 30/08/2021.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Then

final class ExchangeRatesViewController: UIViewController {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var baseImageView: UIImageView!
    @IBOutlet private weak var baseNameLabel: UILabel!
    @IBOutlet private weak var baseSymbolLabel: UILabel!
    @IBOutlet private weak var baseTextField: UITextField!
    @IBOutlet private weak var targetImageView: UIImageView!
    @IBOutlet private weak var targetNameLabel: UILabel!
    @IBOutlet private weak var targetSymbolLabel: UILabel!
    @IBOutlet private weak var targetTextField: UITextField!
    
    var viewModel: ExchangeRatesViewModel!
    var exchangeRate = "1.0"
    var baseCurrency: SimpleCoin?
    var targetCurrency: SimpleCoin?
    
    let loadPriceTrigger =  PublishSubject<[String]>()
    private let baseCurrencyTrigger = PublishSubject<Void>()
    private let targetCurrencyTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseTextField.becomeFirstResponder()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configView() {
        baseTextField.delegate = self
        targetTextField.delegate = self
        
        let baseTap = UITapGestureRecognizer(target: self,
                                             action: #selector(baseImageTapped))
        baseImageView.isUserInteractionEnabled = true
        baseImageView.addGestureRecognizer(baseTap)
        
        let targetTap = UITapGestureRecognizer(target: self,
                                               action: #selector(targetImageTapped))
        targetImageView.isUserInteractionEnabled = true
        targetImageView.addGestureRecognizer(targetTap)
    }
    
    @objc private func baseImageTapped() {
        baseCurrencyTrigger.onNext(())
    }
    
    @objc private func targetImageTapped() {
        targetCurrencyTrigger.onNext(())
    }
    
    private func bindViewModel() {
        let input = ExchangeRatesViewModel.Input(
            loadCoinTrigger: Driver.just(()),
            loadPriceTrigger: loadPriceTrigger.asDriver(onErrorJustReturn: []),
            backTrigger: backButton.rx.tap.asDriver(),
            selectBaseTrigger: baseCurrencyTrigger.asDriver(onErrorJustReturn: ()),
            selectTargetTrigger: targetCurrencyTrigger.asDriver(onErrorJustReturn: ()))
        
        let output = viewModel.transform(input: input)
        
        output.price
            .drive(rx.price)
            .disposed(by: rx.disposeBag)
        
        output.coin
            .map { $0.first ?? SimpleCoin() }
            .drive(rx.defaultCoin)
            .disposed(by: rx.disposeBag)
            
        output.baseCurrency
            .drive(rx.baseCurrency)
            .disposed(by: rx.disposeBag)
        
        output.targetCurrency
            .drive(rx.targetCurrency)
            .disposed(by: rx.disposeBag)
        
        output.voidDriver
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
}

extension ExchangeRatesViewController {
    static func instance(navigationController: UINavigationController,
                         defaultCurrency: String) -> ExchangeRatesViewController {
        let exchangeRatesScreen = ExchangeRatesViewController()
        let useCase = ExchangeRatesUseCase(coinRepository: CoinRepository())
        let navigator = ExchangeRatesNavigator(navigationController: navigationController)
        let viewModel = ExchangeRatesViewModel(useCase: useCase,
                                               navigator: navigator,
                                               defaultCurrency: defaultCurrency)
        exchangeRatesScreen.viewModel = viewModel
        return exchangeRatesScreen
    }
}

extension ExchangeRatesViewController {
    func configBaseCurrency(coin: SimpleCoin) {
        coin.do {
            baseNameLabel.text = $0.name
            baseSymbolLabel.text = $0.symbol
            let pngUrl = $0.iconUrl.replacingOccurrences(of: "svg", with: "png")
            if let url = URL(string: pngUrl) {
                baseImageView.sd_setImage(with: url)
            }
        }
    }
    
    func configTargetCurrency(coin: SimpleCoin) {
        coin.do {
            targetNameLabel.text = $0.name
            targetSymbolLabel.text = $0.symbol
            let pngUrl = $0.iconUrl.replacingOccurrences(of: "svg", with: "png")
            if let url = URL(string: pngUrl) {
                targetImageView.sd_setImage(with: url)
            }
        }
    }
    
}

extension ExchangeRatesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.becomeFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let exchangeRate = Double(exchangeRate) else {
            return
        }
        
        switch textField {
        case baseTextField:
            guard let text = baseTextField.text,
                  let number = Double(text) else {
                return
            }
            targetTextField.text = String(format: "%.2f", exchangeRate * number)
            
        case targetTextField:
            guard let text = targetTextField.text,
                  let number = Double(text) else {
                return
            }
            baseTextField.text = String(format: "%.2f", number / exchangeRate)
        default:
            return
        }
    }
    
}

extension Reactive where Base: ExchangeRatesViewController {
    var price: Binder<Price> {
        return Binder(self.base) { controller, result in
            controller.exchangeRate = result.price
        }
    }
    
    var defaultCoin: Binder<SimpleCoin> {
        return Binder(self.base) { controller, coin in
            controller.configBaseCurrency(coin: coin)
            controller.configTargetCurrency(coin: coin)
            controller.baseCurrency = coin
            controller.targetCurrency = coin
        }
    }
    
    var baseCurrency: Binder<SimpleCoin> {
        return Binder(self.base) { controller, coin in
            controller.configBaseCurrency(coin: coin)
            controller.baseCurrency = coin
            
            if let base = controller.baseCurrency,
               let target = controller.targetCurrency {
                controller.loadPriceTrigger.onNext([base.uuid, target.uuid])
            }
        }
    }
    
    var targetCurrency: Binder<SimpleCoin> {
        return Binder(self.base) { controller, coin in
            controller.configTargetCurrency(coin: coin)
            controller.targetCurrency = coin
            
            if let base = controller.baseCurrency,
               let target = controller.targetCurrency {
                controller.loadPriceTrigger.onNext([base.uuid, target.uuid])
            }
        }
    }
}
