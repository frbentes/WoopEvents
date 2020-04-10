//
//  HomeVC.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 09/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableEvents: UITableView!
    
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
        
        self.tableEvents.register(UINib(nibName: R.nib.eventCell.name, bundle: nil), forCellReuseIdentifier: EventCell.reusableIdentifier)
    }
    
    func loadEvents() {
        
    }
    
}

// MARK: - Table View
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reusableIdentifier) as! EventCell
        
        return cell
    }
    
}
