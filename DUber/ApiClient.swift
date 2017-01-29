//
//  ApiClient.swift
//  DUber
//
//  Created by Mazen on 28/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Alamofire

class ApiClient {
    
    static let studentLoginURL = "https://community.dur.ac.uk/mohammed.m.rahman/api.php?action=registerUser"
    static let staffLoginUrl = ""
    static let jobsUrl = "https://community.dur.ac.uk/mohammed.m.rahman/api.php?action=returnAllJobs"
    
    static func getJSONWithMethodAndBody(urlToRequest: String, method: HTTPMethod?, parameters : [String : Any], callback: ((_ data: Data?) -> ())?) {
        Alamofire.request(urlToRequest, method: method ?? HTTPMethod.get, parameters: parameters).responseData { (data) in
            callback?(data.data)
        }
    }
    
    static func loginStudent(login: String, password: String) -> Observable<Student?> {
        var dict: [String : String] = [:]
        dict["userID"] = login
        
        return Observable.create({ (observer) -> Disposable in
            ApiClient.getJSONWithMethodAndBody(urlToRequest: ApiClient.studentLoginURL, method: .post, parameters: dict, callback: { (data) in
                if let fetchedData = data {
                    observer.onNext(Student.parseStudentFromJSON(data: fetchedData))
                } else {
                    observer.onNext(nil)
                }
            })
            return Disposables.create { }
        })
    }
    
    static func loginStaff(login: String, password: String) -> Observable<Driver?> {
        var dict: [String : String] = [:]
        dict["login"] = login
        dict["password"] = password
        
        return Observable.create({ (observer) -> Disposable in
            ApiClient.getJSONWithMethodAndBody(urlToRequest: ApiClient.staffLoginUrl, method: .post, parameters: dict, callback: { (data) in
                if let fetchedData = data {
                    observer.onNext(Driver.parseDriverFromJSON(data: fetchedData))
                } else {
                    observer.onNext(nil)
                }
            })
            return Disposables.create { }
        })
    }
    
    static func getStudentById(id: String) -> Observable<Student?> {
        var dict: [String: String] = [:]
        dict["user_id"] = id
        
        return Observable.create({ (observer) -> Disposable in
            ApiClient.getJSONWithMethodAndBody(urlToRequest: "https://community.dur.ac.uk/mohammed.m.rahman/api.php?action=requestStudentData", method: .post, parameters: dict, callback: { (data) in
                if let fetchedData = data {
                    observer.onNext(Student.parseStudentFromJSON(data: fetchedData))
                } else {
                    observer.onNext(nil)
                }
            })
            return Disposables.create { _ in }
        })
    }
    
    static func getJobs() -> Observable<[Job]?> {
        return Observable.create({ (observer) -> Disposable in
            Alamofire.request(ApiClient.jobsUrl) .responseData { (data) in
                if let fetchedData = data.data {
                    observer.onNext(Job.parseJobsFromData(data: fetchedData))
                } else {
                    observer.onNext(nil)
                }
            }
            return Disposables.create { _ in }
        })
    }
    
    static func getJobById(jobId: Int) -> Observable<Job?> {
        var dict: [String : String] = [:]
        dict["job_id"] = String(jobId)
        return Observable.create({ (observer) -> Disposable in
            ApiClient.getJSONWithMethodAndBody(urlToRequest: "https://community.dur.ac.uk/mohammed.m.rahman/api.php?action=returnJobById", method: .post, parameters: dict, callback: { (data) in
                if let fetchedData = data {
                    observer.onNext(Job.parseJobsFromData(data: fetchedData).first)
                } else {
                    observer.onNext(nil)
                }
            })
            return Disposables.create { _ in }
        })
    }
    
    static func acceptPickup(jobId: Int, driverId: Int) -> Observable<Job?> {
        var dict: [String : String] = [:]
        dict["job_id"] = String(jobId)
        dict["driver_id"] = String(driverId)
        return Observable.create({ (observer) -> Disposable in
            ApiClient.getJSONWithMethodAndBody(urlToRequest: "https://community.dur.ac.uk/mohammed.m.rahman/api.php?action=acceptJob", method: .post, parameters: dict, callback: { (data) in
                if let fetchedData = data {
                    observer.onNext(Job.parseJobsFromData(data: fetchedData).first!)
                } else {
                    observer.onNext(nil)
                }
            })
            return Disposables.create { _ in }
        })
    }
    
    static func requestPickup(userId: String, lat: String, lon: String) -> Observable<Job?> {
        var dict: [String : String] = [:]
        dict["userID"] = userId
        dict["gps_long"] = lon
        dict["gps_lat"] = lat
        
        return Observable.create({ (observer) -> Disposable in
            ApiClient.getJSONWithMethodAndBody(urlToRequest: "https://community.dur.ac.uk/mohammed.m.rahman/api.php?action=orderDriver", method: .post, parameters: dict, callback: { (data) in
                if let fetchedData = data {
                    observer.onNext(Job.parseJobFromData(data: fetchedData))
                } else {
                    observer.onNext(nil)
                }
            })
            return Disposables.create { _ in }
        })
    }
    
    static func sendUserPhoneAndPushToke(userID: String, phone: String, push: String) -> Observable<Student?> {
        var dict: [String : String] = [:]
        dict["userID"] = userID
        dict["phoneNo"] = phone
        dict["token"] = push
        
        return Observable.create({ (observer) -> Disposable in
            ApiClient.getJSONWithMethodAndBody(urlToRequest: "https://community.dur.ac.uk/mohammed.m.rahman/api.php?action=storeTokenPhoneNo", method: .post, parameters: dict, callback: { (data) in
                if let fetcheData = data {
                    observer.onNext(Student.parseStudentFromJSON(data: fetcheData))
                } else {
                    observer.onNext(nil)
                }
            })
            return Disposables.create { _ in }
        })
    }
    
}
