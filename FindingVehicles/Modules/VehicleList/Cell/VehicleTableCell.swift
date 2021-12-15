//
//  VehicleTableCell.swift
//  FindingVehicles
//
//  Created by toka mohsen on 05/12/2021.
//

import Foundation
import UIKit

class VehicleTableCell: UITableViewCell{
    @IBOutlet private weak var idLabel: UILabel!
    
    @IBOutlet private weak var statusLabel: UILabel!
    
    @IBOutlet private weak var typeLabel: UILabel!
    
    @IBOutlet private weak var iconImageView: UIImageView!
    
    static let cellNib = UINib(nibName: "VehicleTableCell", bundle: nil)
    static let cellId = "VehicleTableCellId"
    
    
    var viewModel: VehicleCellUIModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            idLabel?.text = String(viewModel.id)
            statusLabel?.text = viewModel.status
            typeLabel?.text = viewModel.type
            iconImageView.image = UIImage(named: "carIcon")
        }
    }

}
