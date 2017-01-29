//
//  SingleJobVC.swift
//  DUber
//
//  Created by Mazen on 29/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import SVProgressHUD
import JDStatusBarNotification

class SingleJobVC: UIViewController {
    var currentJob: Job!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var studentView: UIView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var college: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBAction func didSwipe(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    
    @IBAction func onPickupTap(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Accepting Job")
        if #available(iOS 10.0, *) {
            let request = MKDirectionsRequest()
            request.source = MKMapItem.init(placemark: MKPlacemark(coordinate: currentLocation))
            request.destination = MKMapItem.init(placemark: MKPlacemark(coordinate: currentJob.location))
            let direction = MKDirections(request: request)
            direction.calculateETA { (response, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    if let date = response?.expectedArrivalDate {
                        print(date.timeIntervalSinceNow.description)
                    }
                }
            }

        }
        _ = ApiClient.acceptPickup(jobId: currentJob.id, driverId: Driver.currentDriverSharderInstance!.id)
            .do(onNext: { (job) in
                if job != nil {
                    SVProgressHUD.dismiss()
                } else {
                    SVProgressHUD.dismiss()
                    JDStatusBarNotification.show(withStatus: "Error accepting job!")
                }
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.isHidden = true
        let camera = MKMapCamera()
        camera.centerCoordinate = currentJob.location
        camera.altitude = 500
        mapView.setCamera(camera, animated: true)
        studentView.isHidden = true
        
        heading.text = ""
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentJob.location
        mapView.addAnnotation(annotation)
        
        _ = ApiClient.getStudentById(id: currentJob.studentId)
            .do(onNext: { (person) in
                if let student = person {
                    self.fillStudentView(student: student)
                }
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
        
        //Start getting current location
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func fillStudentView(student: Student) {
        heading.text = "Picking Up : \(student.name) \(student.surname)"
        fullName.text = "\(student.name) \(student.surname)"
        college.text = student.college
        phone.text = student.phone
        profilePic.isHidden = false
        studentView.isHidden = false
    }
}

extension SingleJobVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0].coordinate
    }
}
