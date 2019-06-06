//
//  Favorite.swift
//  QuickWeather
//
//  Created by m2sar on 28/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import Foundation

class Favorite : NSObject, NSCoding {
    let name : String
    let country : String
    let id : Int64
    
    init(name : String, country : String, id : Int64) {
        self.name  = name
        self.country = country
        self.id = id
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encodeCInt(Int32(self.id), forKey: "id")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let country = aDecoder.decodeObject(forKey: "country") as? String,
            let id = aDecoder.decodeInteger(forKey: "id") as? Int64
            else { return nil }
        self.init(
            name: name,
            country: country,
            id: Int64(aDecoder.decodeInteger(forKey: "id"))
        )
    }
    
    
}
