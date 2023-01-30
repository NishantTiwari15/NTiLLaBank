//
//  ListTableViewCell.swift
//  NishantCaroselDemo
//
//  Created by webwerks on 30/01/23.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Outlet declaration
    @IBOutlet weak var lableName: UILabel!
    @IBOutlet weak var imgName: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Cell configuration
    func configureCell(_ model: ListModel?) {
        self.selectionStyle = .none
        lableName.text = model?.name
        if let name = model?.imageName {
            imgName.image = UIImage(named: name)
        } else {
            imgName.image = UIImage(named: "placeholder")
        }
    }
}
