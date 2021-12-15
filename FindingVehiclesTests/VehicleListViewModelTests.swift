//
//  VehicleListViewModelTests.swift
//  FindingVehiclesTests
//
//  Created by toka mohsen on 11/12/2021.
//

import XCTest
import RxSwift
import CoreLocation
@testable import FindingVehicles

class VehicleListViewModelTests: XCTestCase {
    private let KdefaultP1 = CLLocationCoordinate2D(latitude: Constants.defaultP1CoordinateLatitude, longitude: Constants.defaultP1CoordinateLongitude)
    private let KdefaultP2 = CLLocationCoordinate2D(latitude: Constants.defaultP2CoordinateLatitude, longitude: Constants.defaultP2CoordinateLongitude)
    
    override func setUp() {
        super.setUp()
   }

    override func tearDown() {
        super.tearDown()
    }
    

    func testVehiclesCount_WhenAPIReturnAllData() {
        let viewModel = VehicleListViewModel(coordinator: ApplicationCoordinator(), vehiclesService: serviceSuccessMock())
        viewModel.getVehicleList(p1: KdefaultP1, p2: KdefaultP2)
        XCTAssertEqual(viewModel.vehicleCells.value.count, 1)
    }

    func testVehiclesCount_WhenDataReturnsError() {
        let viewModel = VehicleListViewModel(coordinator: ApplicationCoordinator(), vehiclesService: serviceFailureMock())

        viewModel.getVehicleList(p1: KdefaultP1, p2: KdefaultP2)
        XCTAssertEqual(viewModel.vehicleCells.value.count , 0)
    }

}

