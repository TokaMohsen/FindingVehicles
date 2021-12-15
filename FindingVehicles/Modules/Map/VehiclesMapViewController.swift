//
//  VehiclesMapViewController.swift
//  FindingVehicles
//
//  Created by toka mohsen on 08/12/2021.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa
import RxMKMapView


class VehiclesMapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    // MARK: - Properties
    private let viewModel : VehiclesMapViewModel
    private let disposeBag = DisposeBag()
    private var mapChangedFromUserInteraction = false
    private var mapLocation : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    private var annotations: [CustomAnnotation] = []
    {
        didSet {
            mapView.addAnnotations(annotations)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bindViewModel()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        // make your class the delegate of the pan gesture
        panGesture.delegate = self
        // add the gesture to the mapView
        mapView.addGestureRecognizer(panGesture)
    }
    
    init(viewModel: VehiclesMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "VehiclesMapViewController" , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let location = CLLocationCoordinate2D(
            latitude: 53.4265107,
            longitude: 9.757589)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        // mapView.pointOfInterestFilter = MKPointOfInterestFilter()
        mapView.showsUserLocation = true
    }
    
    private func centerMapOnLocation(locValue: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            let center = CLLocationCoordinate2D(latitude: locValue.latitude , longitude: locValue.longitude)
            self.mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
            self.mapView.setCenter(center, animated: true)
            self.mapLocation = self.mapView.centerCoordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        centerMapOnLocation(locValue: locValue)
    }
    
    //MARK: - Rx Setup
    func bindViewModel() {
        self.viewModel.customVehiclePoints.asObservable()
            .asDriver(onErrorJustReturn: [])
            .drive(mapView.rx.annotations)
            .disposed(by: disposeBag)
    }
    
    //MARK: - MapView helpers
    private func shouldUpdateMapViewRegion(updatedRegion: MKCoordinateRegion) -> Bool
    {
        if let mapLocation = self.mapLocation{
            let differenceLat  = abs(mapLocation.latitude - updatedRegion.center.latitude)
            let differenceLong = abs(mapLocation.longitude - updatedRegion.center.longitude)
            
            if differenceLat > 0.075 || differenceLong > 0.075 {
                return true
            }
        }
        return false
    }
    
    private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = NSStringFromClass(CustomAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = UIColor.purple
            
            // Provide an custom view to use as the accessory view's detail view.
            markerAnnotationView.detailCalloutAccessoryView = DetailsView(vehicle: annotation.type ?? "type", vehicleStatus: annotation.status ?? "status")
        }
        return view
    }
    
    func displayMarkers() -> Void
    {
        centerMapOnLocation(locValue: annotations.first?.coordinate ?? CLLocationCoordinate2D(latitude: Constants.defaultP1CoordinateLatitude, longitude: Constants.defaultP1CoordinateLongitude))
    }
    
}

extension VehiclesMapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? CustomAnnotation {
            annotations.append(annotation)
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        }
        return annotationView
    }
    
    // if user changes map region will get the vehicles around it otherwise mapview will center on annotaions got from list in previoes screen
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction && shouldUpdateMapViewRegion(updatedRegion: mapView.region)) {
            // user changed map region
            print("user changed map ")
            let nePoint = CGPoint(x: mapView.bounds.origin.x + mapView.bounds.size.width, y: mapView.bounds.origin.y)
            let sePoint = CGPoint(x: mapView.bounds.origin.x, y: mapView.bounds.origin.y + mapView.bounds.size.height)
            
            let neCoord = mapView.convert(nePoint, toCoordinateFrom: mapView)
            let seCoord = mapView.convert(sePoint, toCoordinateFrom: mapView)
            
            self.viewModel.getVehicleList(p1: neCoord, p2: seCoord)
        }
        else{
            mapView.rx.didFinishLoadingMap
                .asDriver()
                .drive(onNext: { [weak self] in
                    guard let self = self else{return}
                    self.mapView.showAnnotations(self.mapView.annotations , animated: true)
                    self.centerMapOnLocation(locValue: self.annotations.first?.coordinate ?? CLLocationCoordinate2D(latitude: 53.4265107,
                                                longitude: 9.757589)) })
                .disposed(by: disposeBag)
        }
        print("map zoomed back out")
    }
    
}

extension VehiclesMapViewController: UIGestureRecognizerDelegate {
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
            if sender.state == .ended {
                mapChangedFromUserInteraction = true
                print("pan detected ")
            }
        }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
