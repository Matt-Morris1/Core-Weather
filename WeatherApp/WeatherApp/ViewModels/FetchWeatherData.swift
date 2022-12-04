//
//  FetchWeatherData.swift
//  WeatherApp
//
//  Created by Matthew Morris on 9/26/22.
//

import Foundation

extension ViewController {
    
    func retrieveWeatherData(lat: Double,
                             long: Double,
                             completionHandler: @escaping (City?, Error?) -> Void) {
        
        let apikey = "866ab66ef307a47c262601d792733d4d"
        
        let baseURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apikey)&units=imperial"
        
        let url = URL(string: baseURL)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!)
                
                guard let resp = json as? NSDictionary else { return }
                
                guard let coord = resp.value(forKey: "coord") as? NSDictionary else { return }
                
                guard let weather = resp.value(forKey: "weather") as? [NSDictionary] else { return }
                
                var city = City()
                city.lat = coord.value(forKey: "lat") as? Double
                city.lon = coord.value(forKey: "lon") as? Double
                city.temp = resp.value(forKeyPath: "main.temp") as? Double
                city.name = resp.value(forKey: "name") as? String
                city.temp_max = resp.value(forKeyPath: "main.temp_max") as? Double
                city.temp_min = resp.value(forKeyPath: "main.temp_min") as? Double
                
                for weather in weather {
                    city.main = weather.value(forKey: "main") as? String
                    city.description = weather.value(forKey: "description") as? String
                }
                
                completionHandler(city, nil)
            } catch {
                print("Caught Error")
            }
        }.resume()
    }
    
    func retrieveWeatherForecast(lat: Double,
                                 long: Double,
                                 completionHandler: @escaping (CityForecast?, Error?) -> Void) {
        
        let apiKey = "866ab66ef307a47c262601d792733d4d"
        
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=imperial"
        
        let url = URL(string: baseURL)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!)
                
                guard let resp = json as? NSDictionary else { return }
                
                guard let list = resp.value(forKey: "list") as? [NSDictionary] else { return }
                
                let day1 = list[0]
                let day2 = list[8]
                let day3 = list[16]
                let day4 = list[24]
                let day5 = list[32]
                
                var city = CityForecast()
                city.lat = resp.value(forKeyPath: "city.coord.lat") as? Double
                city.lon = resp.value(forKeyPath: "city.coord.lon") as? Double
                city.name = resp.value(forKeyPath: "city.name") as? String
                
                
                for list in list {
                    city.temp1 = day1.value(forKeyPath: "main.temp") as? Double
                    city.temp2 = day2.value(forKeyPath: "main.temp") as? Double
                    city.temp3 = day3.value(forKeyPath: "main.temp") as? Double
                    city.temp4 = day4.value(forKeyPath: "main.temp") as? Double
                    city.temp5 = day5.value(forKeyPath: "main.temp") as? Double
                    city.dt_txt = day1.value(forKey: "dt_txt") as? String
                    
                    
                }
                
                completionHandler(city, nil)
            } catch {
                print("Caught Error")
            }
        }.resume()
    }
    
}
