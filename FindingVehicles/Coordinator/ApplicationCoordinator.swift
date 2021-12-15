//
//  ApplicationCoordinator.swift
//  FindingVehicles
//
//  Created by toka mohsen on 07/12/2021.
//

import Foundation
import UIKit
import CoreLocation

class ApplicationCoordinator {
    private(set) var window: UIWindow?
    
    func start(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
    
    private lazy var rootNavigationController: UINavigationController = {
        let service = VehiclesService()
        let viewModel = VehicleListViewModel(coordinator: self, vehiclesService: service)
        let viewController = VehicleListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()
    
}

extension ApplicationCoordinator: VehicleListCoordinatorProtocol{
    
    func navigateToMapView(with vehiclesPoints: [VehicleCellUIModel]){
        let service = VehiclesService()
        let viewModel = VehiclesMapViewModel.init(points: vehiclesPoints, vehiclesService: service)
        let viewController = VehiclesMapViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}
