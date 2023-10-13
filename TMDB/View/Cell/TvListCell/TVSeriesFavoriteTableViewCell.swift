//
//  TVSeriesFavoriteTableViewCell.swift
//  TMDB
//
//  Created by İbrahim Ay on 11.10.2023.
//

import UIKit

class TVSeriesFavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tvSeriesFavoriteImageView: UIImageView!
    
    @IBOutlet weak var tvSeriesFavoriteTitleLabel: UILabel!
    
    @IBOutlet weak var tvSeriesFavoriteDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
