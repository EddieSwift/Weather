//
//  NetworkService.swift
//  Weather
//
//  Created by Eduard Galchenko on 11.11.2019.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Alamofire
import SwiftyJSON
import CoreLocation

public enum NetworkResponse {
    case success(_ article: Weather)
    case error(_ error: Error)
}

protocol NetworkingServiceProvider {
    func getWeather(_ apiUrl: String, _ apiKey: String, _ coordinate: CLLocationCoordinate2D, completion: @escaping (NetworkResponse) -> Void)
}

final public class NetworkService: NetworkingServiceProvider {
    public static let shared = NetworkService()
    public func getWeather(_ apiUrl: String,
                           _ apiKey: String,
                           _ coordinate: CLLocationCoordinate2D,
                           completion: @escaping (NetworkResponse) -> Void) {

        let url = Constants.NetworkURL.baseURL + "weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&apiKey=\(apiKey)"

        Alamofire.request(url).responseJSON { response in
            
            if response.result.value != nil {
                let json = JSON(response.result.value!)

                let weather = Weather(temp: Int(json["main"]["temp"].doubleValue - 273.15),
                                      pressure: json["main"]["pressure"].stringValue,
                                      humidity: json["main"]["humidity"].stringValue,
                                      country: json["sys"]["country"].stringValue,
                                      city: json["name"].stringValue,
                                      icon: json["weather"][0]["icon"].stringValue)

                completion(.success(weather))
            } else {
                guard let error = response.error else {
                    completion(.error(response.error!))
                    return
                }
                completion(.error(error))
            }
        }
    }
}
