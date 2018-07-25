//
//  indexPathTableViewCell.swift
//  TableView
//
//  Created by Infinum Student Academy on 16/07/2018.
//  Copyright © 2018 Sifon.co. All rights reserved.
//

import UIKit

struct IndexPathItem {
    let title: String
    let index: IndexPath
}

class indexPathTableViewCell: UITableViewCell {

    @IBOutlet private weak var indexPathLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        indexPathLabel.text=nil
    }
    
    //basicly ovo je setter
    func configure(with item: IndexPathItem) {
        indexPathLabel.text = item.title
        if ( item.index.count % 2 == 0 ) {
            self.backgroundColor = UIColor.white
        }
    }
}
