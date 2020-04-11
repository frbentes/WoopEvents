//
//  HomeVC.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 09/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import MaterialComponents.MDCActivityIndicator

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableEvents: UITableView!
    
    var activityIndicator: MDCActivityIndicator!
    var events: [Event] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        loadEvents()
    }
    
    func configureTableView() {
        self.tableEvents.delegate = self
        self.tableEvents.dataSource = self
        self.tableEvents.separatorStyle = .none
        
        self.tableEvents.register(UINib(nibName: R.nib.eventCell.name, bundle: nil),
                                  forCellReuseIdentifier: EventCell.reusableIdentifier)
    }
    
    func loadEvents() {
        showProgress()
        WEService.shared.allEvents() { result in
            switch result {
                case .success(let events):
                    self.handle(events: events)
                case .failure(let error):
                    self.handle(error: error.localizedDescription)
             }
        }
    }
    
    func handle(events: [Event]) {
        self.events = events
        DispatchQueue.main.async {
            self.hideProgress()
            self.tableEvents.reloadData()
        }
    }
    
    func handle(error: String) {
        print(error)
        DispatchQueue.main.async {
            self.hideProgress()
        }
    }
    
    func showProgress() {
        let width: CGFloat = view.bounds.width / 2
        let height: CGFloat = view.bounds.height / 2
        let frame: CGRect = CGRect(x: width - 16, y: height - 16, width: 32, height: 32)
        
        self.activityIndicator = MDCActivityIndicator(frame: frame)
        self.activityIndicator.sizeToFit()
        self.view.addSubview(activityIndicator)
        
        self.activityIndicator.startAnimating()
    }
    
    func hideProgress() {
        self.activityIndicator.stopAnimating()
    }
    
}

// MARK: - Table View
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reusableIdentifier) as! EventCell
        
        cell.event = events[indexPath.row]
        
        return cell
    }
    
}
