//
//  SimpleCoinTableViewCell.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 26/08/2021.
//

import UIKit
import Reusable
import SDWebImage

final class SimpleCoinTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureCell(coin: SimpleCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            iconImageView.sd_setImage(with: url)
        }
    }
}
