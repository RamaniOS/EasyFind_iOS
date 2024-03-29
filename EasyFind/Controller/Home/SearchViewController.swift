//
//  SearchViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchViewController: AbstractViewController {
    
    // MARK: - Properties
    var address: String?
    var userInfoDict = NSDictionary()
    private var offset = 0
    private var limit = 20
    private var isPagesAvailable = false
    private let persistent = PersistenceManager.shared
    var locationManager: CLLocationManager! = nil
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    var baseModel: BaseBusiness? = nil {
        didSet {
            guard let base = baseModel, base.businesses!.count > 0 else {
                return
            }
            isPagesAvailable = base.total! > items.count
            items.append(contentsOf: base.businesses!)
        }
    }
    
    var items: [Businesses] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.reloadTable()
            }
        }
    }
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard UserStore.isLogin else {
            ActionShowLogin.execute()
            return
        }
        fetchUseDetails()
        initViews()
        initLocation()
    }
    
    private func initLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    private func fetchUseDetails() {
        persistent.fetch(type: User.self) { (users) in
            //
            for user in users {
                if(UserStore.loginEmail == user.userName) {
                    Singelton.sharedObj.userInfoDict = user
                }
            }
        }
    }
    
    // MARK: - Helpers
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "We need location access.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func initViews() {
        initTableView()
        fetchList()
        addObserver()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter location name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: .favRefreshKey, object: nil)
    }
    
    @objc private func reloadTable() {
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: cellClass.reuseId, bundle: nil), forCellReuseIdentifier: cellClass.reuseId)
        tableView.tableFooterView = UIView()
    }
    
    private func requestForNextPage() {
        offset += limit
        fetchList()
    }
    
    private func fetchList() {
        guard let latString = Singelton.sharedObj.userInfoDict?.latitude, let longString = Singelton.sharedObj.userInfoDict?.longitude else {
            return
        }
        let location = CLLocation(latitude: Double(latString)!, longitude:  Double(longString)!)
        getLocationName(location: location)
    }
    
    private func getLocationName(location: CLLocation)  {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error)
            } else {
                if let placemark = placemarks?[0] {
                    if (placemark.locality != nil) {
                        self.address = placemark.locality ?? ""
                    }
                    self.indicator.startAnimating()
                    YelpManager.fetchYelpBusinesses(with: self.offset, location: self.address ?? "Toronto") { (baseModel) in
                        self.indicator.stopAnimating()
                        self.baseModel = baseModel
                    }
                }
            }
        }
    }
    
    private var cellClass: SearchTableViewCell.Type {
        return SearchTableViewCell.self
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellClass.reuseId, for: indexPath) as? SearchTableViewCell)!
        cell.business = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if items.count > 0 {
            let lastItemReached = indexPath.item == items.count - 1
            if isPagesAvailable && lastItemReached {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    self.requestForNextPage()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellClass.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(EFDetailScreenVC.control(with: items[indexPath.row]), animated: true)
    }
}

/*
 Manage search bar delegates
 */
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text else { return }
        weak var `self` = self
        offset = 0
        YelpManager.fetchYelpBusinesses(with: offset, location: location) { (baseModel) in
            self?.items.removeAll()
            self?.baseModel = baseModel
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            //
            Singelton.sharedObj.currLoc = location
            print(location.coordinate)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error :\(error)")
    }
}


