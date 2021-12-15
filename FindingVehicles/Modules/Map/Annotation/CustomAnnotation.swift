//
//  CustomAnnotation.swift
//  FindingVehicles
//
//  Created by toka mohsen on 08/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class CustomAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    // Required if you set the annotation view's `canShowCallout` property to `true`
    var title: String?
    var type: String?
    var status: String?
    // This property defined by `MKAnnotation` is not required.
    
    init(coordinate: CLLocationCoordinate2D , pointId : Int, type: String, status: String ) {
        self.coordinate = coordinate
        self.title = "num: " + "\(pointId)"
        self.status = status
        self.type = type
    }
}
