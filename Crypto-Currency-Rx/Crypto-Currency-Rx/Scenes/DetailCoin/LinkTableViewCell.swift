//
//  LinkTableViewCell.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 27/08/2021.
//

import UIKit
import Reusable

final class LinkTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configureCell(link: Link) {
        titleLabel.text = link.name
    }
}
