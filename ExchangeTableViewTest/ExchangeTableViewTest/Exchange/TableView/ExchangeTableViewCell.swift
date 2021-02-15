//
//  ExchangeTableViewCell.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 26.01.2021.
//

import UIKit

class ExchangeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private var currencyModel: Currency?
    
    public func setModelToUI(with model: Currency) {
        self.currencyModel = model
        self.nameLabel.text = model.name
        self.currencyLabel.text = String(model.rate)
        self.codLabel.text = model.cc
    }
}
