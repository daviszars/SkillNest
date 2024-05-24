//
//  SkillListTableViewCell.swift
//  SkillNest
//
//  Created by Davis Zarins on 23/05/2024.
//

import UIKit

class SkillListTableViewCell: UITableViewCell {
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.container.layer.borderWidth = 1
        self.container.layer.borderColor = UIColor(red: 2/255, green: 255/255, blue: 200/255, alpha: 1).cgColor
        self.container.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(type: String, desc: String, price: String, location: String, name: String) {
        self.type.text = type
        self.desc.text = desc
        self.price.text = price + "€"
        self.location.text = location
        self.name.text = name
    }
    
}
