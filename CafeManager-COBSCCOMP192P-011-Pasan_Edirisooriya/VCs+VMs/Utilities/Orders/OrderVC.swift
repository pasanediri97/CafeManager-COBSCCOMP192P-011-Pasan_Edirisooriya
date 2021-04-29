//
//  OrderVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/13/21.
//

import UIKit
import Firebase

struct OrderItems {
    var name:String
    var price:String
    var quentity:Int
}

struct OrderModal {
    var id:String
    var name:String
    var mobile:String
    var time:Date
    var price:Int
    var status:Int
    var items:[OrderItems]
}

class OrderVC: BaseVC {
    
    var arrOrders:[OrderModal] = []
    let db = Firestore.firestore()
    
    var sectionedOrders: [SectionedOrders] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
 
}

extension OrderVC{
    func getData(){
        startLoading()
        db.collection("orders").addSnapshotListener {
         documents, err in
            self.arrOrders.removeAll()
            self.sectionedOrders.removeAll()
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
                            itemsarr.append(obj)
                        }
                        let newOrder = OrderModal(id: document.documentID,name: resData.value(forKey:"cus_name") as! String,mobile: resData.value(forKey:"mobile") as! String, time: (resData.value(forKey:"time") as! Timestamp).dateValue(),price: resData.value(forKey:"price") as! Int, status: resData.value(forKey:"status") as! Int,items: itemsarr)
                        
                        //Task(id: nil, name: task.value(forKey:"title") as? String, body: task.value(forKey:"body") as? String)
                        self.arrOrders.append(newOrder)
                    }
                    
                }
                
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = TimeZone.current
                self.manageSectionDataList() 
            }
        }
    }
    
    func changeStatus(docId:String,status:Int){
        self.startLoading()
        let updateref = self.db.collection("orders").document(docId)
        updateref.updateData([
            "status": status
        ]) { err in
            self.stopLoading()
            if let err = err {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }else{
                self.getData()
            }
        }
    }
    
    
    func groupData(completion: () -> ()){
        
        let new = self.arrOrders.filter({$0.status == 1})
        let rejected = self.arrOrders.filter({$0.status == 2})
        let ready = self.arrOrders.filter({$0.status == 3})
        
        
        if(!new.isEmpty){
            let newSection = SectionedOrders(sectionName:"New(\(new.count))", orders: new)
            self.sectionedOrders.append(newSection)
        }
        
        if(!rejected.isEmpty){
            let rejectedSection = SectionedOrders(sectionName:"Rejected(\(rejected.count))", orders: rejected)
            self.sectionedOrders.append(rejectedSection)
        }
        
        if(!ready.isEmpty){
            let readySection = SectionedOrders(sectionName:"Ready(\(ready.count))", orders: ready)
            self.sectionedOrders.append(readySection)
        }
     
        completion()
    }

    
    func manageSectionDataList() {
        groupData(completion: {
            self.tableView.reloadData()
        })
    }
}

//MARK: TableView Delegate functions

extension OrderVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedOrders.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionedOrders[section].sectionName ?? "Other"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedOrders[section].orders.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderTVC = self.tableView.dequeueReusableCell(withIdentifier: "OrderTVC") as! OrderTVC
        cell.selectionStyle = .none
        cell.onChangeState = { state in
            self.changeStatus(docId: self.sectionedOrders[indexPath.section].orders[indexPath.row].id, status: state)
        }
        cell.configueCell(with: sectionedOrders[indexPath.section].orders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC
        vc?.orderDetails = sectionedOrders[indexPath.section].orders[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "#9B870C")!
    }

    
}

