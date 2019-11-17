//
//  SearchViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-15.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class SearchViewController: AbstractViewController {
    
    // MARK: - Properties
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
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet var img_view: UIImageView!
    @IBOutlet var title_lbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    // MARK: - Helpers
    private func initViews() {
        
        //
        let possibleOldImagePath = Singelton.singObj.userInfoDict["user_img"] as? String
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = self.documentsPathForFileName(name: oldImagePath)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            // here is your saved image:
            img_view.image = UIImage(data: oldImageData! as Data)
        }
        
        title_lbl.text = "Welcome \(Singelton.singObj.userInfoDict["user_name"] as! String)"
        
        initTableView()
        fetchList()
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
        weak var `self` = self
        YelpManager.fetchYelpBusinesses(with: offset, location: "Toronoto") { (baseModel) in
            self?.baseModel = baseModel
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
    }
}
