//
//  CallSuccessVC.swift
//  DUber
//
//  Created by Mazen on 29/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import UIKit

class CallSuccessVC: UIViewController {
    var job: Job!
    @IBOutlet weak var desctination: UILabel!
    @IBOutlet weak var initial: UILabel!
    @IBOutlet weak var waiting: UILabel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateJob), userInfo: nil, repeats: true)
        
        desctination.text = ""
        initial.text = ""
        _ = job.location.getLocationAdressString()
            .do(onNext: { (string) in
                self.initial.text = string
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
        _ = ApiClient.getStudentById(id: job.studentId)
            .do(onNext: { (person) in
                if let student = person {
                    self.desctination.text = student.college
                }
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
    }
    
    func updateJob() {
       _ = ApiClient.getJobById(jobId: job.id)
            .do(onNext: { (job) in
                if job?.driverId != 0 {
                    self.waiting.text = "Driver is on the way!"
                    self.timer.invalidate()
                }
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
        .subscribe { _ in }
    }
}
