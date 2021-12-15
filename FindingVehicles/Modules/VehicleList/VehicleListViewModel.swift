//
//  VehicleListViewModel.swift
//  FindingVehicles
//
//  Created by toka mohsen on 06/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


protocol VehicleListCoordinatorProtocol {
    func navigateToMapView(with vehiclesPoints: [VehicleCellUIModel])
}

class VehicleListViewModel{
    // MARK: - Properties
    private var vehicleListService: VehiclesServiceProtocol
    private let coordinator: VehicleListCoordinatorProtocol
    private let hideActivityIndicator = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Binding Properties
    let disposeBag = DisposeBag()
    let vehicleCells = BehaviorRelay<[VehicleCellUIModel]>(value: [])
    var activityIndicator: Observable<Bool> {
        return hideActivityIndicator.asObservable()
    }
    // MARK: - Initialization
    init(coordinator: VehicleListCoordinatorProtocol, vehiclesService: VehiclesServiceProtocol) {
        self.vehicleListService = vehiclesService
        self.coordinator = coordinator
    }
    
    //get all vehicles from api and passing it to view controller
    func getVehicleList(p1 : CLLocationCoordinate2D , p2 : CLLocationCoordinate2D)
    {
        self.hideActivityIndicator.accept(false)
        vehicleListService.getVehicles(p1: p1, p2: p2).subscribe(
            onNext: { [weak self] vehicles in
                guard let self = self else{return}
                self.hideActivityIndicator.accept(true)
                self.vehicleCells.accept(vehicles.poiList.compactMap({ (point) -> VehicleCellUIModel? in
                    VehicleCellUIModel(vehicle: point)
                }))
            },
            onError: { [weak self] error in
                guard let self = self else{return}
                self.hideActivityIndicator.accept(true)
                self.vehicleCells.accept([])
            }
        )
        .disposed(by: disposeBag)
    }
    
    // navigate to mapview to show specific vehicle or to show all vehicles
    func navigateToMapView(points: [VehicleCellUIModel])
    {
        self.coordinator.navigateToMapView(with: points)
    }
}
