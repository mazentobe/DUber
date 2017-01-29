//
//  DriverVC.swift
//  DUber
//
//  Created by Mazen on 29/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import UIKit

class DriverVC: UIViewController {
    var driver: Driver?
    @IBOutlet weak var tableView: UITableView!
    var jobs: [Job] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        _ = ApiClient.getJobs()
            .do(onNext: { (jobs) in
                if let fetchedJobs = jobs {
                    self.jobs = fetchedJobs
                    self.tableView.reloadData()
                }
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
    }
}

extension DriverVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobCell") as! JobCell
        _ = ApiClient.getStudentById(id: jobs[indexPath.row].studentId)
            .do(onNext: { (person) in
                if let student = person {
                    cell.name.text = "\(student.name) \(student.surname)"
                }
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
        _ = jobs[indexPath.row].location.getLocationAdressString()
            .do(onNext: { (string) in
                if let text = string {
                    cell.location.text = text
                }
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
            .subscribe { _ in }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "singleJob") as! SingleJobVC
        vc.currentJob = jobs[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
