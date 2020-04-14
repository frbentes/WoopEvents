//
//  EventDetailVC.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 11/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController, WeStoryboardViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imageHeader: UIImageView!
    
    var event: Event!
    
    static func getStoryboardName() -> String {
        return "Main"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureHeaderView()
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        self.tableView.register(UINib(nibName: R.nib.eventResumeCell.name, bundle: nil),
                                  forCellReuseIdentifier: EventResumeCell.reusableIdentifier)
    }
    
    func configureHeaderView() {
        if let url = event.imageUrl {
            let targetSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
            self.imageHeader.load(fromUrl: url, placeholdered: true, targetSize: targetSize)
        } else {
            self.imageHeader.image = R.image.ic_placeholder_event()
        }
    }
    
    func openCheckin() {
        guard let navigationController = self.navigationController else { return }
        DispatchQueue.main.async {
            let vc: CheckinVC = WeStoryboardManager.instanceViewController()
            vc.eventId = self.event.id
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func shareEvent() {
        
    }

}

// MARK: - Table View
extension EventDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventResumeCell.reusableIdentifier) as! EventResumeCell
        cell.delegate = self
        cell.event = event
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Event Resume
extension EventDetailVC: EventResumeCellDelegate {
    func tapCheckin() {
        openCheckin()
    }
    
    func tapShare() {
        shareEvent()
    }
    
}
