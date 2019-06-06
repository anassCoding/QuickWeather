//
//  SearchController.swift
//  QuickWeather
//
//  Created by m2sar on 28/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class SearchController: UIViewController, UITableViewDelegate, UISearchBarDelegate,UITableViewDataSource {
    let weatherClient = WeatherClient(key: "849506b7df59e025b14785593373c84b")

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var chosenCity : City?
    var searchActive : Bool = false
//    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count < 2 {
            searchActive = false;
            self.tableView.reloadData()
        } else {
            filtered = weatherClient.citiesSuggestions(for: searchText)
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let viewController = segue.destination as? CityController {
//            viewController.chosenCity = self.chosenCity
//        }
        if segue.identifier == "CitySegue" {

            let viewController = segue.destination as! CityController

            viewController.chosenCity = self.chosenCity
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! cityCell
        if(searchActive){
            cell.cityLabel.text = filtered[indexPath.row].name
            cell.countryLabel.text = filtered[indexPath.row].country
//            cell.detailTextLabel?.text = String(filtered[indexPath.row].identifier)
        } else {
//            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(searchActive) {
            chosenCity = filtered[indexPath.row]
        }
        print(chosenCity?.name)
        self.performSegue(withIdentifier: "CitySegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class cityCell : UITableViewCell{
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
}
