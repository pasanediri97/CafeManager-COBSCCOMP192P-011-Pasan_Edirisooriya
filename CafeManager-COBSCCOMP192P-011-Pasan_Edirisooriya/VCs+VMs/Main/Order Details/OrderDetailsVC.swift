//
//  OrderDetailsVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/13/21.
//

import UIKit

class OrderDetailsVC: BaseVC {

    var orderDetails: OrderModal?
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusView.layer.cornerRadius = statusView.frame.size.width / 2
    }
    
    func setData(){
        guard orderDetails != nil else {
            return
        }
        title = "\(orderDetails!.name) (\(orderDetails!.id))"
        switch orderDetails?.status {
        case 1:
            topView.isHidden = true
        case 2:
            lblStatus.text = "Rejected"
            statusView.backgroundColor = .red
        case 3:
            lblStatus.text = "Arriving"
            statusView.backgroundColor = .yellow
        default:
            break;
        }
        tableView.reloadData()
    }
 
    @IBAction func didTappedOnCall(_ sender: Any) {
        if let phoneCallURL:URL = URL(string: "tel:\(orderDetails!.mobile)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    let alertController = UIAlertController(title: "MyApp", message: "Are you sure you want to call \n\(self.orderDetails!.mobile)?", preferredStyle: .alert)
                    let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        application.openURL(phoneCallURL)
                    })
                    let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in

                    })
                    alertController.addAction(yesPressed)
                    alertController.addAction(noPressed)
                    present(alertController, animated: true, completion: nil)
                }
            }
    }
    
}


//MARK: TableView Delegate functions

extension OrderDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return orderDetails!.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderDetailTVC = self.tableView.dequeueReusableCell(withIdentifier: "OrderDetailTVC") as! OrderDetailTVC
        cell.selectionStyle = .none
        
        cell.configureCell(with: orderDetails!.items[indexPath.row])
        return cell
    }
 
    
}

