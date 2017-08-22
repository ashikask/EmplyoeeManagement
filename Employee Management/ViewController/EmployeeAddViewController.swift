//
//  EmPloyeeAddViewController.swift
//  Employee Management
//
//  Created by ashika kalmady on 05/05/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit
import CoreData

class EmployeeAddViewController: UIViewController,UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var addressField: UITextView!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var designationField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let picker = UIImagePickerController()
    var employeeDetail : Employee!
    var isComingFromEdit: Bool = false
    var activeKeyBoard : Any!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        employeeImage.layer.borderWidth = 1.0
        employeeImage.layer.masksToBounds = false
        employeeImage.layer.cornerRadius = employeeImage.frame.size.width * 0.5
        employeeImage.clipsToBounds = true
        
       
        //pre populate if coming for editing
        if isComingFromEdit {
            if employeeDetail != nil {
                
                if let name = employeeDetail.employeeName{
                    nameTextField.text = name
                }
                
                if let designation = employeeDetail.designation{
                    designationField.text = designation
                }
                
                if let dob = employeeDetail.dOB {
                    
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "MM/dd/yyyy"
                    
                    let resultString = inputFormatter.string(from: dob as Date)
                    dobTextField.text = resultString
                    
                }
                if let gender = employeeDetail.gender{
                    genderTextField.text = gender
                }
                
                if let imageData = employeeDetail.profileImage{
                    
                    let image = UIImage(data: imageData as Data)
                    employeeImage.image = image
                    
                }
                
                if let address = employeeDetail.address{
                    addressField.text = address
                }
                
                
                if let hobbies = employeeDetail.hobbies{
                    hobbiesTextField.text = hobbies
                }
                
            }

        }
        
        let gestureTap = UITapGestureRecognizer(target: self, action:  #selector (self.dissmissKeyboard))
        self.view.addGestureRecognizer(gestureTap)
        // Do any additional setup after loading the view.
    }
    
    func dissmissKeyboard(){
        if let textField = activeKeyBoard as? UITextField {
            
            textField.resignFirstResponder()
        }
        else if let textView = activeKeyBoard as? UITextView{
            
            textView.resignFirstResponder()
        }
    }
    //choose image from photo libray and take picture from camera
    
    @IBAction func chooseProfilePic(_ sender: Any) {
        
        let actionSheetController = UIAlertController(title: "Please select", message: "", preferredStyle: .actionSheet)
       //take from camera
        let saveActionButton = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.cameraClicked()
        }
        actionSheetController.addAction(saveActionButton)
        //choose from photolibrary
        let deleteActionButton = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            self.photoLibraryClicked()
        }

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func cameraClicked(){
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
       
    }
    
    func photoLibraryClicked(){
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    //delegarte for imagepicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        employeeImage.backgroundColor = UIColor.clear
        employeeImage.contentMode = .scaleAspectFit
        employeeImage.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        
        dismiss(animated: true, completion: nil)
        
    }

    //on submit save to coredata
    @IBAction func submitClicked(_ sender: Any) {
        
        //check if all mandatory fields are entered
        if employeeImage.image == nil || nameTextField.text == "" || designationField.text == "" || genderTextField.text == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please enter all mandatory fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            if isComingFromEdit{
                updateData()
            }
            else{
            saveToCoreData()
            }
        }
        
        
        
        
    }
    
    //update the existing data
    func updateData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequests :NSFetchRequest<Employee> = Employee.fetchRequest()
        
        fetchRequests.predicate = NSPredicate(format: "employeeId = %i", employeeDetail.employeeId)
        
        
      
        do{
            let results = try managedContext.fetch(fetchRequests)
            
            let managedObject: Employee = results[0]
            
            saveToCoredataGraph(fetchRequests: managedObject)
            
        }
        catch{
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }


    }
    //save enteed field data to core data
    func saveToCoreData() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
       
        let fetchRequests = Employee(context: managedContext)
        
        
        saveToCoredataGraph(fetchRequests : fetchRequests)

        
    }
    
    func saveToCoredataGraph(fetchRequests: Employee){
      
        
        if employeeImage.image != nil {
            let image = employeeImage.image
            let imageData : NSData = UIImageJPEGRepresentation(image!, 1)! as NSData
            fetchRequests.profileImage = imageData
        }
        
        if let name = nameTextField.text, !name.isEmpty {
            fetchRequests.employeeName = name
        }
        
        if let designation = designationField.text, !designation.isEmpty {
            fetchRequests.designation = designation
        }
        
        if let gender = genderTextField.text, !gender.isEmpty {
            fetchRequests.gender = gender
        }
        
        if let dob = dobTextField.text, !dob.isEmpty {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "MM/dd/yyyy"
            
            let resultString = inputFormatter.date(from: dob)
            fetchRequests.dOB = resultString! as NSDate
        }
        
        if let address = addressField.text , !address.isEmpty {
            fetchRequests.address = address
        }
        
        if let hobbies = hobbiesTextField.text , !hobbies.isEmpty {
            fetchRequests.hobbies = hobbies
        }
        
        if !isComingFromEdit{
        fetchRequests.dateCreated = NSDate()
            uniqueId += 1
        fetchRequests.employeeId = Int16(uniqueId)
        }
        
        do{
          try  fetchRequests.managedObjectContext?.save()
            if isComingFromEdit{
             
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: EmployeeListingViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            }
            else{
              
                self.navigationController?.popViewController(animated: false)
            }
        }
        catch{
            let saveError = error as NSError
            print("Unable to Save Note")
            print("\(saveError), \(saveError.localizedDescription)")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
   
    
    
}

//delegates for pop up selection views
extension EmployeeAddViewController: datePickerDelegate , genderPickerDelegate, hobbiesPickerDelegate{
    
    func doneOnDatePicker(dateOfBirth: String) {
        self.view.alpha = 1
        dobTextField.text = dateOfBirth
        
       
    }
    
    func doneOnGender(gender: String) {
        
        genderTextField.text = gender
    }
    
    func doneOnHobbies(gender: [String]) {
        self.view.alpha = 1
        let stringRepresentation = gender.joined(separator: ",")
        hobbiesTextField.text = stringRepresentation
    }
    
    func GetDateFromString(DateStr: String)-> Date
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let DateArray = DateStr.components(separatedBy: "/")
        let components = NSDateComponents()
        components.year = Int(DateArray[2])!
        components.month = Int(DateArray[1])!
        components.day = Int(DateArray[0])! + 1
        let date = calendar?.date(from: components as DateComponents)
        
        return date!
    }
}

//delegate for textview
extension EmployeeAddViewController: UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeKeyBoard = textView
    }
    
}
//delegate for textfield
extension EmployeeAddViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeKeyBoard = textField
        if textField.tag == 3{
           textField.resignFirstResponder()
        }
        
        
    }
    
    //show presented view for date picker
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var shouldShowTextfield : Bool = true
        if textField.tag == 3{
            view.alpha = 0.5
            shouldShowTextfield = false
             self.view.endEditing(true)
            let datePickerViewController = storyboard?.instantiateViewController(withIdentifier: "datePicker") as! DatePickerViewController
            datePickerViewController.delegate = self
            if isComingFromEdit{
                datePickerViewController.dateOfbirth = employeeDetail.dOB! as Date
            }
            datePickerViewController.modalPresentationStyle = .overCurrentContext
            present(datePickerViewController, animated: true, completion: nil)
            
        }
            //show popover for gender selection
        else if textField.tag == 4{
             shouldShowTextfield = false
            textField.resignFirstResponder()
           self.view.endEditing(true)
            
            let popoverViewController = storyboard?.instantiateViewController(withIdentifier: "genderTable") as! GenderTableViewController
            
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.delegate = self
            let popover = popoverViewController.popoverPresentationController
            popover?.permittedArrowDirections = [.up,.down,.left,.right]
            popover?.delegate = self
            popover?.sourceView = textField
            popover?.sourceRect = textField.bounds
            
            self.present(popoverViewController, animated: true, completion: nil)
            
        }
        //show presentation view for hobbie selection
        else if textField.tag == 5{
            shouldShowTextfield = false
            textField.resignFirstResponder()
            self.view.endEditing(true)
            view.alpha = 0.5
            let popoverViewController = storyboard?.instantiateViewController(withIdentifier: "hobbieTable") as! HobbieViewController
            popoverViewController.delegate = self
             popoverViewController.preferredContentSize = CGSize(width: 230, height: 350)
            popoverViewController.modalPresentationStyle = .overCurrentContext
            self.present(popoverViewController, animated: true, completion: nil)
            
        }

       return shouldShowTextfield
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
}
