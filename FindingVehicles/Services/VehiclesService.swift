//
//  VehiclesService.swift
//  FindingVehicles
//
//  Created by toka mohsen on 05/12/2021.
//

import Foundation
import Alamofire
import RxSwift
import CoreLocation

protocol VehiclesServiceProtocol {
    func getVehicles(p1: CLLocationCoordinate2D , p2: CLLocationCoordinate2D) -> Observable<VehicleData>
}

class VehiclesService: VehiclesServiceProtocol{

    func getVehicles(p1: CLLocationCoordinate2D , p2: CLLocationCoordinate2D) -> Observable<VehicleData> {
        return Observable.create { observer -> Disposable in
            let param = ["p1Lon": String(p1.longitude),
                         "p1Lat": String(p1.latitude),
                         "p2Lon": String(p2.longitude),
                         "p2Lat": String(p2.latitude)]
            
            NetworkingService<VehicleData>.getData(parameters: param, url: Endpoints.GetVehicles) { (result: Result<VehicleData, FNError>) in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                case .failure:
                    observer.onError(FNError.badRequest)
                    
                }
            }
            return Disposables.create()
        }
    }
}
