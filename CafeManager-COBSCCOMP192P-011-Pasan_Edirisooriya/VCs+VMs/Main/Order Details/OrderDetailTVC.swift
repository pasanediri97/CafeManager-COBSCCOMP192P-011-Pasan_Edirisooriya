//
//  OrderDetailTVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/27/21.
//

import UIKit

class OrderDetailTVC: UITableViewCell {

    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with:OrderItems){
        lblQty.text = "\(with.quentity)x"
        lblName.text = with.name
        lblPrice.text = with.price
    }

}
