//
//  DetailViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
import Then
import RxDataSources
import NSObject_Rx
import SDWebImage

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var changeLabel: UILabel!
    @IBOutlet private weak var timeSegmented: UISegmentedControl!
    @IBOutlet private weak var historyChartView: LineChartView!
    @IBOutlet private weak var marketCapLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var circulatingLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var linksTableView: UITableView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: DetailViewModel!
    private var isFavorite = false
    var isLabelAtMaxHeight = false
    var labelHeight = CGFloat(70)
    let selectTimeTrigger = PublishSubject<Select>()
    private let headerRefreshTrigger = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectTimeTrigger.onNext(.threeHours)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configView() {
        linksTableView.do {
            $0.register(cellType: LinkTableViewCell.self)
            $0.rowHeight = 60
        }
        
        historyChartView.do {
            $0.rightAxis.enabled = false
            $0.xAxis.labelPosition = .bottom
            $0.xAxis.axisLineColor = .white
            $0.xAxis.setLabelCount(6, force: false)
            $0.animate(xAxisDuration: 0.5)
        }
        
        timeSegmented.rx.selectedSegmentIndex.asDriver()
            .drive(rx.select)
            .disposed(by: rx.disposeBag)
        
        readMoreButton.rx.tap.asDriver()
            .drive(rx.tap)
            .disposed(by: rx.disposeBag)
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self,
                                             action: #selector(handleRefreshControl),
                                             for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        headerRefreshTrigger.accept(())
        scrollView.refreshControl?.endRefreshing()
    }
    
    private func bindViewModel() {
        let loadTrigger = Driver.merge(Driver.just(()),
                                       headerRefreshTrigger.asDriver(onErrorJustReturn: ()))
        let input = DetailViewModel.Input(
            loadTrigger: loadTrigger,
            loadHistoryTrigger: selectTimeTrigger.asDriver(onErrorJustReturn: .threeHours),
            backTrigger: backButton.rx.tap.asDriver(),
            selectLinkTrigger: linksTableView.rx.itemSelected.asDriver())
        
        let output = viewModel.trasnform(input: input)
        
        output.coin
            .drive(self.rx.coinDetail)
            .disposed(by: rx.disposeBag)
        
        output.history
            .drive(self.rx.history)
            .disposed(by: rx.disposeBag)
        
        output.links
            .drive(linksTableView.rx.items) { (tableView, index, link) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableView.dequeueReusableCell(for: indexPath,
                                                         cellType: LinkTableViewCell.self)
                cell.configureCell(link: link)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.links
            .drive(self.rx.links)
            .disposed(by: rx.disposeBag)
        
        output.voidDriver.forEach {
            $0.drive()
                .disposed(by: rx.disposeBag)
        }
    }
    
}

extension DetailViewController {
    static func instance(navigationController: UINavigationController,
                         uuid: String) -> DetailViewController {
        let detailScreen = DetailViewController()
        let useCase = DetailUseCase(coinRepository: CoinRepository())
        let navigator = DetailNavigator(navigationController: navigationController)
        let viewModel = DetailViewModel(useCase: useCase,
                                        navigator: navigator,
                                        uuid: uuid)
        detailScreen.viewModel = viewModel
        return detailScreen
    }
}

extension DetailViewController {
    func update(coin: CoinDetail) {
        coin.do {
            titleLabel.text = $0.name
            symbolLabel.text = $0.symbol
            changeLabel.formatChange(percentChange: $0.change)
            marketCapLabel.formatMarketCap(marketCap: $0.marketCap)
            volumeLabel.formatMarketCap(marketCap: $0.volume)
            totalLabel.formatTotal(marketCap: $0.total)
            circulatingLabel.formatTotal(marketCap: $0.circulating)
            rankLabel.text = String($0.rank)
            descriptionLabel.text = $0.description.htmlToString
            let pngUrl = $0.iconUrl.replacingOccurrences(of: "svg", with: "png")
            if let url = URL(string: pngUrl) {
                iconImageView.sd_setImage(with: url)
            }
        }
    }
    
    func getLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: .zero).then {
            $0.frame.size.width = width
            $0.font = font
            $0.numberOfLines = 0
            $0.text = text
            $0.sizeToFit()
        }
        return label.frame.size.height
    }
    
    func loadChartData(historyPrice: [History]) {
        let chartEntry = historyPrice.enumerated().map { index, historyPrice -> ChartDataEntry in
            guard let price = Double(historyPrice.price) else {
                return ChartDataEntry(x: Double(index), y: 0)
            }
            return ChartDataEntry(x: Double(index), y: price)
        }
        
        let set = LineChartDataSet(entries: chartEntry, label: "History Price").then {
            $0.drawCirclesEnabled = false
            $0.mode = .linear
            $0.lineWidth = 1
            $0.setColor(.systemGreen)
            $0.fillColor = .systemGreen
            $0.fillAlpha = 0.1
            $0.drawFilledEnabled = true
            $0.drawHorizontalHighlightIndicatorEnabled = false
            $0.highlightColor = .systemGray
        }
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        historyChartView.data = data
    }
    
}

extension Reactive where Base: DetailViewController {
    var coinDetail: Binder<CoinDetail> {
        return Binder(self.base) { controller, coinDetail in
            controller.update(coin: coinDetail)
            controller.labelHeight = controller.getLabelHeight(
                text: coinDetail.description,
                width: controller.view.bounds.width,
                font: controller.descriptionLabel.font)
        }
    }
    
    var links: Binder<[Link]> {
        return Binder(self.base) { controller, links in
            controller.tableViewHeight.constant = CGFloat(60 * links.count)
        }
    }
    
    var history: Binder<[History]> {
        return Binder(self.base) { controller, history in
            controller.loadChartData(historyPrice: history)
        }
    }

    var tap: Binder<Void> {
        return Binder(self.base) { controller, _ in
            if controller.isLabelAtMaxHeight {
                controller.readMoreButton.setTitle("Read less", for: .normal)
                controller.isLabelAtMaxHeight = false
                controller.descriptionHeight.constant = 70
            } else {
                controller.readMoreButton.setTitle("Read more", for: .normal)
                controller.isLabelAtMaxHeight = true
                controller.descriptionHeight.constant = controller.labelHeight
            }
        }
    }
  
    var select: Binder<Int> {
        return Binder(self.base) { controller, select in
            switch select {
            case 0:
                controller.selectTimeTrigger.onNext(.threeHours)
            case 1:
                controller.selectTimeTrigger.onNext(.twentyFourHours)
            case 2:
                controller.selectTimeTrigger.onNext(.sevenDays)
            case 4:
                controller.selectTimeTrigger.onNext(.thirtyDays)
            case 5:
                controller.selectTimeTrigger.onNext(.threeMonth)
            default:
                controller.selectTimeTrigger.onNext(.threeHours)
            }
        }
    }
    
}
