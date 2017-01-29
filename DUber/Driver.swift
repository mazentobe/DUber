//
//  Driver.swift
//  DUber
//
//  Created by Mazen on 28/01/2017.
//  Copyright © 2017 Mazen. All rights reserved.
//

import Foundation
import SwiftyJSON

class Driver {
    var id: Int
    var name: String
    var surname: String
    var phone: String
    
    static var currentDriverSharderInstance: Driver?
    static var currentDriverCacheKey = "current_Driver"
    
    fileprivate let kDriverId = "id"
    fileprivate let kDriverName = "name"
    fileprivate let kDriverSurname = "surname"
    fileprivate let kDriverPhone = "phone"
    
    init(id: Int, name: String, surname: String, phone: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.phone = phone
    }
    
    init?(dict: [String: JSON]) {
        guard let id = dict[kDriverId]?.intValue,
            let name = dict[kDriverName]?.stringValue,
            let surname = dict[kDriverSurname]?.stringValue,
            let phone = dict[kDriverPhone]?.stringValue else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.surname = surname
        self.phone = phone
    }
    
    static func parseDriverFromJSON(data: Data) -> Driver? {
        let json = JSON(data: data)
        if let dict = json.dictionary {
            return Driver(dict: dict)
        }
        return nil
    }
}
