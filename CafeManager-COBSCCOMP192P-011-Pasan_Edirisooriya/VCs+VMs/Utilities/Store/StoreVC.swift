//
//  StoreVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/15/21.
//

import UIKit
import Firebase

class StoreVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedSegment:SelectedSegment = .Preview
    let db = Firestore.firestore()
    
    //MARK: Preview
    @IBOutlet weak var foodPreviewView: UIView!
    @IBOutlet weak var foodPreviewTableView: UITableView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var itemView: UIView!
    var foods:[Food] = []
    var sectionedFoods: [SectionTable] = []
    
    //MARK: Category
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var btnAddCategory: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    var categories:[Category] = []
    
    //MARK: Menu+
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var categoryTableHeight: NSLayoutConstraint!
    @IBOutlet weak var txtItem: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtSelectedCategory: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    
    var selectedCategory:Category?
    var pickedImage:Data?
    var isSellAsItem = false
    
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
        btnAddItem.layer.cornerRadius = 8.0
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
            getFoods()
        case .Category:
            getCategories()
            categoryView.isHidden = false
            hideViews(views: [foodPreviewView,itemView])
        case .Menu:
            getCategories()
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
    
    //MARK: Menu+ Actions
    
    @IBAction func didTappedOnAddItem(_ sender: Any) {
        
    }
    
    @IBAction func didTappedOnSell(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSellAsItem = sender.isSelected
    }
    
    @IBAction func didTappedOnDropDownCategory(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            categoryTableHeight.constant =  CGFloat(categories.count * 30)
        }else{
            categoryTableHeight.constant = 0
        }
    }
    @IBAction func didTappedOnPickImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: {(action) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .popover // for iPad
            picker.popoverPresentationController?.sourceView = sender
            picker.popoverPresentationController?.sourceRect = sender.bounds
            picker.delegate = self
            self.present(picker, animated: true, completion: {() -> Void in })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
        }))
        self.present(alert, animated: true, completion: {() -> Void in })
    }
    
    @IBAction func didTappedOnAdd(_ sender: Any) {
        do {
            if try validateForm() {
                startLoading()
                addItemRequest()
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
    
    
}

extension StoreVC{
    // After the user cancels the picer, revert and do nothing
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // After the user picks an image, update the view and Firebase Storage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        guard let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let image = pickedImage.scaleAndCrop(withAspect: true, to: 200),
              let imageData = image.pngData() else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        // TODO: Handle @1x, @3x sizes and on the Storyboard, turn off Content Mode = Aspect Fill (and Clip to Bounds = true)
        
        // Display the picked image
        self.imgItem.image = image
        self.pickedImage = imageData
        
        picker.dismiss(animated: true, completion: nil)
    }
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
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
                self.getCategories()
            }
        }
    }
    
    func getCategories(){
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
                    if self.selectedSegment == .Category{
                        self.categoryTableView.reloadData()
                    }else if self.selectedSegment == .Menu{
                        self.itemTableView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func getFoods(){
        startLoading()
        sectionedFoods.removeAll()
        foods.removeAll()
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
                    self.db.collection("foods").getDocuments
                    { documents, err in
                        self.stopLoading()
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            if let document = documents {
                                for document in documents!.documents {
                                    let resData = document.data() as NSDictionary
                                    let food = Food(snapshot: document, category: resData.value(forKey:"category") as! NSDictionary)
                                    self.foods.append(food)
                                }
                                self.manageSectionDataList()
                            }
                        }
                    }
                }
            }
        }
}

    func deleteCategory(id:String){
        db.collection("categories").document(id).delete() { err in
            self.stopLoading()
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
    
    func addItemRequest(){
        var ref: DocumentReference? = nil
        ref = db.collection("foods").addDocument(data: [
            "name": txtItem.text!,
            "description": txtDescription.text!,
            "price": txtPrice.text!,
            "category": selectedCategory.toDictionnary!,
            "discount": txtDiscount.text ?? "0",
            "isSell": isSellAsItem,
            "storeId" : LocalUser.current()!.id
        ]) { err in
            if let err = err {
                self.stopLoading()
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                
                // Upload the new profile image to Firebase Storage
                let storageRef = Storage.storage().reference().child("shared/\(ref!.documentID)/food-400x400.png")
                let metadata = StorageMetadata(dictionary: ["contentType": "image/png"])
                let uploadTask = storageRef.putData(self.pickedImage!, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        self.stopLoading()
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        
                        print("Error uploading image to Firebase Storage: \(error?.localizedDescription)")
                        return
                    }
                    // Metadata dictionary: bucket, contentType, downloadTokens, downloadURL, [file]name, updated, et al
                    
                    // Log the event with Firebase Analytics
                    Analytics.logEvent("Food_Image", parameters: nil)
                    
                    self.startLoading()
                    storageRef.downloadURL { url, error in
                        self.stopLoading()
                        if let error = error {
                            self.stopLoading()
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            self.startLoading()
                            let updateref = self.db.collection("foods").document(ref!.documentID)
                            updateref.updateData([
                                "imageUrl": url!.absoluteString
                            ]) { err in
                                self.stopLoading()
                                if let err = err {
                                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true)
                                } else {
                                    self.clearItemData()
                                    let alert = UIAlertController(title: "Success", message: "Food added successfully", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func toggleAvalibility(docId:String,state:Bool){
        self.startLoading()
        let updateref = self.db.collection("foods").document(docId)
        updateref.updateData([
            "isSell": state
        ]) { err in
            self.stopLoading()
            if let err = err {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }

    }
}

//MARK: Menu+

extension StoreVC{
    func validateForm() throws -> Bool {
        
        guard (pickedImage != nil) else {
            throw ValidateError.invalidData("Please pick an image")
        }
        
        guard (txtItem.text != nil), let value = txtItem.text,!(value.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Please enter item name")
        }
        
        guard (txtDescription.text != nil), let des = txtDescription.text,!(des.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Please enter description")
        }
        
        guard (txtPrice.text != nil), let price = txtPrice.text,!(price.trimLeadingTralingNewlineWhiteSpaces().isEmpty),Int(price) != nil else {
            throw ValidateError.invalidData("Please enter valid price")
        }
        
        if txtDiscount.text != ""{
            guard let dis = txtDiscount.text,Int(dis) != nil else {
                throw ValidateError.invalidData("Please enter valid discount")
            }
        }
        
        guard (txtSelectedCategory.text != nil), let cate = txtSelectedCategory.text,!(cate.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Please select category")
        }
        
        return true
    }
    
    func clearItemData(){
        for field in [txtItem,txtDescription,txtPrice,txtSelectedCategory,txtDiscount] {
            field?.text = ""
        }
        
        pickedImage = nil
        imgItem.image = #imageLiteral(resourceName: "img-placeholder")
    }
    
    func groupFoodsData(completion: () -> ()){
        for item in categories {
            let items = self.foods.filter({$0.categoryId ?? "" == item.id})
            if items.count > 0{
                let foodSection = SectionTable(sectionName:item.name, foods: items)
                self.sectionedFoods.append(foodSection)
            }
        }
        completion()
    }
    
    func manageSectionDataList() {
        groupFoodsData(completion: {
            self.foodPreviewTableView.reloadData()
        })
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0{
            return sectionedFoods.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0{
        return 40
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 0{
        return sectionedFoods[section].sectionName ?? "Other"
        }else{
            return ""
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 || tableView.tag == 2{
            return categories.count
        }else{
             return sectionedFoods[section].foods.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1{
            return 50
        }else if tableView.tag == 2{
            return 30
        }
        else{
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            let cell:FoodTVC = self.foodPreviewTableView.dequeueReusableCell(withIdentifier: "FoodTVC") as! FoodTVC
            cell.selectionStyle = .none
            cell.onSwitchToggle = { isOn in
                self.toggleAvalibility(docId: self.sectionedFoods[indexPath.section].foods[indexPath.row].id!, state: isOn)
            }
            cell.configureCell(item: sectionedFoods[indexPath.section].foods[indexPath.row])
            
            return cell
        }else if tableView.tag == 1{
            let cell:UITableViewCell = (self.categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell") as UITableViewCell?)!
            cell.selectionStyle = .none
            cell.backgroundColor = .lightGray
            cell.textLabel?.text = self.categories[indexPath.row].name
            
            return cell
        }else{
            let cell:UITableViewCell = (self.itemTableView.dequeueReusableCell(withIdentifier: "categoryDropdownCell") as UITableViewCell?)!
            cell.selectionStyle = .none
            cell.textLabel?.text = self.categories[indexPath.row].name
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 1{
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: "Confirm", message: "Are you sure want to delete the category?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.deleteCategory(id: self.categories[indexPath.row].id)
                self.getCategories()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 2{
            selectedCategory = categories[indexPath.row]
            txtSelectedCategory.text = categories[indexPath.row].name
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.yellow
    }
    
}
