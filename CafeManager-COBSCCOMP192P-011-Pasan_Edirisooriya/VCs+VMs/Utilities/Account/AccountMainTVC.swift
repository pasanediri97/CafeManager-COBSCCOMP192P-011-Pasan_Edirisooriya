//
//  AccountMainTVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/13/21.
//

import UIKit

class AccountMainTVC: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var outerView: UIView!
    var arrItems:[OrderItems] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.5
        outerView.layer.shadowOffset = .zero
        outerView.layer.shadowRadius = 5
        outerView.layer.cornerRadius = 10.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with:OrderModal){
        lblDateTime.text = convertDateFormater(with.time.description)
        lblTotalPrice.text = "Rs. \(with.price)"
        arrItems = with.items
        tableView.reloadData()
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
}

extension AccountMainTVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AccountTVC = self.tableView.dequeueReusableCell(withIdentifier: "AccountTVC") as! AccountTVC
        cell.selectionStyle = .none
        cell.configCell(with: arrItems[indexPath.row])
        return cell
    }
    
}
