//
//  SearchViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: AbstractViewController {
    
    // MARK: - Properties
    var address: String?
    var userInfoDict = NSDictionary()
    private var offset = 0
    private var limit = 20
    private var isPagesAvailable = false
    
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
    
    @IBOutlet var img_view: UIImageView!
    @IBOutlet var title_lbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViews()
    }
    
    // MARK: - Helpers
    private func initViews() {
        
        guard let user = Singelton.sharedObj.userInfoDict else {
            return
        }
        //
        let possibleOldImagePath = user.imagePath
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = self.documentsPathForFileName(name: oldImagePath)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            // here is your saved image:
            img_view.image = UIImage(data: oldImageData! as Data)
        }
        let welcome = "Welcome \(user.userName as! String)"
        title_lbl.text = welcome
        
        initTableView()
        fetchList()
        addObserver()
        title = welcome
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
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
        let coordinate = CLLocation(latitude: Double(Singelton.sharedObj.userInfoDict?.latitude as! String) as! CLLocationDegrees, longitude: Double(Singelton.sharedObj.userInfoDict?.longitude as! String) as! CLLocationDegrees)
        getLocationName(location: coordinate)
        
        
    }
    
    private func getLocationName(location: CLLocation)  {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error)
            } else {
                
                if let placemark = placemarks?[0] {
                    if (placemark.locality != nil) {
                        self.address = placemark.locality as? String ?? ""
                    }
                    //                    if placemark.subLocality != nil {
                    //                        self.address! += placemark.subLocality! + ", "
                    //                    }
                    YelpManager.fetchYelpBusinesses(with: self.offset, location: self.address ?? "Toronto") { (baseModel) in
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
