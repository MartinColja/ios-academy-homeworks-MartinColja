import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet private weak var _tvShowEpisodeNumberLabel: UILabel!

    @IBOutlet weak var _tvShowEpisodeTitleLabel: UILabel!
    
    
    func configure(with episodeTitle: String, for season: Int, and episodeNumber: Int){
        
        _tvShowEpisodeTitleLabel.text = episodeTitle  == "" ? "Title not available" : episodeTitle
        _tvShowEpisodeNumberLabel.text = "S\(season) Ep\(episodeNumber)"
    }
    
    

}
