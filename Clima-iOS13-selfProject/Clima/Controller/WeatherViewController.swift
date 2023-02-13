//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
   
    
    var weatherManager = WeatherManager()

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        

        weatherManager.delegate = self
        searchTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            cityLabel.text = searchTextField.text
        }
    }
    
    func textFieldShouldReturn(_textField: UITextField) -> Bool{
        searchTextField.endEditing(true)
        return true
}
    
    func textFieldShouldEndEditing(_textField: UITextField) -> Bool{
        if _textField.text != ""{
            return true
        }else{
            _textField.placeholder = "Type something..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_textField: UITextField){
        
        if let city = searchTextField.text {
            
            weatherManager.fetchWeather(cityName:city )
        }
        searchTextField.text = ""
}
    
    // textField editing process
}


//MARK: - weatherManagerDelegate

extension WeatherViewController: weatherManagerDelegate{
    
    func didUpdateWeather(_weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        print(weather.cityName)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
        }
    }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to get users location.")
        }
    
}
