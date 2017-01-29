//
//  StudentPickupVC.swift
//  DUber
//
//  Created by Mazen on 28/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import SVProgressHUD

class StudentPickupVC: UIViewController {
    
    @IBAction func onSosTap(_ sender: UIButton) {
        SVProgressHUD.showInfo(withStatus: "Ordering Duber")
        let location = hardCodedLocation ?? currentLocation!
        _ = ApiClient.requestPickup(userId: Student.sharedCurrentStudentInstance!.id, lat: location.latitude.description, lon: location.longitude.description)
        .do(onNext: { (job) in
            if let fetchedJob = job {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "callSuccess") as! CallSuccessVC
                vc.job = fetchedJob
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            updateMap()
        }
    }
    var hardCodedLocation: CLLocationCoordinate2D? {
        didSet {
            updateMap()
        }
    }
    var currentPositionMarker: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Start getting current location
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateMap() {
        if let marker = currentPositionMarker {
             mapView.removeAnnotation(marker)
        }
        if let position = hardCodedLocation {
            setMapPointFromLocation(position)
        } else {
            if let position = currentLocation {
                setMapPointFromLocation(position)
            }
        }
    }
    
    func setMapPointFromLocation(_ location: CLLocationCoordinate2D) {
        let camera = MKMapCamera()
        camera.centerCoordinate = location
        camera.altitude = 500
        mapView.camera = camera
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        currentPositionMarker = annotation
    }
}

extension StudentPickupVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0].coordinate
        manager.stopUpdatingLocation()
    }
}

extension StudentPickupVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
        annotationView.image = UIImage(named: "pin")
        annotationView.isDraggable = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .dragging: break
//        self.mapView.setCenter((view.annotation?.coordinate)!, animated: false)
        case .ending:
            hardCodedLocation = view.annotation?.coordinate
        default:
            break
        }
    }
}
