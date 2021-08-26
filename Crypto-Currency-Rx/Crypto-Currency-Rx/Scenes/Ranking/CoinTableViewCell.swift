//
//  CoinTableViewCell.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 25/08/2021.
//

import UIKit
import Reusable
import SDWebImage
import Then

final class CoinTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var changeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    private func setUp() {
        iconImageView.layer.cornerRadius = 25
        selectionStyle = .none
    }
    
    func configureCell(coin: Coin) {
        nameLabel.text = coin.name
        rankLabel.text = String(coin.rank)
        symbolLabel.text = coin.symbol
        changeLabel.formatChange(percentChange: coin.change)
        priceLabel.formatPrice(price: coin.price)
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            iconImageView.sd_setImage(with: url)
        }
    }
    
}
