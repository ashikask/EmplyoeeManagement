//
//  DatePickerViewController.swift
//  Employee Management
//
//  Created by ashika kalmady on 05/05/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit
protocol  datePickerDelegate {
    func doneOnDatePicker(dateOfBirth: String)
}
class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePickerDOB: UIDatePicker!
    var delegate : datePickerDelegate?
    
    let dateFormatter = DateFormatter()
    var dOB : String = ""
    var dateOfbirth : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerDOB.datePickerMode = .date
        if dateOfbirth != nil {
        datePickerDOB.date = dateOfbirth
        }
        dateFormatter.dateStyle = DateFormatter.Style.short
        dOB = dateFormatter.string(from: datePickerDOB.date)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func datepickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/YYYY"
        
        dOB = dateFormatter.string(from: sender.date)
        
    }
    @IBAction func doneClickedOnDOB(_ sender: Any) {
        
        if let delegate = self.delegate {
            delegate.doneOnDatePicker(dateOfBirth: dOB)
            self.dismiss(animated: true, completion: nil)
        }
        
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
