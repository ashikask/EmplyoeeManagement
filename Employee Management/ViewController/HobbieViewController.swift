//
//  HobbieViewController.swift
//  Employee Management
//
//  Created by ashika kalmady on 05/05/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit

protocol  hobbiesPickerDelegate {
    func doneOnHobbies(gender: [String])
}

class HobbieViewController: UIViewController {
    
    var arrayHobbierList = [String]()
    var delegate : hobbiesPickerDelegate?
    var arraySelected = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayHobbierList =  ["Cricket","Football","Coding","Reading","Listing Music","Watching Movies","Swimming" ]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneOnHobbieClicked(_ sender: Any) {
        
        print(arraySelected)
        if let delegate = self.delegate {
            delegate.doneOnHobbies(gender: arraySelected)
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



extension HobbieViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayHobbierList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hobbieCell", for: indexPath)
        cell.textLabel?.text = arrayHobbierList[indexPath.row]
        if cell.isSelected
        {
            cell.isSelected = false
            if cell.accessoryType == UITableViewCellAccessoryType.none
            {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        return cell
    }
    

}

extension HobbieViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell!.isSelected
        {
            cell!.isSelected = false
            if cell!.accessoryType == UITableViewCellAccessoryType.none
            {
                cell!.accessoryType = UITableViewCellAccessoryType.checkmark
                arraySelected.append(arrayHobbierList[indexPath.row])
                
            }
            else
            {
                cell!.accessoryType = UITableViewCellAccessoryType.none
                
                if let index = arraySelected.index(of: arrayHobbierList[indexPath.row]) {
                    arraySelected.remove(at: index)
                }

            }
        }
        
    }
    
}
