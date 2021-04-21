//
//  FoodTVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/21/21.
//

import UIKit

public struct Food{
    var id:Int
    var name:String
    var image:UIImage
    var description:String
    var price:Int
    var off:String? = nil
    var categoryId:Int
}

class FoodTVC: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var swichAvailable: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodImage.layer.cornerRadius = 4.0
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        mainView.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item:Food){
        foodImage.image = item.image
        lblName.text = item.name
        lblDescription.text = item.description
        lblPrice.text = "Rs. \(item.price)"
        if item.off == nil{
            lblOff.isHidden = true
        }else{
            lblOff.text = item.off
        }
    }

}

