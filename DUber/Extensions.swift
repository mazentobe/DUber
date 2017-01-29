//
//  Extensions.swift
//  DUber
//
//  Created by Mazen on 29/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

extension CLLocationCoordinate2D {
    
    func getLocationAdressString() -> Observable<String?> {
        return Observable.create({ (observer) -> Disposable in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: self.latitude, longitude: self.longitude)) { (placemarks, err) in
                if let error = err {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    
                    let placemark = placemarks?.first
                    let components = [placemark?.thoroughfare, placemark?.subThoroughfare, placemark?.locality].flatMap{$0}
                    let locationString = components.joined(separator: ", ")
                    observer.onNext(locationString)
                }
            }
            return Disposables.create { }
        })
    }
    
}

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.locale = Locale(identifier: "lv_LV")
        self.dateFormat = format
    }
}
