import UIKit
import Kingfisher

class ShowImageTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var _tvShowImageView: UIImageView!
    
    func configure (imageUrl: String){
        
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
        _tvShowImageView.kf.setImage(with: url)
    }
}
