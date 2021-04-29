//
//  BaseVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/11/21.
//

import UIKit

class BaseVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let activityView = UIActivityIndicatorView(style: .large)
    let container: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(named: "#FFFCBB")
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func startLoading(){
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .black
        activityView.center = self.view.center

        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating() 
    }
    
    func stopLoading(){
        container.removeFromSuperview()
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
