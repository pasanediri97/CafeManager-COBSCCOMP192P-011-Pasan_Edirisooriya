//
//  RegisterVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterVC: BaseVC {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        addListers()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        btnRegister.layer.cornerRadius = 5.0
    }
    
    @IBAction func didTappedOnRegister(_ sender: Any) {
        do {
            if try validateForm() {
                startLoading()
                registerUser()
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
    
    @IBAction func didTappedOnLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func diTappedOnForgetPassword(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func registerUser(){ 
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { authResult, error in
            if let user = authResult?.user {
                LocalUser.saveLoginData(user: UserModal(id: user.uid, avatarUrl: user.photoURL?.absoluteString ?? "", phoneNo: self.txtPhoneNo.text!, email: user.email ?? ""))
                let userAttrs = ["phone_number": self.txtPhoneNo.text!]
                
                let ref = Database.database().reference().child(user.uid)
                ref.setValue(userAttrs) { (error, ref) in
                    self.stopLoading()
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }else{
                        let nc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationPermissionNC")
                        self.resetWindow(with: nc)
                    }
                }
            }else if let error = error {
                self.stopLoading()
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    //MARK: Validate Login User
    func validateSignUpUser(completion: (_ status: Bool, _ message: String) -> ()) {
        do {
            if try validateForm() {
                completion(true, "Success")
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, "Missing Data")
        }
    }
    
    func validateForm() throws -> Bool {
        guard (txtEmail.text != nil), let value = txtEmail.text else {
            throw ValidateError.invalidData("Email you entered is invalid")
        }
        guard !(value.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Please enter an Email")
        }
        guard isValidEmailAddress(email: value) else {
            throw ValidateError.invalidData("Email you entered is invalid")
        }
        guard (txtPhoneNo.text != nil), let phone = txtPhoneNo.text else {
            throw ValidateError.invalidData("Phone Number you entered is invalid")
        }
        guard !(phone.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Please enter a Phone number")
        }
        
        guard (txtPassword.text != nil), let pwd = txtPassword.text else {
            throw ValidateError.invalidData("Please enter a Password")
        }
        
        guard (pwd.count >= 8) else {
            throw ValidateError.invalidData("Please enter a Password with at least 8 characters")
        }
        
        guard (txtConfirmPassword.text != nil), pwd == txtConfirmPassword.text else {
            throw ValidateError.invalidData("Confirm password is invalid")
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

extension RegisterVC{
    func addListers(){
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
        name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidHide(notification:)),
        name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //MARK: Methods to manage keybaord
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

