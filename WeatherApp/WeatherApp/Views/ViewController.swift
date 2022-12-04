//
//  ViewController.swift
//  WeatherApp
//
//  Created by Matthew Morris on 9/12/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var cityName: UILabel!
    var temp: UILabel!
    var weatherLabel: UILabel!
    var highLowLabel: UILabel!
    var foreCastTemp: [Int] = []
    var date = Date()
    var weekdays: [String] = ["Today"]

    
//    var city: City?
    
    var dataCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CVcell")
        return cv
    }()
    
    var listView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    
    var tabBar: UIView = {
       var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var listButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "list.dash"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var forecastView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var forecastTable: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.9, height: view.frame.height * 0.2))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 12
        tableView.separatorColor = .white
        tableView.layer.masksToBounds = true
        tableView.rowHeight = tableView.frame.height * 0.2
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TVcell")
        tableView.layer.zPosition = 5
        return tableView
    }()

    
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = rgbColor(red: 0, green: 138, blue: 216)
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        guard let currentLocation = locationManager.location else { return }
        
        let oneDay = 86400
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let day2 = dateFormatter.string(from: date.advanced(by: TimeInterval(oneDay)))
        let day3 = dateFormatter.string(from: date.advanced(by: TimeInterval(oneDay * 2)))
        let day4 = dateFormatter.string(from: date.advanced(by: TimeInterval(oneDay * 3)))
        let day5 = dateFormatter.string(from: date.advanced(by: TimeInterval(oneDay * 4)))
        weekdays.append(day2)
        weekdays.append(day3)
        weekdays.append(day4)
        weekdays.append(day5)
        
        loadData(location: currentLocation)
        loadForecastData(location: currentLocation)
        
        
        dataCollectionView.dataSource = self
        dataCollectionView.delegate = self
        
        cityName = UILabel()
        cityName.translatesAutoresizingMaskIntoConstraints = false
        cityName.font = UIFont(name: "Arial", size: 30)
        
        temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = UIFont(name: "Apple SD Gothic Neo Thin", size: 120)
        
        tabBar.backgroundColor = rgbColor(red: 0, green: 110, blue: 179)
        
        forecastView.backgroundColor = rgbColor(red: 0, green: 110, blue: 179)
        forecastTable.backgroundColor = .clear
        
        weatherLabel = UILabel()
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.font = UIFont(name: "Arial", size: 25)
        
        highLowLabel = UILabel()
        highLowLabel.translatesAutoresizingMaskIntoConstraints = false
        highLowLabel.font = UIFont(name: "Arial", size: 25)
        
        listButton.addTarget(self, action: #selector(changeScreen), for: .touchUpInside)
        
        view.addSubview(cityName)
        view.addSubview(temp)
        view.addSubview(weatherLabel)
        view.addSubview(highLowLabel)
        view.addSubview(forecastView)
        forecastView.addSubview(forecastTable)
        
        view.addSubview(listView)
        view.addSubview(tabBar)
        tabBar.addSubview(listButton)
        listView.addSubview(dataCollectionView)
        
        NSLayoutConstraint.activate([
            cityName.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cityName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temp.topAnchor.constraint(equalTo: cityName.bottomAnchor),
            temp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherLabel.topAnchor.constraint(equalTo: temp.bottomAnchor),
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            highLowLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor),
            highLowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            forecastView.topAnchor.constraint(equalTo: highLowLabel.bottomAnchor),
            forecastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forecastView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            forecastView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            forecastTable.centerXAnchor.constraint(equalTo: forecastView.centerXAnchor),
            forecastTable.centerYAnchor.constraint(equalTo: forecastView.centerYAnchor),
            forecastTable.widthAnchor.constraint(equalTo: forecastView.widthAnchor, multiplier: 0.95),
            forecastTable.heightAnchor.constraint(equalTo: forecastView.heightAnchor),
            
            listView.topAnchor.constraint(equalTo: view.topAnchor),
            listView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            listView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dataCollectionView.centerXAnchor.constraint(equalTo: listView.centerXAnchor),
            dataCollectionView.topAnchor.constraint(equalTo: listView.topAnchor),
            dataCollectionView.bottomAnchor.constraint(equalTo: listView.bottomAnchor),
            dataCollectionView.widthAnchor.constraint(equalTo: listView.widthAnchor, multiplier: 0.9),
            
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.075),
            
            listButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor),
            listButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor)
        ])
    }
    
    func loadData(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        retrieveWeatherData(lat: latitude, long: longitude) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    guard let temp = Int(exactly: response.temp!.rounded()) else { return }
                    guard let name = response.name else { return }
//                    guard let weather = response.main else { return }
                    guard let description = response.description else { return }
                    guard let high = Int(exactly: response.temp_max!.rounded()) else { return }
                    guard let low = Int(exactly: response.temp_min!.rounded()) else { return }
                    
                    self.temp.text = "\(temp)°"
                    self.cityName.text = name
                    self.weatherLabel.text = description
                    self.highLowLabel.text = "H: \(high)°   L: \(low)°"
                }
                
            }
        }
    }
    
    func loadForecastData(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        retrieveWeatherForecast(lat: latitude, long: longitude) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    var cell = TableViewCell()

                    


                }
            }
        }
    }
    
    @objc func changeScreen(_ sender: UIButton) {
        sender.tag += 1
        if sender.tag > 1 {
            sender.tag = 0
        }
        switch sender.tag {
        case 1:
            listButton.setImage(UIImage(systemName: "sunset"), for: .normal)
            listView.isHidden = false
        default:
            listButton.setImage(UIImage(systemName: "list.dash"), for: .normal)
            listView.isHidden = true
        }

    }
    
    func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        let color = UIColor(cgColor: CGColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1))
        return color
    }
}




//MARK: - Extensions

// Collection view extension
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 1.2, height: collectionView.frame.height * 0.2)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVcell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = rgbColor(red: 0, green: 138, blue: 216)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    
}

// Tableview extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVcell", for: indexPath) as! TableViewCell
        let currentLocation = locationManager.location
        let latitude = currentLocation?.coordinate.latitude
        let longitude = currentLocation?.coordinate.longitude
        
        cell.title.text = weekdays[indexPath.row]
//        retrieveWeatherForecast(lat: latitude!, long: longitude!) { response, error in
//            if let response = response {
//                DispatchQueue.main.async {
//                    guard let temp1 = Int(exactly: response.temp1!.rounded()) else { return }
//                    guard let temp2 = Int(exactly: response.temp2!.rounded()) else { return }
//                    guard let temp3 = Int(exactly: response.temp3!.rounded()) else { return }
//                    guard let temp4 = Int(exactly: response.temp4!.rounded()) else { return }
//                    guard let temp5 = Int(exactly: response.temp5!.rounded()) else { return }
//
//                    if self.foreCastTemp.count < 5 {
//                        self.foreCastTemp.append(temp1)
//                        self.foreCastTemp.append(temp2)
//                        self.foreCastTemp.append(temp3)
//                        self.foreCastTemp.append(temp4)
//                        self.foreCastTemp.append(temp5)
//                    }
//
//                    let theTemp = self.foreCastTemp[indexPath.row]
//
//                    cell.title.text = "\(theTemp)"
//
//                }
//            }
//        }

        return cell
    }
    
    
}

