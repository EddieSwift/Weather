//
//  WeatherViewController.swift
//  Weather
//
//  Created by Eduard Galchenko on 10.11.2019.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!

    var weather: Weather?


    override func viewDidLoad() {
        super.viewDidLoad()

        setWeatherUI()
        setupGestureRecognizers()
    }

    private func setWeatherUI() {
        if let temp = weather?.temp, let city = weather?.city, let country = weather?.country, let pressure = weather?.pressure, let humidity = weather?.humidity, let icon = weather?.icon {
            tempLabel.text = String(temp) + " °C"
            if city.count == 0 || country.count == 0 {
                locationLabel.text = "Location not found"
            } else {
                locationLabel.text = city + ", " + country
            }
            pressureLabel.text = "Pressure \(pressure) hPa"
            humidityLabel.text = "Humidity \(humidity)%"
            weatherImageView.image = UIImage(named: WeatherConditionIconManager(rawValue: icon).rawValue)  
        }

    }

}



// MARK: - Setup Gestures

private extension WeatherViewController {

    func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        view.addGestureRecognizer(tapRecognizer)

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gestureRecognizer:)))
        swipeRecognizer.direction = .down
        view.addGestureRecognizer(swipeRecognizer)
    }

}

// MARK: - GestureRecognizerSelectors

private extension WeatherViewController {

    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true)
    }

    @objc func handleSwipe(gestureRecognizer: UISwipeGestureRecognizer.Direction) {
        dismiss(animated: true)
    }
}
