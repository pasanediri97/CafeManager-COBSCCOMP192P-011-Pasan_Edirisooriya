//
//  OrderVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/13/21.
//

import UIKit

struct OrderItems {
    var name:String
    var price:Int
    var quentity:Int
}
 
struct OrderModal {
    var id:String
    var time:Date
    var price:Int
    var status:Int
    var items:[OrderItems]
}

class OrderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
