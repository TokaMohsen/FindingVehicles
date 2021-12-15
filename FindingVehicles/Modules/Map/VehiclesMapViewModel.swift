//
//  VehiclesMapViewModel.swift
//  FindingVehicles
//
//  Created by toka mohsen on 10/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class VehiclesMapViewModel{
    // MARK: - Properties
    private let points = BehaviorRelay<[CustomAnnotation]>(value: [])
    private var vehicleListService: VehiclesServiceProtocol

    // MARK: - Binding Properties
    let disposeBag = DisposeBag()
    var customVehiclePoints: Observable<[CustomAnnotation]> {
        return points.asObservable()
    }
    // MARK: - Initialization
    //get all vehicle points from vehicle list and passing it to view in map
    init(points : [VehicleCellUIModel], vehiclesService: VehiclesServiceProtocol) {
        self.vehicleListService = vehiclesService
        getVehiclesPoints(vehiclePoints: points)
    }
    
    // create custom annotation points and passing it to view controller
    private func getVehiclesPoints( vehiclePoints : [VehicleCellUIModel]) {
        let customPoints = vehiclePoints.compactMap { (vehicleModel) -> CustomAnnotation in
            let coordinate = CLLocationCoordinate2D(latitude: vehicleModel.coordinate.latitude,
                                                    longitude: vehicleModel.coordinate.longitude)
            return CustomAnnotation(coordinate: coordinate, pointId: vehicleModel.id, type: vehicleModel.type, status: vehicleModel.status)
        }
        points.accept(customPoints)
    }
    
    //get all vehicles around two points from api to update mapview with new vehicles around the new location
    func getVehicleList(p1 : CLLocationCoordinate2D , p2 : CLLocationCoordinate2D)
    {
        vehicleListService.getVehicles(p1: p1, p2: p2).subscribe(
            onNext: { [weak self] vehicles in
                guard let self = self else{return}
                let points =  vehicles.poiList.compactMap({ (point) -> VehicleCellUIModel? in
                    VehicleCellUIModel(vehicle: point)
                })
                self.getVehiclesPoints(vehiclePoints: points)
            },
            onError: { [weak self] error in
                guard let self = self else{return}
                self.getVehiclesPoints(vehiclePoints: [])
            }
        )
        .disposed(by: disposeBag)
    }
}
