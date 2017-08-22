//
//  EmployeeDetailViewController.swift
//  Employee Management
//
//  Created by ashika kalmady on 07/05/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
  
    @IBOutlet weak var addressTopConstrait: NSLayoutConstraint!
    @IBOutlet weak var hobbiesHeading: UILabel!
    @IBOutlet weak var addressHeading: UILabel!
    @IBOutlet weak var hobbiesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
   var employeeDetail : Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width * 0.5
        profileImage.clipsToBounds = true
        
        if employeeDetail != nil {
            
            if let name = employeeDetail.employeeName{
                nameLabel.text = name
            }
            
           
            
            if let dob = employeeDetail.dOB {
                
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "MM/dd/yyyy"
                
                let resultString = inputFormatter.string(from: dob as Date)
                dobLabel.text = resultString
                
            }
            if let gender = employeeDetail.gender{
                genderLabel.text = gender
            }
            
            if let imageData = employeeDetail.profileImage{
                
                let image = UIImage(data: imageData as Data)
                profileImage.image = image
                
            }
            
            if let address = employeeDetail.address{
                addressLabel.text = address
            }
            else{
                addressTopConstrait.constant = 0
                addressLabel.text = ""
                addressHeading.text = ""
            }
            
            if let hobbies = employeeDetail.hobbies{
                hobbiesLabel.text = hobbies
            }
            else{
                hobbiesLabel.text = ""
                hobbiesHeading.text = ""
            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func editClicked(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "employeeEdit") as! EmployeeAddViewController
        
        vc.employeeDetail = employeeDetail
        vc.isComingFromEdit = true
        self.navigationController?.pushViewController(vc, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
