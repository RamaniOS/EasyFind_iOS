//
//  EFMapDetailVC.swift
//  EasyFind
//
//  Created by Nitin on 18/01/20.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit
import MapKit

class EFMapDetailVC: UIViewController {
    
    // MARK: - Properties
    var locationManager = CLLocationManager()
    var moveType: String = "A"
    var passCoord: cordDetail!
    
    @IBOutlet var mapDView: MKMapView!
    @IBOutlet var segmentBtn: UISegmentedControl!
    @IBOutlet var editView: UIView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        editView.isHidden = true
        
        mapDView.delegate = self
        mapDView.showsUserLocation = true
        let restLoc = MKPointAnnotation()
        restLoc.title = "Restaraunt"
        restLoc.coordinate = CLLocationCoordinate2D(latitude: Double(passCoord.latitude ?? "0.00") as! CLLocationDegrees, longitude: Double(passCoord.longitude ?? "0.00") as! CLLocationDegrees)
        
        mapDView.addAnnotation(restLoc)
        
    }
    
    // MARK: - Action
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func moreBtnClicked(_ sender: Any) {
        if(editView.isHidden == true){
            editView.isHidden = false
        }else{
            editView.isHidden = true
        }
    }
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        // remove previous overlays
        let overlays = mapDView.overlays
        mapDView.removeOverlays(overlays)
        
        if sender.selectedSegmentIndex == 0 {
            moveType = "A"
        }else{
            moveType = "W"
        }
        
    }
    
    @IBAction func zoomOutBtnClicked(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: mapDView.region.span.latitudeDelta*2, longitudeDelta: mapDView.region.span.longitudeDelta*2)
        let region = MKCoordinateRegion(center: mapDView.region.center, span: span)
        
        mapDView.setRegion(region, animated: true)
    }
    
    @IBAction func zoomInBtnClicked(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: mapDView.region.span.latitudeDelta/2, longitudeDelta: mapDView.region.span.longitudeDelta/2)
        let region = MKCoordinateRegion(center: mapDView.region.center, span: span)
        
        mapDView.setRegion(region, animated: true)
    }
    
    // MARK: - Helper
    func drawRoute() {
        // remove previous overlays
        let overlays = mapDView.overlays
        mapDView.removeOverlays(overlays)
        
        // draw route
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: Singelton.sharedObj.currLoc.coordinate, addressDictionary: nil))
        let destCord =  CLLocationCoordinate2D(latitude: Double(Singelton.sharedObj.userInfoDict!.latitude ?? "0.00") as! CLLocationDegrees, longitude: Double(Singelton.sharedObj.userInfoDict!.longitude ?? "0.00") as! CLLocationDegrees)
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destCord, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        if(moveType == "A"){
            request.transportType = .automobile
        }else{
            request.transportType = .walking
        }
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            let route = unwrappedResponse.routes[0]
            self.mapDView.addOverlay(route.polyline)
            self.mapDView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            //            for route in unwrappedResponse.routes {
            //                self.mapview.addOverlay(route.polyline)
            //                self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            //            }
        }
    }
}

extension EFMapDetailVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
    }
}

extension EFMapDetailVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            return annotationView
        }
    }
    
    /// this function is needed to add overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.green
            renderer.lineWidth = 2.0
            return renderer
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3.0
            return renderer
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2.0
            return renderer
        }
        
        return MKOverlayRenderer()
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation as? Place, let title = annotation.title else {
            return
        }
        
        let alertController = UIAlertController(title: "Welcome to \(title)", message: "Have a good time in \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}
