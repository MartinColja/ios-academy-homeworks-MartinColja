import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet private weak var _profileImageView: UIImageView!
    @IBOutlet private weak var _usernameLabel: UILabel!
    @IBOutlet private weak var _commentsContentLabel: UILabel!
    
    func config(username: String, comment: String) -> () {
        _usernameLabel.text = username
        _commentsContentLabel.text = comment
        //random image??
    }
}
