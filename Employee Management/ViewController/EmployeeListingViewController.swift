//
//  EmplyeeListingViewController.swift
//  Employee Management
//
//  Created by ashika kalmady on 06/05/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit
import CoreData

class EmployeeListingViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var sortlabel: UILabel!
    @IBOutlet weak var totalEmployeeLabel: UILabel!
    @IBOutlet weak var emplyoeeListTable: UITableView!
    @IBOutlet weak var todaysReportLabel: UILabel!

    
    @IBOutlet weak var heightSearchBar: NSLayoutConstraint!
    @IBOutlet weak var topConstraitemployeeList: NSLayoutConstraint!
    
    @IBOutlet weak var searchBarEmployee: UISearchBar!
    
    var sortedKey : String!
    @IBOutlet weak var sortView: UIView!
    var employeeList = [Employee]()
    var singleEmployeeDetail : Employee!
    let appDelegate: AppDelegate =  (UIApplication.shared.delegate as? AppDelegate)!
   
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //refresh array each time
        if employeeList.count > 0 {
        employeeList.removeAll()
        }
        sortedKey = "dateCreated"
        
        //fetch employee list
        fetchEmployeeList(sortBy: sortedKey, searchText: nil)
        fetchTodaysEmployeeList(sortBy: sortedKey, searchText: nil)
        
        
        //tap guesture for sortview
        let gestureTap = UITapGestureRecognizer(target: self, action:  #selector (self.sortClicked(sender:)))
        self.sortView.addGestureRecognizer(gestureTap)
        
        
        //searchbar settings
        topConstraitemployeeList.constant = 0
        heightSearchBar.constant = 0
       

    }
    
    
    //common function to fetch employee
    func fetchEmployee(sortBy:String) -> NSFetchRequest<Employee> {
        
        let fetchRequestss :NSFetchRequest<Employee> = Employee.fetchRequest()
        
        let sortDescriptorss = NSSortDescriptor(key: sortBy, ascending: true)
        fetchRequestss.sortDescriptors = [sortDescriptorss]
        return fetchRequestss
        
    }
    
    //fetch todays employee based on sort order
    func fetchTodaysEmployeeList(sortBy: String, searchText: String?){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = fetchEmployee(sortBy: sortBy)
              // Add Predicate
        
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date())
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)!
        
        // Set predicate as date being today's date
        let datePredicate = NSPredicate(format: "(%@ <= dateCreated) AND (dateCreated < %@)", argumentArray: [dateFrom, dateTo])
        fetchRequest.predicate = datePredicate
        
        if searchText != nil {
            let searchPredicate = NSPredicate(format: "employeeName CONTAINS[c] %@", searchText!)
             fetchRequest.predicate = searchPredicate
            
        }
        
       
        do{
            let results = try managedContext.fetch(fetchRequest)
            
            todaysReportLabel.text = String(describing: results.count)
            
        }
        catch{
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        

        
    }
    
    //fetch all employee list
    func fetchEmployeeList(sortBy: String, searchText: String?){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = fetchEmployee(sortBy: sortBy)
        if searchText != nil {
            let searchPredicate = NSPredicate(format: "employeeName CONTAINS[c] %@", searchText!)
            fetchRequest.predicate = searchPredicate
            
        }
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            
            for result in results{
                employeeList.append(result)
            }
            let StringValue : String = String(describing: results.count)
            totalEmployeeLabel.text = StringValue
            self.emplyoeeListTable.reloadData()
        }
        catch{
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }

        
    }
    
    @IBAction func searchBarClicked(_ sender: Any) {
        
        topConstraitemployeeList.constant = 44
        heightSearchBar.constant = 44
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func sortClicked(sender:UITapGestureRecognizer){
        
        let popoverViewController = storyboard?.instantiateViewController(withIdentifier: "sortTable") as! SortTableViewController
        
        popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverViewController.delegate = self
        let popover = popoverViewController.popoverPresentationController
        popover?.permittedArrowDirections = [.up,.down,.left,.right]
        popover?.delegate = self
        popover?.sourceView = sortView
        popover?.sourceRect = sortView.bounds
        
        self.present(popoverViewController, animated: true, completion: nil)
        
    }
    //relative date String
    func relativedateString(date : Date) -> String{
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: NSDate() as Date)
        
        if components.day! > 0 {
            if components.day! > 1{
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "MM/dd/yyyy"
                
                let resultString = inputFormatter.string(from: date as Date)
                return resultString
            }
                
            else{
                return "Yesterday"
            }
        }
        else{
            return "Today"
        }
    }


}


//serach bar delegate
extension EmployeeListingViewController: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        topConstraitemployeeList.constant = 0
        heightSearchBar.constant = 0
        employeeList.removeAll()
        fetchEmployeeList(sortBy: sortedKey, searchText: nil)
        fetchTodaysEmployeeList(sortBy: sortedKey, searchText: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        employeeList.removeAll()
        fetchEmployeeList(sortBy: sortedKey, searchText: searchBarEmployee.text)
        fetchTodaysEmployeeList(sortBy: sortedKey, searchText: searchBarEmployee.text)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0{
            searchBar.resignFirstResponder()
            employeeList.removeAll()
            fetchEmployeeList(sortBy: sortedKey, searchText: nil)
            fetchTodaysEmployeeList(sortBy: sortedKey, searchText: nil)
            
        }
    }
}
//delegate for sortPickerß
extension EmployeeListingViewController: sortPickerDelegate{
    
    func doneOnSort(sortBy: String) {
        sortlabel.text = sortBy
        
       
        if sortBy == "Name" {
            sortedKey  = "employeeName"
        }
        else if sortBy == "Added Date"{
           sortedKey = "dateCreated"
        }
        else if sortBy == "DOB"
        {
            sortedKey = "dOB"
        }
        employeeList.removeAll()
        fetchEmployeeList(sortBy: sortedKey, searchText: searchBarEmployee.text)
        fetchTodaysEmployeeList(sortBy: sortedKey, searchText: searchBarEmployee.text)
    }
    
    
    
}

//tableview delegate and datasource
extension EmployeeListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "employeeDetail") as! EmployeeDetailViewController
        
        vc.employeeDetail = employeeList[indexPath.row]
        
      self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension EmployeeListingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employeeList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emplyoeeCell", for: indexPath) as! EmployeeListTableViewCell
       
        
        if let name = employeeList[indexPath.row].employeeName{
            cell.employeeName.text = name
        }
        
        if let date = employeeList[indexPath.row].dateCreated{
            
            cell.dateOfJoinLabel.text = relativedateString(date: date as Date)
            
        }
        
        if let dob = employeeList[indexPath.row].dOB {
            
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "MM/dd/yyyy"
            
            let resultString = inputFormatter.string(from: dob as Date)
            cell.dobLabel.text = resultString
            
        }
        if let gender = employeeList[indexPath.row].gender{
            cell.genderLabel.text = gender
        }
        
        if let imageData = employeeList[indexPath.row].profileImage{
            
            let image = UIImage(data: imageData as Data)
            cell.employeeImage.image = image
            
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            appDelegate.persistentContainer.viewContext.delete(employeeList[indexPath.row])
            
            do{
                try appDelegate.persistentContainer.viewContext.save()
                employeeList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

            }
            catch{
                let saveError = error as NSError
                print(saveError)
            }
        }
    }
    
    
}
