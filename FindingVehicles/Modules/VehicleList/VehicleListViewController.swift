//
//  VehicleListViewController.swift
//  FindingVehicles
//
//  Created by toka mohsen on 06/12/2021.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import CoreLocation

class VehicleListViewController : UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var vehiclesTableView: UITableView!
    @IBOutlet weak var showVehiclesOnMapButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Properties
    private let viewModel : VehicleListViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Constants
    private let KdefaultP1 = CLLocationCoordinate2D(latitude: Constants.defaultP1CoordinateLatitude, longitude: Constants.defaultP1CoordinateLongitude)
    private let KdefaultP2 = CLLocationCoordinate2D(latitude: Constants.defaultP2CoordinateLatitude, longitude: Constants.defaultP2CoordinateLongitude)
    
    // MARK: - Initialization
    init(viewModel: VehicleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "VehicleListViewController" , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        vehiclesTableView.register(VehicleTableCell.cellNib , forCellReuseIdentifier: VehicleTableCell.cellId)
        vehiclesTableView.estimatedRowHeight = 200
        vehiclesTableView.rowHeight = UITableView.automaticDimension
        bindActivityIndicator()
        handleShowVehiclesAction()
        bindViewModel()
        setupCellTapHandling()
        viewModel.getVehicleList(p1: KdefaultP1, p2: KdefaultP2)
//        vehiclesTableView
//            .rx.setDelegate(self)
//            .disposed(by: disposeBag)
    }
   
    //MARK: Rx Setup
    
    func handleShowVehiclesAction()
    {
        showVehiclesOnMapButton.rx.tap.bind {
            self.viewModel.navigateToMapView(points: self.viewModel.vehicleCells.value)
            
        }.disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        self.viewModel.vehicleCells.asObservable().bind(to: self.vehiclesTableView.rx.items(cellIdentifier: VehicleTableCell.cellId, cellType: VehicleTableCell.self)) {_, element, cell in
            cell.viewModel = element
        }.disposed(by: self.disposeBag)
    }

    // show or hide activity indicator
    private func bindActivityIndicator(){
        self.viewModel.activityIndicator
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    
    private func setupCellTapHandling() {
        vehiclesTableView
            .rx
            .modelSelected(VehicleCellUIModel.self)
            .subscribe(
                onNext: { [weak self] vehiclePoint in
                    guard let self = self else{return}
                                            self.viewModel.navigateToMapView(points: [vehiclePoint])
                    
                    if let selectedRowIndexPath = self.vehiclesTableView.indexPathForSelectedRow {
                        self.vehiclesTableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}

//extension VehicleListViewController: UITableViewDelegate{
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return 100
////    }
//
//    // handle show all vehicles btn action
//}
