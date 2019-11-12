//
//  WeatherConditionImageManager.swift
//  Weather
//
//  Created by Eduard Galchenko on 12.11.2019.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

enum WeatherConditionIconManager: String, CaseIterable {

    // Day cases
    case ClearSky = "01d.png"
    case FewClouds = "02d.png"
    case ScatteredClouds = "03d.png"
    case BrokenClouds = "04d.png"
    case ShowerRain = "09d.png"
    case Rain = "10d.png"
    case Thunderstorm = "11d.png"
    case Snow = "13d.png"
    case Mist = "50d.png"

    // Night cases
    case ClearSkyNight = "01n.png"
    case FewCloudsNight = "02n.png"
    case ScatteredCloudsNight = "03n.png"
    case BrokenCloudsNight = "04n.png"
    case ShowerRainNight = "09n.png"
    case RainNight = "10n.png"
    case ThunderstormNight = "11n.png"
    case SnowNight = "13n.png"
    case MistNight = "50n.png"

    // No json response for icon
    case DefaultIcon = "default_weather_icon.png"

    init(rawValue: String) {
        switch rawValue {
        case "01d": self = .ClearSky
        case "02d": self = .FewClouds
        case "03d": self = .ScatteredClouds
        case "04d": self = .BrokenClouds
        case "09d": self = .ShowerRain
        case "10d": self = .Rain
        case "11d": self = .Thunderstorm
        case "13d": self = .Snow
        case "50d": self = .Mist

        case "01n": self = .ClearSkyNight
        case "02n": self = .FewCloudsNight
        case "03n": self = .ScatteredCloudsNight
        case "04n": self = .BrokenCloudsNight
        case "09n": self = .ShowerRainNight
        case "10n": self = .RainNight
        case "11n": self = .ThunderstormNight
        case "13n": self = .SnowNight
        case "50n": self = .MistNight

        default: self = .DefaultIcon
        }
    }

    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }

}
