//
//  SideMenuCell.swift
//  SideMenuTutorial
//
//  Created by Carolina Solís on 10/6/22.
//

import Foundation

import Foundation
import UIKit

//Create Side Menu Cell to access all the view controllers
class SideMenuCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Background
        self.backgroundColor = .clear
                
        // Icon
        self.iconImageView.tintColor = .white
                
        // Title
        self.titleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
