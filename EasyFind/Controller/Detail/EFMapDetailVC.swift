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
    var restLocation = CLLocationCoordinate2D()
    
    @IBOutlet var mapDView: MKMapView!
    @IBOutlet var segmentBtn: UISegmentedControl!
    @IBOutlet var editView: UIView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapDView.delegate = self
        mapDView.showsUserLocation = true
        
        let restLoc = MKPointAnnotation()
        restLoc.title = "Restaraunt"
        restLoc.coordinate = CLLocationCoordinate2D(latitude: passCoord.latitude ?? 0.00, longitude: passCoord.longitude ?? 0.00)
        
        // Define delta latitude and longitude
        let latDelta:CLLocationDegrees = 0.5
        let longDelta:CLLocationDegrees = 0.5
        
        // Define span
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // define location
        restLocation = CLLocationCoordinate2D(latitude: passCoord.latitude ?? 0.00, longitude: passCoord.longitude ?? 0.00)
        
        // define region
        let region = MKCoordinateRegion(center: restLocation, span: span)
        
        // set the region on the map
        mapDView.setRegion(region, animated: true)
        
        mapDView.addAnnotation(restLoc)
        
        drawRoute()
        
       
        
        
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
        
        drawRoute()
        
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
    func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default
        let request = UNNotificationRequest(identifier: "notif", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func addRegion(coordinate: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geofence")
        mapDView.removeOverlays(mapDView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinate, radius: region.radius)
        mapDView.addOverlay(circle)
    }
    
    func drawRoute() {
        // remove previous overlays
        let overlays = mapDView.overlays
        mapDView.removeOverlays(overlays)
        
        //
         addRegion(coordinate: restLocation)
        
        // draw route
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: Singelton.sharedObj.currLoc.coordinate, addressDictionary: nil))
        let destCord =  CLLocationCoordinate2D(latitude: passCoord.latitude ?? 0.00, longitude: passCoord.longitude ?? 0.00)
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
        //let location = locations[0]
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let title = "You Entered the Region"
        let message = "Wow theres cool stuff in here! YAY!"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = "You Left the Region"
        let message = "Say bye bye to all that cool stuff. =["
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
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


