//
//  TaskListCell.swift
//  AniLog
//
//  Created by David Fang on 3/20/17.
//  Copyright © 2017 RCDF. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskTag: TaskTagView!
    var taskColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Implement to maintain view consistency when selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            taskTag.backgroundColor = taskColor
        }
    }
    
    // Implement to maintain view consistency when highlighted
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            taskTag.backgroundColor = taskColor
        }
    }
}
