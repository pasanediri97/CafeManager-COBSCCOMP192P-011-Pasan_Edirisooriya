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
    var arrOrdersFiltered:[OrderModal] = []
    
    
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
            self.arrOrdersFiltered.removeAll()
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
                        self.arrOrdersFiltered.append(newOrder)
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
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func didTappedOnFilters(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alert = storyboard.instantiateViewController(withIdentifier: "FilterPopupVC") as! FilterPopupVC
        alert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
  
        present(alert, animated: true, completion: nil)
        
//        alert.onCloseButtonClick = {
//            self.dismiss(animated: true, completion: nil)
//        }
        
        alert.onApplyButtonClick = { dates in
            self.arrOrders = self.arrOrdersFiltered.filter({$0.time >= dates[0] && $0.time <= dates[1]})
            self.lblStartDate.text = self.convertDateFormater(dates[0].description)
            self.lblEndDate.text = self.convertDateFormater(dates[1].description)
            self.totalPrice = 0
            for item in self.arrOrders {
                self.totalPrice += item.price
            }
            self.lblTotal.text = "Rs. \(self.totalPrice)"
            self.tableView.reloadData()
        }
  
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didTappedOnLogOut(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure want to Log Out?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        let firebaseAuth = Auth.auth()
         do {
           try firebaseAuth.signOut()
         } catch let signOutError as NSError {
           print ("Error signing out: %@", signOutError)
         }
            self.deleteLocalUserAndSetRoot()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // Delete local user and set root
    func deleteLocalUserAndSetRoot() {
        // Delete Realm current user
        
        guard let user = LocalUser.current() else { return }
        RealmService.shared.delete(user)
        let nc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogInNC")
        self.resetWindow(with: nc)
    }
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
