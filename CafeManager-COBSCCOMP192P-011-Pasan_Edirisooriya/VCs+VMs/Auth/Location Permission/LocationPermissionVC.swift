//
//  LocationPermissionVC.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_Edirisooriya
//
//  Created by Pasan Induwara Edirisooriya on 4/29/21.
//

import UIKit
import CoreLocation
import Firebase

class LocationPermissionVC: BaseVC, CLLocationManagerDelegate {
    
    var currentLocation:CLLocation?
    var locationManager:CLLocationManager!
    @IBOutlet weak var btnAllow: UIButton!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    func setupUI(){
        btnAllow.layer.cornerRadius = 5.0
    }
    
    @IBAction func didTappedOnAllowLocation(_ sender: Any) {
        setupLocationManager()
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            print("locations = \(locationValue)")
            addLocations(long: locationValue.longitude.description, lat: locationValue.latitude.description)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
        //        if status == .authorizedWhenInUse {
        //            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        //                if CLLocationManager.isRangingAvailable() {
        //                    let nc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarVC")
        //                    resetWindow(with: nc)
        //                }
        //            }
        //        }
    }
    
    func addLocations(long:String,lat:String){
        var ref: DocumentReference? = nil
        ref = db.collection("Locations").addDocument(data: [
            "user_Id":LocalUser.current()?.id,
            "long": long,
            "lat":lat
        ]) { err in
            if let err = err {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else {
                let nc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarVC")
                self.resetWindow(with: nc)
            }
        }
    }
}
