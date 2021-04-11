//
//  BaseVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/11/21.
//

import UIKit
import RappleProgressHUD

class BaseVC: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func startLoading(){
        RappleActivityIndicatorView.startAnimating()
    }
    
    func stopLoading(){
        RappleActivityIndicatorView.stopAnimation()
    }
    
    //MARK: This function is used to check the email address validity
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }


 
//    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//    let newViewController = storyBoard.instantiateViewController(withIdentifier: "YourViewController") as! RegisterVC
//    let navigationController = UINavigationController(rootViewController: newViewController)
//    let appdelegate = self.view.window
//    appdelegate?.window!.rootViewController = navigationController

}
