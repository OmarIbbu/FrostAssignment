//
//  CustomTableViewCell2.swift
//  FrostAssignment
//
//  Created by Marmeto Developer  on 04/02/20.
//  Copyright © 2020 Marmeto Developer . All rights reserved.
//

import UIKit

class CustomTableViewCell2: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        containerView.layer.borderWidth = 0.5
        containerView.layer.cornerRadius = 6
        thumbnail.layer.cornerRadius = 6
        containerView.layer.applySketchShadow()

         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
