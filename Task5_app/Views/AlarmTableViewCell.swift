//
//  TableViewCell.swift
//  Task5_app
//
//  Created by Tolgahan Sonmez on 7.09.2023.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var label_alarmTime: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
