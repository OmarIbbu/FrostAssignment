//
//  CustomTableViewCell1.swift
//  FrostAssignment
//
//  Created by Marmeto Developer  on 04/02/20.
//  Copyright © 2020 Marmeto Developer . All rights reserved.
//

import UIKit

class CustomTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
               containerView.layer.borderWidth = 0.5
        containerView.layer.cornerRadius = 6
        containerView.layer.applySketchShadow()
      

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension CALayer {
    func applySketchShadow(
        color: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0),
        alpha: Float = 0.1,
        x: CGFloat = 0,
        y: CGFloat = 1.5,
        blur: CGFloat = 2.5,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
