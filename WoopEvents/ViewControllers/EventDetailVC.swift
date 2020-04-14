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
        self.tableView.accessibilityIdentifier = AccessibilityIdentifiers.eventDetailTable
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        self.tableView.register(UINib(nibName: R.nib.eventResumeCell.name, bundle: nil),
                                forCellReuseIdentifier: EventResumeCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: R.nib.personCell.name, bundle: nil),
                                forCellReuseIdentifier: PersonCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: R.nib.couponTableCell.name, bundle: nil),
                                forCellReuseIdentifier: CouponTableCell.reusableIdentifier)
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
        DispatchQueue.main.async {
            let renderer = UIGraphicsImageRenderer(size: self.view.bounds.size)
            let image = renderer.image { ctx in
                self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
            }
            
            let activityController = UIActivityViewController(activityItems: [image], applicationActivities: [])
            self.present(activityController, animated: true)
        }
    }

}

// MARK: - Table View
extension EventDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    private func isResumeSection(_ section: Int) -> Bool {
        return section == 0
    }
    
    private func isPeopleSection(_ section: Int) -> Bool {
        if event.people.count > 0 {
            return section == 1
        }
        return false
    }
    
    private func isCouponSection(_ section: Int) -> Bool {
        if event.coupons.count > 0 {
            return section == 2
        }
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 1
        if event.people.count > 0 {
            count += 1
        }
        if event.coupons.count > 0 {
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isResumeSection(section) {
            return 1
        }
        if isPeopleSection(section) {
            return event.people.count
        }
        if isCouponSection(section) {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isResumeSection(section) {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 54))
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width - 16, height: 54))
        label.textAlignment = .left
        label.font = WeFont.robotoBold(size: 20)
        label.textColor = Palette.cardTitleText()
        
        if isPeopleSection(section) {
            label.text = R.string.we.sectionPeople()
        }
        
        if isCouponSection(section) {
            label.text = R.string.we.sectionCoupons()
        }
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCouponSection(indexPath.section) {
            return 82.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isResumeSection(indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: EventResumeCell.reusableIdentifier) as! EventResumeCell
            cell.delegate = self
            cell.event = event
            return cell
        }
        if isPeopleSection(indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reusableIdentifier) as! PersonCell
            let person = event.people[indexPath.row]
            cell.person = person
            return cell
        }
        if isCouponSection(indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: CouponTableCell.reusableIdentifier) as! CouponTableCell
            cell.coupons = event.coupons
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isPeopleSection(section) || isCouponSection(section) {
            return 54.0
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
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
