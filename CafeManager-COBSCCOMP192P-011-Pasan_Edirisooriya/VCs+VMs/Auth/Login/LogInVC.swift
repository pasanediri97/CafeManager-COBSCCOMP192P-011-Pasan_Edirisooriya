//
//  LogInVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/11/21.
//

import UIKit
import FirebaseAuth

class LogInVC: BaseVC {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        addListers()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        btnLogin.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func didTappedOnLogin(_ sender: Any) {
        do {
            if try validateLogin() {
                startLoading()
                loginRequest()
            }
        } catch ValidateError.invalidData(let message) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } catch {
            let alert = UIAlertController(title: "Error", message: "Missing Data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func didTappedOnForgotPassword(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didTappedOnSignUp(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func loginRequest(){
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { authResult, error in
            self.stopLoading()
            if let user = authResult?.user {
                LocalUser.saveLoginData(user: UserModal(id: user.uid, avatarUrl: user.photoURL?.absoluteString ?? "", email: user.email ?? ""))
                let nc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarVC")
                self.resetWindow(with: nc)
            }else if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    //MARK: Validate Login User
    public func validateLoginUser(completion: (_ status: Bool, _ message: String) -> ()) {
        do {
            if try validateLogin() {
                completion(true, "Success")
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, "Missing Data")
        }
    }
    
    func validateLogin() throws -> Bool {
        guard (txtEmail.text != nil), let value = txtEmail.text else {
            throw ValidateError.invalidData("Please enter a valid Email")
        }
        guard !(value.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Please enter an email")
        }
        guard isValidEmailAddress(email: value) else {
            throw ValidateError.invalidData("Please enter a valid Email")
        }
        guard !((txtPassword.text ?? "").isEmpty) else {
            throw ValidateError.invalidData("Please enter a passoword")
        }
        return true
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

//MARK: Methods to manage keybaord
extension LogInVC{
    
    func addListers(){
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
        name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidHide(notification:)),
        name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo
        let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
    }

    @objc func keyboardDidHide(notification: NSNotification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
