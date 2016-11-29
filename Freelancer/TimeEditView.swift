//
//  TimeEditView.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimeEditView: NSObject, TimeEditPresenterDelegate {
    @IBOutlet private var timeLabel: UILabel?
    @IBOutlet private var runButton: UIButton?
    @IBOutlet private var decreseButton: UIButton?
    @IBOutlet private var increaseButton: UIButton?
    @IBOutlet private var datePicker: UIDatePicker?
    @IBOutlet private var titleTextField: UITextField?
    @IBOutlet private var datePickerContainerView: UIView?
    @IBOutlet private weak var viewController: UIViewController?

    let presenter = TimeEditPresenter()
    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?

    func initialConfiguration() {
        self.configureUserInterface()

        self.presenter.currentTimeID = self.currentTimeID
        self.presenter.currentProjectID = self.currentProjectID
        self.presenter.delegate = self
        self.presenter.viewController = self.viewController
        self.presenter.initialConfiguration()
    }

    // MARK: - Private methods

    private func configureUserInterface() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self.presenter, action: #selector(TimeEditPresenter.saveChanges))
        self.viewController?.navigationItem.rightBarButtonItem = addBarButtonItem
        
        self.runButton?.addTarget(self.presenter, action: #selector(TimeEditPresenter.runStopTimer), for: .touchUpInside)
        self.titleTextField?.addTarget(self.presenter, action: #selector(TimeEditPresenter.titleValueEdited(sender:)), for: .editingChanged)
        self.increaseButton?.addTarget(self.presenter, action: #selector(TimeEditPresenter.increaseButtonHandler), for: .touchUpInside)
        self.decreseButton?.addTarget(self.presenter, action: #selector(TimeEditPresenter.decreaseButtonHandler), for: .touchUpInside)
        
        self.datePicker?.backgroundColor = UIColor.white
    }
    
    // MARK: - TimeEditPresenterDelegate methods
    
    func updateDatepickerWithVisibility(_ visible: Bool) {
        self.datePickerContainerView?.isHidden = !visible
    }
    
    func showTimeReportTitle(_ title: String?) {
        self.titleTextField?.text = title
    }
    
    func showTimeReport(_ time: String?) {
        self.timeLabel?.text = time
    }
    
    func updateResumePauseButtonTitle(_ title: String) {
        self.runButton?.setTitle(title, for: .normal)
    }
}
