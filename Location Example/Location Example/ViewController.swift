//
//  ViewController.swift
//  Location Example
//
//  Created by Akio Fujita on 6/24/21.
//

/*
 
 Notes:
 - In Info.plist, add "Privacy - Location Always and When In Use Usage Description"
 - In Info.plist, add "Privacy - Location When In Use Usage Description"
 
 */

/* Import modules */
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    /* Initializations */
    @IBOutlet weak var locationLabel: UILabel!
    let locationManager = CLLocationManager()

    /* Do any additional setup after loading the view. */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = "Location Unavailable"
        
        /* Ask for authorization from the user to use their location */
        self.locationManager.requestAlwaysAuthorization()

        /* For use in foreground */
        self.locationManager.requestWhenInUseAuthorization()

        /* If user allows location to be used, set up location
            manager and location label settings */
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            
            locationLabel.numberOfLines = 3
            locationLabel.textAlignment = .center
            locationLabel.text = "Current Location:\n\n\n"
        }
    }
    
    /* Update location label when location manager gets an update on location */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /* Extract location into latitude/longitude and display */
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        locationLabel.text = "Current Location:\n\n\(locValue.latitude), \(locValue.longitude)"
    }
    
    /* Print error when location manager fails to get location */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationLabel.text = "[ERROR]: COULD NOT GET LOCATION"
    }



}

