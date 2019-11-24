//
//  CountryDetailViewController.swift
//  emailLogin
//
//  Created by ismael alali on 17.11.19.
//  Copyright © 2019 user158383. All rights reserved.
//

import Foundation
import UIKit

class CountryDetailsViewController: UIViewController {
    
    var countryDetails: Country?
    
    //titles of the rows
    let sectionsHeader: [String] = ["Capital", "Currency", "Native", "Phone", "Continent", "Languages",  "ID","Create Time", "Update Time"]
    
    var countryProperties = [ [""], [""], [""], [""], [""], [""], [""], [""], [""] ]
    
    
    @IBOutlet var tableView:UITableView?
    
    //show the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        
        
        self.title = countryDetails?.name
       
        //Array to display the data in rows
        if let countryDetails = countryDetails {
            
            self.countryProperties = [
                ["\(countryDetails.capital)"],
                ["\(countryDetails.currency)"],
                ["\(countryDetails.native)"],
                ["\(countryDetails.phone)"],
                ["\(countryDetails.continent)"],
                countryDetails.languages,
                ["\(countryDetails.ID)"],
                ["\(countryDetails.createTime)"],
                ["\(countryDetails.updateTime)"]
            ]
        }
        
        tableView?.dataSource = self
        
        
    }
    
}

extension CountryDetailsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return  countryProperties.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsHeader[section]
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countryProperties[section].count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let name = countryProperties[indexPath.section][indexPath.row]
        cell?.textLabel?.text = name
        
        return cell!
    }
    
    
}
