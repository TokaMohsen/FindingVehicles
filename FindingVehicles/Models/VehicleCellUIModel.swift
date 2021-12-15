//
//  VehicleCellUIModel.swift
//  FindingVehicles
//
//  Created by toka mohsen on 06/12/2021.
//

import Foundation

struct VehicleCellUIModel {
    let coordinate: Coordinate
    let type: String
    let status: String
    let id: Int
}

extension VehicleCellUIModel {
    init(vehicle: PoiList) {
        self.coordinate = vehicle.coordinate
        self.type = vehicle.type.rawValue
        self.status = vehicle.state.rawValue
        self.id = vehicle.id
    }
}
