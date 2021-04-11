//
//  ForgotPasswordVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/11/21.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: BaseVC {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTappedOnSubmit(_ sender: Any) {
        do {
            if try validateForm() {
                startLoading()
                forgetPassowordNetworkRequest()
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
    
    func forgetPassowordNetworkRequest(){
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }else{
                let alert = UIAlertController(title: "Success", message: "The reset email has sent to your email", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    //MARK: Validate Login User
    public func validateLoginUser(completion: (_ status: Bool, _ message: String) -> ()) {
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
            throw ValidateError.invalidData("Invalid Email")
        }
        guard !(value.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Email Empty")
        }
        guard isValidEmailAddress(email: value) else {
            throw ValidateError.invalidData("Invalid Email")
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
