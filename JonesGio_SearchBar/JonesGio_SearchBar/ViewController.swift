//
//  ViewController.swift
//  JonesGio_SearchBar
//
//  Created by Gio on 1/30/26.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchSelectionDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    
    var displayedZipcodes: [Zipcode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.dataSource = self
        searchTableView.delegate = self
    }

    // MARK: - Delegate Method
    func didSelectZipcodes(_ results: [Zipcode]) {
        print("Delegate received \(results.count) items") // <--- ADD THIS
        displayedZipcodes = results
        searchTableView.reloadData()
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedZipcodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "zipcodeCell", for: indexPath) as? ZipcodeTableViewCell else {
            return UITableViewCell()
        }
        
        let zipcode = displayedZipcodes[indexPath.row]
        
        cell.cityStateL.text = "\(zipcode.city), \(zipcode.state)"
        cell.populationL.text = "Population: \(zipcode.population)"
        cell.zipcodeL.text = "Zip: \(zipcode.id)"
        
        return cell
    }
    
    // MARK: - ToolBar Actions
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        
        displayedZipcodes.removeAll()
        searchTableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSearchView" {
            let destVC = segue.destination as! SearchViewController
            destVC.delegate = self 
        }
    }
}
