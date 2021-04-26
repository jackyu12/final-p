//
//  riderViewController.swift
//  uber
//
//  Created by Jack Yu on 4/26/21.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class riderViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var calluber: UIButton!
    @IBOutlet var calluberB: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var logoutT: UIBarButtonItem!
    var locationManager = CLLocationManager()
    var userlocation = CLLocationCoordinate2D()
    var uberhasBeencalled = false
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if let email = Auth.auth().currentUser?.email{
            Database.database().reference().child("riderequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: {(snapshot) in
                self.uberhasBeencalled = true
                self.calluber.setTitle("cancel uber", for: .normal)
                //snapshot.ref.removeValue()
                Database.database().reference().child("riderequests").removeAllObservers()
            })
            
        }
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate{
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userlocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            //map.removeAnnotation(map.annotations as! MKAnnotation)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your location"
            map.addAnnotation(annotation)
        }
    }
    

    @IBAction func callUbertapped(_ sender: Any) {
        if let email = Auth.auth().currentUser?.email{
            if uberhasBeencalled{
                uberhasBeencalled = false
                calluber.setTitle("Call an uber", for: .normal)
                Database.database().reference().child("riderequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: {(snapshot) in
                    snapshot.ref.removeValue()
                    Database.database().reference().child("riderequests").removeAllObservers()
                })
            }else{
                let rideRequestDictionary :[String:Any] = ["email":email,"lat":userlocation.latitude ,"lon":userlocation.longitude]
                Database.database().reference().child("riderequests").childByAutoId().setValue(rideRequestDictionary)
                    uberhasBeencalled = true
                    calluber.setTitle("Cancel Uber", for: .normal)
            }
            
        
        
        }}
    
    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
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
