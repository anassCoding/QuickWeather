//
//  FavoriteController.swift
//  QuickWeather
//
//  Created by m2sar on 29/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class FavoriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var chosenCity : City?
    let defaults = UserDefaults.standard
    var favorites : [City]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = loadFavorites()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favorites?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Favorite", for: indexPath) as! cityCountryCell
        cell.cityLabel.text = favorites![indexPath.row].name
        cell.countryLabel.text = favorites![indexPath.row].country
            //            cell.detailTextLabel?.text = String(filtered[indexPath.row].identifier)
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenCity = favorites![indexPath.row]
        self.performSegue(withIdentifier: "DetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            
            let viewController = segue.destination as! CityController
            
            viewController.chosenCity = self.chosenCity
        }
    }
    
    func loadFavorites() -> [City]? {
        //    func loadFavorites() -> City? {
        let defaults = UserDefaults.standard
        var cities : [City]? = []
        //        var cities : City?
        if let savedData = defaults.object(forKey: "SavedCities") as? Data {
            let decoder = JSONDecoder()
            if let loadedCities = try? decoder.decode([City].self, from: savedData) {
                //            if let loadedCities = try? decoder.decode(City.self, from: savedData) {
                cities = loadedCities
            } else {
                print("No Data Found")
            }
        }
        return cities
    }


}

class cityCountryCell : UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
}
