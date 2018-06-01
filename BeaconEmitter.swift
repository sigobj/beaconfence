//
//  BeaconEmitter.swift
//
//  Created by Reza Emdad on 3/20/18.
//  Copyright © 2018 Objexo LLC. All rights reserved.
//

import UIKit

import CoreBluetooth
import CoreLocation

class BeaconEmitter: UIViewController {
    
    // MARK: - Constants
    
    /// - ToDo: handle using config mgr
    private let UUID = "EE7C8AFC-4DED-48D6-9E17-19CF106D89EF"
    private let major: CLBeaconMajorValue = 501
    private let minor: CLBeaconMinorValue = 201
    private let BeaconRegionID = "BeaconRegion01"
    
    // MARK: - Properties
    
    /// A dictionary with data used in advertisement
    private var advertiseData: NSDictionary!
    private var peripheralManager: CBPeripheralManager!
    private var updateTimer = Timer()
    private let timerInterval: TimeInterval = 1
    
    // MARK: - Outlets
    
    @IBOutlet weak var startAdvBtn: UIButton!
    @IBOutlet weak var stopAdvBtn: UIButton!
    @IBOutlet weak var btStateLabel: UILabel!
    @IBOutlet weak var isAdvertisingLabel: UILabel!
    
    // MARK: - Actions
    
    /**
     Button to start advertising/emitting
     */
    @IBAction func startEmit(_ sender: Any) {
        startBeacon()
    }
    
    /**
     Button to stop advertising/emitting
     */
    @IBAction func stopEmit(_ sender: Any) {
        stopBeacon()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBeacon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helpers
    
    /**
     Create a beacon region with hardcoded UUID, major, and minor for testing
     */
    private func createBeacon() {
        if let proximityUUID = NSUUID(uuidString: UUID) {
            let beaconRegion = CLBeaconRegion(proximityUUID:  proximityUUID as UUID, major: major, minor: minor, identifier: BeaconRegionID)
            advertiseData = beaconRegion.peripheralData(withMeasuredPower: nil)
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        }
        else {
            return
        }
        
        startTimer()
    }
    
    /**
     Start a repeating timer to update UI
     */
    private func startTimer() {
        if updateTimer.isValid {
            print("Timer already running.")
            return
        }
        updateTimer = Timer.scheduledTimer(timeInterval: timerInterval,
                                     target: self,
                                     selector: #selector(self.updateUI),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    /**
     Update the UI
     */
    func updateUI() {
        let isAdvertising = self.peripheralManager.isAdvertising
        let btState = peripheralManager.state.rawValue
        print("isAdvertising? \(isAdvertising), State = \(btState)")
        btStateLabel.text = "BT State: " + btState.description
        isAdvertisingLabel.text = "Is Advertising? " + isAdvertising.description
        startAdvBtn.isEnabled = !isAdvertising
        stopAdvBtn.isEnabled = isAdvertising
    }
    
    /**
     Start advertising
     */
    private func startBeacon() {
        print("startBeacon")
        peripheralManager.startAdvertising(advertiseData as! [String : Any]?)
    }
    
    /**
     Stop advertising
     */
    private func stopBeacon() {
        print("stopBeacon")
        peripheralManager.stopAdvertising()
    }
}

// MARK: - CBPeripheralManagerDelegate

extension BeaconEmitter: CBPeripheralManagerDelegate {
 
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        print("peripheralManagerIsReady")
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising")
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState.")
    }
    
}
