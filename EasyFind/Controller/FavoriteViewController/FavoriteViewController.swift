//
//  FavoriteViewController.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2019-11-17.
//  Copyright © 2019 Ramanpreet Singh. All rights reserved.
//

import UIKit

class FavoriteViewController: AbstractViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Businesses] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    // MARK: - Helpers
    private func initViews() {
        title = "Favorite List"
        navigationController?.navigationBar.prefersLargeTitles = true
        initTableView()
        fetchList()
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: cellClass.reuseId, bundle: nil), forCellReuseIdentifier: cellClass.reuseId)
        tableView.tableFooterView = UIView()
    }
    
    private func fetchList() {
        items = FavoriteStore.fetchAllFav
    }
    
    private var cellClass: SearchTableViewCell.Type {
        return SearchTableViewCell.self
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellClass.reuseId, for: indexPath) as? SearchTableViewCell)!
        cell.business = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellClass.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DetailViewController.control(with: items[indexPath.row]), animated: true)
    }
}
