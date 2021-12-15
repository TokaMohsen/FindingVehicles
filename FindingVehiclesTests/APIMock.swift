//
//  APIMock.swift
//  FindingVehiclesTests
//
//  Created by toka mohsen on 11/12/2021.
//
@testable import FindingVehicles
import RxSwift
import CoreLocation

class serviceSuccessMock: VehiclesServiceProtocol {
    func getVehicles(p1: CLLocationCoordinate2D , p2: CLLocationCoordinate2D) -> Observable<VehicleData> {
        
        return Observable.create { observer -> Disposable in
            let vehicle = VehicleData.init(poiList: [PoiList(id: 1, coordinate: Coordinate(latitude: Constants.defaultP1CoordinateLatitude, longitude: Constants.defaultP1CoordinateLongitude), state: State(rawValue: "Taxi") ?? .active, type: .taxi, heading: 0.003)])
           
            observer.onNext(vehicle)
            return Disposables.create()
        }
    }
}

class serviceFailureMock: VehiclesServiceProtocol {

    func getVehicles(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) -> Observable<VehicleData> {
        return Observable.create { observer -> Disposable in
            observer.onError(FNError.badRequest)
            return Disposables.create()
        }
    }
}
