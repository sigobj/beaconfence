//
//  Fence.swift
//
//  Created by Reza Emdad on 3/20/18.
//  Copyright © 2018 Objexo LLC. All rights reserved.
//
//


import Foundation
import CoreLocation

/**
 Equality operator to compare a fence and a beacon
 */
func ==(fence: Fence, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == fence.uuid.uuidString)
        && (Int(beacon.major) == Int(fence.majorValue))
        && (Int(beacon.minor) == Int(fence.minorValue)))
}

class Fence: NSObject, NSCoding {
    
    // MARK: - Constants
    
    struct Constants {
        static let nameKey = "name"
        static let uuidKey = "uuid"
        static let majorKey = "major"
        static let minorKey = "minor"
    }
    
    // MARK: - Properties

    fileprivate let name: String
    fileprivate let uuid: UUID
    fileprivate let majorValue: CLBeaconMajorValue
    fileprivate let minorValue: CLBeaconMinorValue
    fileprivate var beacon: CLBeacon?
    
    // MARK: - init
    
    init(name: String, uuid: UUID, majorValue: Int, minorValue: Int) {
        self.name = name
        self.uuid = uuid
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
    }
    
    required init(coder aDecoder: NSCoder) {
        let aName = aDecoder.decodeObject(forKey: Constants.nameKey) as? String
        name = aName ?? ""
        let aUUID = aDecoder.decodeObject(forKey: Constants.uuidKey) as? UUID
        uuid = aUUID ?? UUID()
        majorValue = UInt16(aDecoder.decodeInteger(forKey: Constants.majorKey))
        minorValue = UInt16(aDecoder.decodeInteger(forKey: Constants.minorKey))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.nameKey)
        aCoder.encode(uuid, forKey: Constants.uuidKey)
        aCoder.encode(Int(majorValue), forKey: Constants.majorKey)
        aCoder.encode(Int(minorValue), forKey: Constants.minorKey)
    }
    
    // MARK: - API
    
    /**
     Set the beacon represented by the fence object
     - Parameter  beacon: Beacon to set.
     */
    func setBeacon(beacon: CLBeacon) {
        self.beacon = beacon
    }
    
    /**
     Conversion of this fence to a beacon region
     */
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid,
                              major: majorValue,
                              minor: minorValue,
                              identifier: name)
    }
    
    /**
     Create a descriptive string from beacon info
     - Returns:  String describing the beacon location
     */
    func locationString() -> String {
        guard let beacon = beacon else { return "Location: Unknown" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = "Location: \(proximity)"
        if beacon.proximity != .unknown {
            location += " ~\(accuracy)m"
        }
        return location
    }
    
    /**
     Create a descriptive name from beacon proximity enum
     - Parameter proximity: Beacon proximity info
     - Returns:  String describing proximity of beacon in plain text
     */
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
}



