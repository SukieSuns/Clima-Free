//
//  WeatherManager.swift
//  Clima
//
//  Created by Administrator on 11/15/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol weatherManagerDelegate{
    func didUpdateWeather(_weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    var delegate: weatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ef910ae1f1daed6e23ba3ccab79b7b37"
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString:urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)& lat=\(latitude)& lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        //create a URL
        if let url = URL(string: urlString){
            // create a URL session
            let Session = URLSession(configuration: .default)
            //make a task for URl session
            let task = Session.dataTask(with: url){ (data,response,error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(_weatherManager: self, weather: weather)
                        
                    }
                }
        }
            // start task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].description)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            
            //print(weather.conditionId)
            //print(weather.temperatureString) // explanation: WeatherModel has the property of temperatureString.
            return weather
            
        }catch{
            print(error)
            return nil
        }
        
    }

    
    
}

