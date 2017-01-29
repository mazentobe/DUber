//
//  Job.swift
//  DUber
//
//  Created by Mazen on 28/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class Job {
    
    fileprivate let kJobLat = "lattitude"
    fileprivate let kJobLon = "longitude"
    fileprivate let kJobStudentId = "user_id"
    fileprivate let kJobId = "job_id"
    fileprivate let kJobDriverId = "driver_id"
    fileprivate let kJobIsComplete = "in_progress"
    fileprivate let kJobIsPaid = "paid "

    var id: Int
    var location: CLLocationCoordinate2D
    var studentId: String
    var driverId: Int?
    var isComplete: Bool?
    var isPaid: Bool?
    
    init(id: Int, location: CLLocationCoordinate2D, studentId: String, driverId: Int?, isComplete: Bool, isPaid: Bool) {
        self.id = id
        self.location = location
        self.studentId = studentId
        self.driverId = driverId
        self.isComplete = isComplete
        self.isPaid = isPaid
    }
    
    init?(dict: [String : JSON]) {
        for (key, value) in dict {
            print("\(key) : \(value)")
        }
        
        guard let lat = dict[kJobLat]?.stringValue,
            let id = dict[kJobId]?.intValue,
            let lon = dict[kJobLon]?.stringValue,
            let studentId = dict[kJobStudentId]?.stringValue else {
                return nil
        }
        guard let location = Job.getCoordinateFromString(lat: lat, lon: lon) else {
            return nil
        }
        self.id = id
        self.location = location
        self.studentId = studentId
        self.driverId = dict[kJobDriverId]?.intValue
        self.isComplete = dict[kJobIsComplete]?.boolValue
        self.isPaid = dict[kJobIsPaid]?.boolValue
    }
    
    func toDict() -> [String : String] {
        var dict: [String : String] = [:]
        dict[kJobId] = String(self.id)
        dict[kJobLat] = self.location.latitude.description
        dict[kJobLon] = self.location.longitude.description
        dict[kJobDriverId] = String(self.driverId!)
        dict[kJobIsComplete] = self.isComplete?.description
        dict[kJobIsPaid] = self.isPaid?.description
        return dict
    }
    
    static func getCoordinateFromString(lat: String, lon: String) -> CLLocationCoordinate2D? {
        guard let doubleLat = Double(lat) else {
            return nil
        }
        guard let doubleLon = Double(lon) else {
            return nil
        }
        return CLLocationCoordinate2DMake(doubleLat, doubleLon)
    }
    
    static func parseJobsFromData(data: Data) -> [Job] {
        let json = JSON(data: data)
        var jobs: [Job] = []
        
        if let array = json.array {
            for jobJson in array {
                if let dict = jobJson.dictionary {
                    let job = Job(dict: dict)
                    if let parsedJob = job {
                        jobs.append(parsedJob)
                    }
                }
            }
        }
        return jobs
    }
    
    static func parseJobFromData(data: Data) -> Job? {
        let json = JSON(data: data)
        if let dict = json.dictionary {
            return Job(dict: dict)
        }
        return nil
    }
    
}
