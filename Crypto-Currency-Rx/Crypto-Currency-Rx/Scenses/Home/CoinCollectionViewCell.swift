//
//  CoinCollectionViewCell.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import UIKit
import Reusable
import SDWebImage

final class CoinCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var changeLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    private func setUp() {
        contentView.do {
            $0.layer.cornerRadius = 16
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.masksToBounds = true
        }
        
        layer.do {
            $0.shadowColor = UIColor.lightGray.cgColor
            $0.shadowOffset = CGSize(width: 5.0, height: 5.0)
            $0.shadowRadius = 2.0
            $0.shadowOpacity = 0.5
            $0.masksToBounds = false
            $0.shouldRasterize = true
            $0.rasterizationScale = UIScreen.main.scale
        }
        
        iconImageView.do {
            $0.layer.cornerRadius = 25
        }
    }
    
    func configureCell(coin: Coin) {
        nameLabel.text = coin.name
        changeLabel.formatChange(percentChange: coin.change)
        priceLabel.formatPrice(price: coin.price)
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            iconImageView.sd_setImage(with: url)
        }
    }
}
