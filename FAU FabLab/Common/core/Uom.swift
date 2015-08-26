//
// Created by Sebastian Haubner on 06.08.15.
// Copyright (c) 2015 FAU MAD FabLab. All rights reserved.
//

import Foundation
import ObjectMapper

class Uom : Mappable{

    private(set) var uomId: Int64?
    private(set) var uomType: String?
    private(set) var name: String?
    private(set) var rounding: Double?

    class func newInstance() -> Mappable {
        return Uom()
    }

    func mapping(map: Map) {
        uomId <- map["uomId"]
        uomType <- map["uomType"]
        rounding <- map["rounding"]
        name <- map["name"]
    }
}