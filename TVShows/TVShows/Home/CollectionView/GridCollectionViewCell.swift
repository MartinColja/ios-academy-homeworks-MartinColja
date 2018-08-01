import UIKit
import Kingfisher

class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var _tvShowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        _tvShowImageView.layer.shadowOpacity = 1.5
        _tvShowImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        _tvShowImageView.layer.shadowRadius = 8.0
        _tvShowImageView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func configure(with item: Show) {
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        _tvShowImageView.kf.setImage(with: url)
    }
}
