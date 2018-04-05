//
//  UrlTableViewCell.swift
//  UrlChecker
//
//  Created by Sygnoos9 on 4/5/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UrlTableViewCell: UITableViewCell {

    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        indicator.hidesWhenStopped = true
        accessoryView = indicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
