//
//  SearchViewController.swift
//  JonesGio_SearchBar
//
//  Created by Gio on 1/30/26.
//

import Foundation
import UIKit

protocol SearchSelectionDelegate: AnyObject {
    func didSelectZipcodes(_ results: [Zipcode])
}


class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    var allZipcodes: [Zipcode] = []
    var filteredZipcodes: [Zipcode] = []
    weak var delegate: SearchSelectionDelegate?
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the JSON first
        loadJsonData()
        
        // Connect the TableView and SearchBar to this code
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
    }
    
    // MARK: - Navigation / Returning Data
    // Connect this to your "Done" or "Back" button in Storyboard
    @IBAction func returnResults(_ sender: Any) {
        delegate?.didSelectZipcodes(filteredZipcodes)
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Search Logic
    func filterContentForSearchText(_ searchText: String, scopeIndex: Int) {
        filteredZipcodes = allZipcodes.filter { (zipcode: Zipcode) -> Bool in
            
            let doesScopeMatch: Bool
            switch scopeIndex {
            case 1: // "Florida"
                doesScopeMatch = (zipcode.state == "FL")
            case 2: // "California"
                doesScopeMatch = (zipcode.state == "CA")
            default: // "All" (Index 0)
                doesScopeMatch = true
            }
            
            if searchText.isEmpty {
                return doesScopeMatch
            } else {
                return doesScopeMatch && zipcode.city.lowercased().contains(searchText.lowercased())
            }
        }
        searchTableView.reloadData()
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText, scopeIndex: searchBar.selectedScopeButtonIndex)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text ?? "", scopeIndex: selectedScope)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchBar.resignFirstResponder()
        
        
        delegate?.didSelectZipcodes(filteredZipcodes)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredZipcodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. Cast the cell to 'ZipcodeTableViewCell'
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "zipcodeCell", for: indexPath) as? ZipcodeTableViewCell else {
            return UITableViewCell()
        }
        
        let zip = filteredZipcodes[indexPath.row]
        
        cell.cityStateL.text = "\(zip.city), \(zip.state)"
        cell.populationL.text = "Population: \(zip.population)"
        cell.zipcodeL.text = "Zip: \(zip.id)"
        
        return cell
    }
    
    // MARK: - Manual Parsing
    func loadJsonData() {
        guard let path = Bundle.main.path(forResource: "zips", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let jsonArray = jsonResult as? [[String: Any]] {
                for dict in jsonArray {
                    let city = dict["city"] as? String ?? ""
                    let state = dict["state"] as? String ?? ""
                    let population = dict["pop"] as? Int ?? 0
                    let location = dict["loc"] as? [Double] ?? [0.0, 0.0]
                    let id = dict["_id"] as? String ?? ""
                    
                    let newZip = Zipcode(city: city, location: location, population: population, state: state, id: id)
                    allZipcodes.append(newZip)
                }
            }
            filteredZipcodes = allZipcodes
            searchTableView.reloadData()
        } catch {
            print("JSON Parsing Error: \(error)")
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

