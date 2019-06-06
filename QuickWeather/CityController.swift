//
//  CityController.swift
//  QuickWeather
//
//  Created by m2sar on 28/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class CityController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var chosenCity : City?
    let weatherClient = WeatherClient(key: "849506b7df59e025b14785593373c84b")
    var forecast : [Forecast]?
    var forecastSegment : [Forecast]?
    var cityNameTest : String?
//    var isFavorite : Bool!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFav: UIButton!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ForecastSegment: UISegmentedControl!
    @IBOutlet weak var testSegment: UILabel!
    @IBOutlet weak var DayForecastView: UICollectionView!
    @IBAction func pressSegment(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }

    @IBAction func press() {
        if addFav.isSelected {
            removeFromFavorites()
            addFav.isSelected = false
            print("removed")
        } else {
           saveToFavorites()
           addFav.isSelected = true
            print("added")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chosenCity)
        tableView.delegate = self
        tableView.dataSource = self
        DayForecastView.delegate = self
        DayForecastView.dataSource = self
        checkExist()
        populateScreen()
        cityName.text = chosenCity?.name
        fillSegments()
    }
    func populateScreen() {
        setUpCollectionView()
        weatherClient.weather(for: chosenCity!) { (forecast) in
            let (title, description, icon) = (forecast?.weather[0])!
            DispatchQueue.main.async {
                self.cityName.text = self.chosenCity?.name
                self.temp.text = String(Int((forecast?.temperature)!)) + " °C"
                self.minTemp.text = String(Int((forecast?.temperatureMin)!))
                self.maxTemp.text = String(Int((forecast?.temperatureMax)!))
                self.desc.text = title
                self.weatherIcon.image = icon
                self.date.text = Date().dayOfWeek()
                self.pressureLabel.text = "Pressure: " + String(Int((forecast?.pressure)!))
                self.humidityLabel.text = "Humidity: " + String(Int((forecast?.humidity)!))
                self.windSpeedLabel.text = "Wind speed: " +  String(Int((forecast?.windSpeed)!))
            }
        }
        weatherClient.forecast(for: chosenCity!) { (forecast) in
            DispatchQueue.main.async {
                self.forecast = forecast
                self.tableView.reloadData()
                self.DayForecastView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = ForecastSegment.titleForSegment(at: ForecastSegment.selectedSegmentIndex)
        var fcd = forecastByDay(day :title!)
        if let forecastList = forecast {
//            return forecastList.count
            return (fcd?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = ForecastSegment.titleForSegment(at: ForecastSegment.selectedSegmentIndex)
        var fcd = forecastByDay(day :title!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! WeatherViewCell
        if(forecast != nil){
	            let (title, description, icon) : (title: String, description: String, icon: UIImage?) = fcd![indexPath.row].weather[0]
            cell.dayLabel.text = fcd![indexPath.row].date.dayOfWeek()
            cell.hourLabel.text = fcd![indexPath.row].date.hourOfDay()! + "h"
            cell.descriptionLabel.text = description
            cell.conditionImage.image = icon
//            cell.textLabel?.text = fcd![indexPath.row].date.dayOfWeek()
//
//            cell.detailTextLabel?.text = description
//            cell.imageView?.image = icon
            //            cell.detailTextLabel?.text = String(filtered[indexPath.row].identifier)
        } else {
            //            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let title = Date().dayOfWeek()
        var fcd = forecastByDay(day :title!)
        
        return (fcd?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DayForecastView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! DayForecastCell
        let title = Date().dayOfWeek()
        var fcd = forecastByDay(day :title!)
        if(forecast != nil){
            let (title, description, icon) : (title: String, description: String, icon: UIImage?) = fcd![indexPath.row].weather[0]
            cell.forecastHour.image = icon
            cell.forecastIcon.text = fcd![indexPath.row].date.hourOfDay()! + "h"
            print(fcd)
            //            cell.textLabel?.text = fcd![indexPath.row].date.dayOfWeek()
            //
            //            cell.detailTextLabel?.text = description
            //            cell.imageView?.image = icon
            //            cell.detailTextLabel?.text = String(filtered[indexPath.row].identifier)
        } else {
            //            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func fillSegments(){
        ForecastSegment.setTitle((Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: Date(), options: [])!.dayOfWeek(), forSegmentAt: 0)
        ForecastSegment.setTitle((Calendar.current as NSCalendar).date(byAdding: .day, value: 2, to: Date(), options: [])!.dayOfWeek(), forSegmentAt: 1)
        ForecastSegment.setTitle((Calendar.current as NSCalendar).date(byAdding: .day, value: 3, to: Date(), options: [])!.dayOfWeek(), forSegmentAt: 2)
        ForecastSegment.setTitle((Calendar.current as NSCalendar).date(byAdding: .day, value: 4, to: Date(), options: [])!.dayOfWeek(), forSegmentAt: 3)
        ForecastSegment.setTitle((Calendar.current as NSCalendar).date(byAdding: .day, value: 5, to: Date(), options: [])!.dayOfWeek(), forSegmentAt: 4)
    }
    
    func checkExist(){
        let favoriteListe = loadFavorites()
        favoriteListe?.forEach({ element in
            if element.identifier == chosenCity?.identifier {
                //                isFavorite = true
                addFav.isSelected = true
            } else {
                //                isFavorite = false
                addFav.isSelected = false
            }
        })
    }
    
    func saveToFavorites() {
        let defaults = UserDefaults.standard
        if var loadedFavorites = loadFavorites() {
            loadedFavorites.append(chosenCity!)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(loadedFavorites) {
                defaults.set(encoded, forKey: "SavedCities")
//                isFavorite = true;
            }
        } else {
            print("There was an error in the forked process")
        }
    
    }
    
    func loadFavorites() -> [City]? {
        let defaults = UserDefaults.standard
        var cities : [City]? = []
        if let savedData = defaults.object(forKey: "SavedCities") as? Data {
            let decoder = JSONDecoder()
            if let loadedCities = try? decoder.decode([City].self, from: savedData) {
                cities = loadedCities
            } else {
                print("No Data Found")
            }
        }
        return cities
    }
    func removeFromFavorites() {
        let defaults = UserDefaults.standard
//        var newFavoriteListe : [City]? = []
        if var loadedFavorites = loadFavorites() {
            var index: Int = 0
            for element in loadedFavorites {
                if element.identifier != chosenCity!.identifier {
                    index += 1
                } else {
                    break
                }
            }
            loadedFavorites.remove(at: index)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(loadedFavorites) {
                defaults.set(encoded, forKey: "SavedCities")
                addFav.isSelected = false
            }
        } else {
            print("There was an error in the forked process")
        }
//        print(newFavoriteListe)
    }
    func forecastByDay(day : String) -> [Forecast]? {
        var dayResult : [Forecast]? = []
        forecast?.forEach({ (element) in
            if element.date.dayOfWeek() == day {
                dayResult?.append(element)
            }
        })
        return dayResult
    }
    
    func setUpCollectionView() {
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 10, height: 190)
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.minimumInteritemSpacing = 0.0
//        DayForecastView.collectionViewLayout = flowLayout
    }
  
}

class WeatherViewCell: UITableViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
}

class DayForecastCell: UICollectionViewCell {
    @IBOutlet weak var forecastIcon: UILabel!
    @IBOutlet weak var forecastHour: UIImageView!
    
    
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    func hourOfDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
}
