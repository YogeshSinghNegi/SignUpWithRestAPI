//
//  ShowSignUpDataVC.swift
//  SignUpWithRestAPI
//
//  Created by appinventiv on 14/09/17.
//  Copyright © 2017 yogesh singh negi. All rights reserved.
//

import UIKit

class ShowSignUpDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var showDeatilsTable: UITableView!
    
    var formData = [String:Any]()
    var placeHolderArray = [String]()
    var showDetailsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showDeatilsTable.delegate = self
        self.showDeatilsTable.dataSource = self
        
        let cell = UINib(nibName: "CellToShowDetailsTableViewCell", bundle: nil)
        self.showDeatilsTable.register(cell, forCellReuseIdentifier: "ShowDetails_ID")
        
        for (tempKey,tempValue) in self.formData {
            self.placeHolderArray.append(tempKey)
            self.showDetailsArray.append(tempValue as! String)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetails_ID") as? CellToShowDetailsTableViewCell else { fatalError("Failed to load the cell") }
        cell.placeholderLabel.text = self.placeHolderArray[indexPath.row]
        cell.detailsLabel.text = self.showDetailsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}
