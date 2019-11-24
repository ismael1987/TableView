//
//  CountriesViewController.swift
//  emailLogin
//
//  Created by ismael alali on 26.10.19.
//  Copyright © 2019 user158383. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // show the navigation after success login.
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        guard let Index = tableView?.indexPathForSelectedRow else {return}
        // deselect row when returnback
        tableView?.deselectRow(at: Index, animated: true)
        
    }
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        //the navigationBar title "Countries"
        self.title = "Countries"
        tableView?.delegate = self
        tableView?.dataSource = self
        // i use the singleton (RestCall)
        RestCall.shared.getCountries{ (countries) in
            
            if let countries = countries {
                self.countries = countries.documents
                                
            }
            //reload the tableView data
            self.tableView?.reloadData()
            
        }

        // Do any additional setup after loading the view.
    }
    
    var countries: [Country]?
    var selectedCountry: Country?

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let countries = countries {
            
            return countries.count
            
        }
        return 0
    }
    
    //view the country table in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!

        //re-use cells by adding a prototype cell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = countries?[indexPath.row].name
        
        return cell!    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let countries = countries else {return}
        
        
        self.selectedCountry = countries[indexPath.row]
        
        // move to the next page
        self.performSegue(withIdentifier: "segueMoveToDetails", sender: nil)
    }
    
    //send data to CountryDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CountryDetailsViewController
        {
            vc.countryDetails = selectedCountry
        }
        
    }

}
