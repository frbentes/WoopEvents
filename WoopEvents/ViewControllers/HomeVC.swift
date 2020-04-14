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
    @IBOutlet weak var errorView: ErrorView!
    
    private let refreshControl = UIRefreshControl()
    var activityIndicator: MDCActivityIndicator!
    var events: [Event] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorView.delegate = self
        
        configureRefreshControl()
        configureTableView()
        
        loadEvents()
    }
    
    func configureRefreshControl() {
        self.refreshControl.tintColor = UIColor.lightGray
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableEvents.refreshControl = refreshControl
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
                self.handle(error: error)
            }
        }
    }
    
    func handle(events: [Event]) {
        DispatchQueue.main.async {
            self.events = events
            self.tableEvents.reloadData()
            self.hideProgress()
            if events.count == 0 {
                self.tableEvents.alpha = 0
                self.showError(.empty)
            } else {
                self.tableEvents.alpha = 1
            }
        }
    }
    
    func handle(error: WEService.WEServiceError) {
        DispatchQueue.main.async {
            self.hideProgress()
            self.tableEvents.alpha = 0
            switch error {
            case .noConnection:
                self.showError(.connection)
            case .apiError, .invalidResponse:
                self.showError(.serviceError)
            case .decodeError, .invalidEndpoint:
                self.showError(.appInternal)
            }
        }
    }
    
    @objc
    private func refreshData() {
        reloadEvents()
    }
    
    func reloadEvents() {
        WEService.shared.allEvents() { result in
            switch result {
            case .success(let events):
                self.handle(events: events)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.events.removeAll()
                    self.tableEvents.reloadData()
                }
                self.handle(error: error)
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
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
    
    func openEventDetail(event: Event) {
        guard let navigationController = self.navigationController else { return }
        DispatchQueue.main.async {
            let vc: EventDetailVC = WeStoryboardManager.instanceViewController()
            vc.event = event
            navigationController.pushViewController(vc, animated: true)
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let event = events[indexPath.row]
        
        openEventDetail(event: event)
    }
    
}

// MARK: - Error View
extension HomeVC: ErrorViewDelegate {
    func tryToReload(_ view: ErrorView) {
        hideError()
        loadEvents()
    }
    
    func showError(_ type: EventErrorType) {
        switch type {
        case .empty, .appInternal, .serviceError:
            self.errorView.imageError.image = R.image.ic_error()
            self.errorView.labelMessage.text = type.rawValue
        case .connection:
            self.errorView.imageError.image = R.image.ic_no_connection()
            self.errorView.labelMessage.text = type.rawValue
        }
        self.errorView.isHidden = false
    }
    
    func hideError() {
        self.errorView.isHidden = true
    }
    
}

enum EventErrorType: String {
    case connection = "Erro de conexão."
    case empty = "Sem eventos."
    case appInternal = "Erro interno."
    case serviceError = "Erro no servidor."
}
