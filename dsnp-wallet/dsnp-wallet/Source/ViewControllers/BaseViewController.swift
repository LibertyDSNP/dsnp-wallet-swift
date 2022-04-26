//
//  BaseViewController.swift
//  UsNative
//
//  Created by Ryan Sheh on 6/1/21.
//

import Foundation
import UIKit

class BaseViewController: UITableViewController {
    
    let defaultCellId = "DefaultCell"
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.defaultCellId)
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewControllerFactory.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCellId, for: indexPath)
        let vc = ViewControllerFactory.allCases[indexPath.row]
        cell.textLabel?.text = vc.rawValue
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vcFactoryCase = ViewControllerFactory.allCases[indexPath.row]
        let vc = vcFactoryCase.instance()
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
}
