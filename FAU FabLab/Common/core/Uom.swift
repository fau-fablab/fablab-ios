//
// Created by Sebastian Haubner on 06.08.15.
// Copyright (c) 2015 FAU MAD FabLab. All rights reserved.
//

import Foundation
import ObjectMapper

class Uom : Mappable{

    private(set) var uomId:     Int64?
    private(set) var uomType:   String?
    private(set) var name:      String?
    private(set) var rounding:  Double?

    required init?(_ map: Map){}
    
    func mapping(map: Map) {
        uomId       <- (map["uomId"], Int64Transform())
        uomType     <-  map["uomType"]
        rounding    <-  map["rounding"]
        name        <-  map["name"]
    }
}