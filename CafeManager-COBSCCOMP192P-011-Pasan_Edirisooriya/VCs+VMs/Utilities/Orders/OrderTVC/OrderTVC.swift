//
//  OrderTVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/27/21.
//

import UIKit

class OrderTVC: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var onChangeState: ((Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
 
    func setupUI(){
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        mainView.layer.cornerRadius = 5.0
        layoutIfNeeded()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        btnReject.layer.cornerRadius = btnReject.frame.size.width/2
        btnAccept.layer.cornerRadius = btnAccept.frame.size.width/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configueCell(with:OrderModal){
        lblName.text = with.name
        lblId.text = with.id
        switch with.status {
        case 2:
            btnReject.isHidden = true
            btnAccept.setTitle("Rejected", for: .normal)
            btnAccept.isUserInteractionEnabled = false
            btnAccept.backgroundColor = .orange
        case 3:
            btnReject.isHidden = true
            btnAccept.setTitle("Arriving", for: .normal)
            btnAccept.setTitleColor(.black, for: .normal)
            btnAccept.isUserInteractionEnabled = false
            btnAccept.backgroundColor = .yellow
        default:
            break;
        }
    }
    
    @IBAction func didTappedOnButtons(_ sender: UIButton) {
        onChangeState?(sender.tag)
    }
 
}
