import UIKit

class ShowDescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var _tvShowDescriprionLabel: UILabel!
    @IBOutlet private weak var _tvShowNumberOfEpisodesLabel: UILabel!
    @IBOutlet private weak var _tvShowTitleLabel: UILabel!
    
    func configure(showDescription: String, showTitle: String, numberOfEpisodes: Int) {
        _tvShowDescriprionLabel.text = showDescription  == "" ? "Description not available" : showDescription
        _tvShowTitleLabel.text = showTitle
        _tvShowNumberOfEpisodesLabel.text = "\(numberOfEpisodes)"
    }

}
