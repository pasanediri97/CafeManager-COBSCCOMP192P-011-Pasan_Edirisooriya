//
//  AccountVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/27/21.
//

import UIKit
import Firebase

class AccountVC: BaseVC {

    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    
    let db = Firestore.firestore()
    var totalPrice = 0
    
    var startDate:Date = Date()
    var endDate:Date = Date()
    
    var arrOrders:[OrderModal] = []
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    
    func getData(){
        startLoading()
        db.collection("orders").addSnapshotListener {
            documents, err in
            self.arrOrders.removeAll()
            self.stopLoading()
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                if let document = documents {
                    for document in documents!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        let resData = document.data() as NSDictionary
                        var itemsarr:[OrderItems] = []
                        for item in resData.value(forKey:"Items") as! [NSDictionary] {
                            let obj = OrderItems(name: item.value(forKey:"name") as! String, price: item.value(forKey:"price") as! String, quentity: item.value(forKey:"quentity") as! Int)
                            self.totalPrice += Int(item.value(forKey:"price") as! String)!
                            itemsarr.append(obj)
                        }
                        let newOrder = OrderModal(id: document.documentID,name: resData.value(forKey:"cus_name") as! String,mobile: resData.value(forKey:"mobile") as! String, time: (resData.value(forKey:"time") as! Timestamp).dateValue().onlyDate!,price: resData.value(forKey:"price") as! Int, status: resData.value(forKey:"status") as! Int,items: itemsarr)
                        
                        //Task(id: nil, name: task.value(forKey:"title") as? String, body: task.value(forKey:"body") as? String)
                        self.arrOrders.append(newOrder)
                    }
                    
                }
                
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = TimeZone.current
                
                if self.arrOrders.count != 0{
 
                    self.lblStartDate.text = formatter.string(from: self.arrOrders[0].time.onlyDate!)
                    self.lblEndDate.text = formatter.string(from: self.arrOrders[self.arrOrders.count - 1].time.onlyDate!)
                }
                
        
                self.lblTotal.text = "Rs. \(self.totalPrice)"
                //                        print("Document data: \(dataDescription)")
                //
                self.tableView.reloadData()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AccountVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AccountMainTVC = self.tableView.dequeueReusableCell(withIdentifier: "AccountMainTVC") as! AccountMainTVC
        cell.selectionStyle = .none
        cell.configureCell(with: arrOrders[indexPath.row])
        return cell
        
        
    }
    
}
