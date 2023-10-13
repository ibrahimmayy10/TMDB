//
//  ActorsFavoriteTableViewCell.swift
//  TMDB
//
//  Created by İbrahim Ay on 11.10.2023.
//

import UIKit

class ActorsFavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actorsFavoriteImageView: UIImageView!
    @IBOutlet weak var actorsFavoriteTitleLabel: UILabel!
    @IBOutlet weak var actorsFavoriteDepartmentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
