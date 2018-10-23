//
//  FirstTableViewCell.swift
//  NoName
//
//  Created by Bianka Aristania on 30/05/18.
//  Copyright © 2018 Bianka. All rights reserved.
//

import UIKit
import NightNight

class FirstTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var titleTask: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        load()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func load(){
        let theme = UserDefaults.standard.bool(forKey: "theme")
        if theme {
            NightNight.theme = .night
        } else {
            NightNight.theme = .normal
        }
        titleTask.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        date.mixedTextColor = MixedColor(normal: 0x000000, night: 0xfafafa)
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.mixedBorderColor = MixedColor(normal: 0x000000, night: 0xfafafa)
    }

}
