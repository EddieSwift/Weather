//
//  MapViewController.swift
//  Weather
//
//  Created by Eduard Galchenko on 09.11.2019.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    lazy var slideInTransitioningDelegate = SlideInPresentationManager()

    var weather: Weather?

    let locationManager = CLLocationManager()
    let regionInMeters = 30000.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        checkLocationServices()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnMap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapOnMap(sender: UIGestureRecognizer) {
        print("tapOnMap")
        mapView.removeAnnotations(mapView.annotations)
        let locationInView = sender.location(in: mapView)
        let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        print("longitude: \(locationOnMap.longitude) and latitude: \(locationOnMap.latitude)")

        getWeatherByLocation(coordinate: locationOnMap)

        self.performSegue(withIdentifier: "showWeatherSegue", sender: self)

        addAnnotation(location: locationOnMap)
    }

    // MARK: - Network Method

    private func getWeatherByLocation(coordinate: CLLocationCoordinate2D) {
        NetworkService.shared.getWeather(Constants.NetworkURL.baseURL, Constants.NetworkURL.apiKey, coordinate) { [weak self] state in
            guard let `self` = self else { return }

            switch state {
            case .success(let weather):
                self.weather = weather
                print(weather)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Country"
        annotation.subtitle = "City"
        self.mapView.addAnnotation(annotation)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        case .restricted:
            break
        case .denied:
            break
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showWeatherSegue" {
//
//            if segue.destination is WeatherViewController {
//
//            }
//        }

        if let controller = segue.destination as? WeatherViewController {
        slideInTransitioningDelegate.direction = .bottom
        slideInTransitioningDelegate.disableCompactHeight = true
        controller.transitioningDelegate = slideInTransitioningDelegate
        controller.modalPresentationStyle = .custom
    }
    
}
}




