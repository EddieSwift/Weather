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

    // MARK: Properties and Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    var activityIndicator: UIActivityIndicatorView!
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var locationOnMap: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        checkLocationServices()
        setupActivityIndicator()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnMap))
        mapView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Gesture Recognizer Method

    @objc func tapOnMap(sender: UIGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        let locationInView = sender.location(in: mapView)
        locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        getWeatherByLocation(coordinate: locationOnMap)
    }
    
    // MARK: - Network Method
    
    private func getWeatherByLocation(coordinate: CLLocationCoordinate2D) {
        startAnimation()
        NetworkService.shared.getWeather(Constants.NetworkURL.baseURL, Constants.NetworkURL.apiKey, coordinate) { [weak self] state in
            guard let `self` = self else { return }
            
            switch state {
            case .success(let weather):
                self.weather = weather
                self.addAnnotation(location: self.locationOnMap)
                self.performSegue(withIdentifier: "showWeatherSegue", sender: self)
            case .error(let error):
                self.internetConnectionAlert()
                print(error.localizedDescription)
            }
            self.stopAnimation()
        }
    }
    
    // MARK: - Map and Location Methods
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = weather?.country
        annotation.subtitle = weather?.city
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
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: Constants.regionInMeters, longitudinalMeters: Constants.regionInMeters)
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
        if segue.identifier == "showWeatherSegue" {
            
            if let weatherViewController = segue.destination as? WeatherViewController {
                weatherViewController.weather = weather
                slideInTransitioningDelegate.direction = .bottom
                slideInTransitioningDelegate.disableCompactHeight = true
                weatherViewController.transitioningDelegate = slideInTransitioningDelegate
                weatherViewController.modalPresentationStyle = .custom
            }
        }
        
    }
    
    // MARK: - SetupUI
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .systemBlue
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    // MARK: - Indicator Methods
    
    private func startAnimation() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    // MARK: - Alert Method
    
    private func internetConnectionAlert() {
        let alert = UIAlertController(title: "No Internet",
                                      message: "The Internet connection appears to be offline. Turn on your internet and try again please",
                                      preferredStyle: .alert)
        
        let cancleAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancleAction)
        present(alert, animated: true)
    }
    
}
