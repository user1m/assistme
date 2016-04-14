//
//  DialogTableViewCell.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/29/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import UIKit

class DialogTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var botImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
