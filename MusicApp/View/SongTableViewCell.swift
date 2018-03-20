//
//  SongTableViewCell.swift
//  MusicApp
//
//  Created by Prasad G on 3/19/18.
//  Copyright © 2018 Prasad G. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicTitleLabel: UILabel!
    
    @IBOutlet weak var musicDescLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
