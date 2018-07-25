//
//  TableViewController.swift
//  TableView
//
//  Created by Infinum Student Academy on 16/07/2018.
//  Copyright © 2018 Sifon.co. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight=44
        }
    }
    
    private let numbers:[Int] = [Int](1...50)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

extension TableViewController: UITableViewDelegate {
    
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "indexPathTableViewCell", for: indexPath) as! indexPathTableViewCell
        
        let item = IndexPathItem(title: "Index path row: \(indexPath.row)")
        
        cell.configure(with: item)
        
        return cell
    }
}
