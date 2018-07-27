import UIKit
import Kingfisher

class TVShowTableViewCell: UITableViewCell {

    @IBOutlet private weak var _TVShowTitleLabel: UILabel!
    @IBOutlet private weak var _tvShowImageView: UIImageView!
    
    func configure(with item: Show){
        _TVShowTitleLabel.text = item.title
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        _tvShowImageView.kf.setImage(with: url)
    }
    
    override func awakeFromNib() {
        _tvShowImageView.layer.shadowOpacity = 1.5
        _tvShowImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        _tvShowImageView.layer.shadowRadius = 8.0
        _tvShowImageView.layer.shadowColor = UIColor.black.cgColor
    }

}
