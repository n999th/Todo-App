//
//  TaskCell.swift
//  Todo-App
//
//  Created by Admin on 2/22/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
