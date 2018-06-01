//
//  BeaconFence.swift
//
//  Created by Reza Emdad on 3/20/18.
//  Copyright © 2018 Objexo LLC. All rights reserved.
//
//

import UIKit
import CoreLocation

class BeaconFence: UIViewController {
    
    // MARK: - Constants

    /// - ToDo: handle using config mgr
    private static let uuid = "EE7C8AFC-4DED-48D6-9E17-19CF106D89EF"
    private static let major = 501
    private static let minor = 201
    private static let BeaconRegionID = "BeaconRegion01"
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    fileprivate let fence = Fence(name: BeaconRegionID, uuid: UUID(uuidString: uuid)!, majorValue: major, minorValue: minor)
    
    // MARK: - Outlets

    @IBOutlet weak var locationLabel: UILabel!

    // MARK: - Actions
    
    /**
     Button to start monitoring regions
     */
    @IBAction func startMonitoringAction(_ sender: Any) {
        self.startMonitoring(fence)
    }
    
    /**
     Button to stop monitoring regions
     */
    @IBAction func stopMonitoringAction(_ sender: Any) {
        self.stopMonitoring(fence)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locationLabel.text = fence.locationString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Helpers

    /**
     Start monitoring a fence/region
     - Parameter fence: fence/region to monitor
     */
    private func startMonitoring(_ fence: Fence) {
        let beaconRegion = fence.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    /**
     Stop monitoring a fence/region
     - parameter  fence: fence/region to stop monitoring
     */
    private func stopMonitoring(_ fence: Fence) {
        let beaconRegion = fence.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    /**
     Local notification to show when a region was entered/exit
     - Parameter  msg: Message to show.
     */
    fileprivate func localNotification(msg: String) {
        let notification = UILocalNotification()
        notification.alertBody = msg
        notification.fireDate = Date()
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.presentLocalNotificationNow(notification)
    }

}

// MARK: - CLLocationManagerDelegate

extension BeaconFence: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region: \(region?.identifier ?? "") \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Monitoring started for region: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("didRangeBeacons for region: \(region.identifier). #beacons: \(beacons.count)")
        for beacon in beacons {
            if fence == beacon {
                fence.setBeacon(beacon: beacon)
            }
        }
        self.locationLabel.text = fence.locationString()
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion for region: \(region.identifier)")
        guard region is CLBeaconRegion else {
            print("Exit from non-beacon region")
            return
        }
        let msg = "EXIT Beacon \(region.identifier)"

        if UIApplication.shared.applicationState == .active {
            showAlert(withTitle: "EXIT", message: msg)
        }
        else {
            localNotification(msg: msg)
        }
    }}


