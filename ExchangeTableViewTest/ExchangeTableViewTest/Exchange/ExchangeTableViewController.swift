//
//  ExchangeTableViewController.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 26.01.2021.
//

import UIKit

class ExchangeTableViewController: UIViewController {
    
    var exchangeDataSource = [Currency]()
    
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ExchangeTableViewCell", bundle: nil), forCellReuseIdentifier: "exchangeID")
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(getData), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
        
        refreshControl?.beginRefreshing()
        getData()
        tableView.reloadData()
    }
    
    @objc private func getData() {
        Currency.performRequest() {
            [weak self] (isSuccess, response) in
            guard let self = self else {return}
            if isSuccess == true {
                self.exchangeDataSource = response
            }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                if isSuccess { self.tableView.reloadData() }
            }
        }
    }
}

extension ExchangeTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exchangeDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeID", for: indexPath) as? ExchangeTableViewCell {
            cell.setModelToUI(with: exchangeDataSource[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
