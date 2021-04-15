//
//  StoreVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/15/21.
//

import UIKit
import Firebase

class StoreVC: BaseVC {
    
    var selectedSegment:SelectedSegment = .Preview
    let db = Firestore.firestore()
    
    //MARK: Preview
    @IBOutlet weak var foodPreviewView: UIView!
    @IBOutlet weak var foodPreviewTableView: UITableView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var itemView: UIView!
    
    //MARK: Category
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var btnAddCategory: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    var categories:[Category] = []
    
    //MARK: Item
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSegments()
        hideKeyboardWhenTappedAround()
        addListers()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        txtCategory.layer.cornerRadius = 4.0
    }
    
    @IBAction func didSelectSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case SelectedSegment.Preview.rawValue:
            selectedSegment = .Preview
        case SelectedSegment.Category.rawValue:
            selectedSegment = .Category
        case SelectedSegment.Menu.rawValue:
            selectedSegment = .Menu
        default:
            break
        }
        handleSegments()
    }
    
    func handleSegments(){
        switch selectedSegment {
        case .Preview:
            foodPreviewView.isHidden = false
            hideViews(views: [categoryView,itemView])
        case .Category:
            getData()
            categoryView.isHidden = false
            hideViews(views: [foodPreviewView,itemView])
        case .Menu:
            itemView.isHidden = false
            hideViews(views: [categoryView,foodPreviewView])
        }
    }
    
    func hideViews(views:[UIView]){
        for item in views {
            item.isHidden = true
        }
    }
    
    @IBAction func didTappedOnAddCategory(_ sender: Any) {
        addCategory()
    }
    
    @IBAction func didTappedOnAddItem(_ sender: Any) {
        
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

//MARK: Firebase functions

extension StoreVC{
    
    func addCategory(){
        guard let text = txtCategory.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Category is empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        var ref: DocumentReference? = nil
        ref = db.collection("categories").addDocument(data: [
            "name": text,
        ]) { err in
            if let err = err {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.txtCategory.text = ""
                let alert = UIAlertController(title: "Success", message: "Category added successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                self.getData()
            }
        }
    }
    
    func getData(){
        startLoading()
        categories.removeAll()
        db.collection("categories").getDocuments
        { documents, err in
            self.stopLoading()
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                if let document = documents {
                    for document in documents!.documents {
                        let category = Category(snapshot: document)
                        self.categories.append(category)
                    }
                    self.categoryTableView.reloadData()
                }
            }
        }
    }
    
    func deleteCategory(id:String){
        db.collection("categories").document(id).delete() { err in
            if let err = err {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Success", message: "Category deleted successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
}

//MARK: Methods to manage keybaord

extension StoreVC{
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

//MARK: TableView Delegate functions

extension StoreVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell") as UITableViewCell?)!
        cell.selectionStyle = .none
        cell.backgroundColor = .lightGray
        // set the text from the data model
        cell.textLabel?.text = self.categories[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Confirm", message: "Are you sure want to delete the category?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.deleteCategory(id: self.categories[indexPath.row].id)
                self.getData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
}
