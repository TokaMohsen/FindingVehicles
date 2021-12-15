//
//  VehiclesData.swift
//  FindingVehicles
//
//  Created by toka mohsen on 05/12/2021.
//

import Foundation

struct VehicleData: Codable {
    let poiList: [PoiList]
}

// MARK: - PoiList
struct PoiList: Codable {
    let id: Int
    let coordinate: Coordinate
    let state: State
    let type: TypeEnum
    let heading: Double
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let latitude, longitude: Double
}

enum State: String, Codable {
    case active = "ACTIVE"
}

enum TypeEnum: String, Codable {
    case taxi = "TAXI"
}
