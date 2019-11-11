//
//  WeatherViewController.swift
//  Weather
//
//  Created by Eduard Galchenko on 10.11.2019.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestureRecognizers()
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
