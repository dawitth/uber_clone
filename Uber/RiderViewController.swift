//
//  RiderViewController.swift
//  Uber
//
//  Created by Dawit Hunegnaw on 2018-12-01.
//  Copyright © 2018 Dawit Hunegnaw. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class RiderViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        if let email = Auth.auth().currentUser?.email {
            
            
                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: {(DataSnapshot) in
                    self.uberHasBeenCalled = true
                    self.callAnUberOutlet.setTitle("Cancel Uber", for: .normal)
                    Database.database().reference().child("RideRequests").removeAllObservers()
                    
                })
            
            
        }
        
        
    }
    
    
    @IBOutlet weak var callAnUberOutlet: UIButton!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
        
            //map.removeAnnotation(map!.annotations as! MKAnnotation)
            let annotationsToRemove = map.annotations.filter { $0 !== map.userLocation }
            map.removeAnnotations( annotationsToRemove )
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your Location"
            map.addAnnotation(annotation)
        }
    }
   

    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var map: MKMapView!
    
    
   
   
    
    @IBAction func callUberTapped(_ sender: Any) {
        
        
        if let email = Auth.auth().currentUser?.email {
           
            if uberHasBeenCalled {
                uberHasBeenCalled = false
                callAnUberOutlet.setTitle("Call an Uber", for: .normal)
                
                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: {(DataSnapshot) in DataSnapshot.ref.removeValue()
                    Database.database().reference().child("RideRequests").removeAllObservers()
                    
                })
                
                
                
                
           
            } else {
                
                let rideRequestDictonary : [String : Any] = ["email": email, "lat": userLocation.latitude, "lon": userLocation.longitude]
                Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictonary)
                
             
                
                uberHasBeenCalled = true
                callAnUberOutlet.setTitle("Cancel Uber", for: .normal)
            }
            
           
        }
        
        
        
    }
   
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
