//
//  Student.swift
//  DUber
//
//  Created by Mazen on 28/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Student {
    
    static var sharedCurrentStudentInstance: Student?
    static var currentStudentCacheKey = "current_student"
    
    static var pushToken: String = "testToken"
    
    var id: String
    var name: String
    var surname: String
    var email: String
    var phone: String?
    var college: String
    var pushToken: String?
    
    fileprivate let kStudentId = "user_id"
    fileprivate let kStudentName = "first_name"
    fileprivate let kStudentSurname = "last_name"
    fileprivate let kStudentEmail = "email"
    fileprivate let kStudentPhone = "phone"
    fileprivate let kStudentCollege = "college"
    fileprivate let kStudentPushToken = "push_token"
    
    init(id: String, name: String, surname: String, email: String, phone: String?, college: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.phone = phone
        self.college = college
    }
    
    init?(dict: [String : JSON]) {
        guard let id = dict[kStudentId]?.stringValue,
            let name = dict[kStudentName]?.stringValue,
            let surname = dict[kStudentSurname]?.stringValue,
            let email = dict[kStudentEmail]?.stringValue,
            let college = dict[kStudentCollege]?.stringValue else {
                return nil
        }
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.phone = dict[kStudentPhone]?.stringValue
        self.college = college
    }
    
    func getDictWithPushTokeAndPhone() -> [String : String] {
        var dict: [String : String] = [:]
        dict[kStudentId] = String(self.id)
        dict[kStudentPhone] = self.phone!
        dict[kStudentPushToken] = self.pushToken!
        return dict
    }
    
    static func parseStudentFromJSON(data : Data) -> Student? {
        let json = JSON(data: data)
        if let array = json.array?[0] {
            guard let dict = array.dictionary else {
                return nil
            }
            return Student(dict: dict)
        }
        return nil
    }
}
