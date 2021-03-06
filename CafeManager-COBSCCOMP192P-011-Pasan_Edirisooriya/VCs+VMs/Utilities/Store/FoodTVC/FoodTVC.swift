//
//  FoodTVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/21/21.
//

import UIKit

class FoodTVC: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var swichAvailable: UISwitch!
    
    var onSwitchToggle: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
  
        // Initialization code
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        foodImage.layer.cornerRadius = 4.0
        mainView.layer.cornerRadius = 5.0
        lblOff.layer.cornerRadius = 4.0
        lblOff.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTappedOnSwitch(_ sender: UISwitch) {
        self.onSwitchToggle?(sender.isOn)
    }
    
    func configureCell(item:Food){
        foodImage.setImageWithUrl(item.imageUrl ?? "")
        lblName.text = item.name
        lblDescription.text = item.description
        lblPrice.text = "Rs. \(item.price ?? "")"
        if item.discount == "0" || item.discount == "" {
            lblOff.isHidden = true
        }else{
            lblOff.text = "\(item.discount ?? "")% off"
        }
        swichAvailable.isOn = item.isSell!
    }

}

