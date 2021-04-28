//
//  FilterPopupVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/28/21.
//

import UIKit

class FilterPopupVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    
    var startDate = Date()
    var endDate = Date()
    
    var onApplyButtonClick: (([Date]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    
    @IBAction func didTappedOnApply(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onApplyButtonClick?([self.startDate,self.endDate])
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartDate{
            // Create a date picker for the date field.
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            if #available(iOS 13.4, *) {
                picker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            picker.addTarget(self, action: #selector(updateStartDateField(sender:)), for: .valueChanged)
            textField.inputView = picker
            textField.text = formatDateForDisplay(date: picker.date)
        }else if textField == txtEndDate{
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.minimumDate = startDate
            if #available(iOS 13.4, *) {
                picker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            picker.addTarget(self, action: #selector(updateEndDateField(sender:)), for: .valueChanged)
            textField.inputView = picker
            textField.text = formatDateForDisplay(date: picker.date)
        }
    }
    
    
    // Called when the date picker changes.
    
    @objc func updateStartDateField(sender: UIDatePicker) {
        txtStartDate.text = formatDateForDisplay(date: sender.date)
        startDate = sender.date
    }
    
    @objc func updateEndDateField(sender: UIDatePicker) {
        txtEndDate.text = formatDateForDisplay(date: sender.date)
        endDate = sender.date
    }
    
    
    // Formats the date chosen with the date picker.
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
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
