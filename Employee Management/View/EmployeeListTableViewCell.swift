//
//  EmployeeListTableViewCell.swift
//  Employee Management
//
//  Created by ashika kalmady on 04/05/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit

class EmployeeListTableViewCell: UITableViewCell {

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var dateOfJoinLabel: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //roundcorner image
        employeeImage.layer.borderWidth = 1.0
        employeeImage.layer.masksToBounds = false
        employeeImage.layer.cornerRadius = employeeImage.frame.size.width * 0.5
        employeeImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
