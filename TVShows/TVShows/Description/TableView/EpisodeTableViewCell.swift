import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet private weak var _tvShowEpisodeNumberLabel: UILabel!
    @IBOutlet private weak var _tvShowEpisodeTitleLabel: UILabel!
    
    func configure(with episodeTitle: String, for season: String, and episodeNumber: String){
        
        _tvShowEpisodeTitleLabel.text = episodeTitle  == "" ? "Title not available" : episodeTitle
        _tvShowEpisodeNumberLabel.text = "S\(_numerise(season)) Ep\(_numerise(episodeNumber))"
    }
    
    //jer inace ak je tekst predug mi se preklapaju labele a ne vjerujem da bi bilo koja serija imala 1000 epizoda u sezoni tako da sam napravio mjesta za troznamenkasti broj  epizode i dvoznamenkasi broj sezone. Mogao sam napravit da se ne preklapaju labele ali onda nisu u razini sve epizode ovo mi se činila kao bolja alternativa
    
    private func _numerise(_ string: String) -> String {
        let string = Int(string) != nil ? string : "?"
        return string
    }
    
     //edit našao sam način za oboje u SB-u pa mogu ovo maknut ali ipak mi je draže da se ne prikazuju slova u sezoni

}
