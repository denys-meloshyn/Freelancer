//
//  TimeEditView.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

class TimeEditView: NSObject, TimeEditPresenterDelegate, LifeCycleStateProtocol {
    @IBOutlet private var timeLabel: UILabel?
    @IBOutlet private var runButton: UIButton?
    @IBOutlet private var decreseButton: UIButton?
    @IBOutlet private var increaseButton: UIButton?
    @IBOutlet private var datePicker: UIDatePicker?
    @IBOutlet private var titleTextField: UITextField?
    @IBOutlet private var hideDatePickerButton: UIButton?
    @IBOutlet private var datePickerContainerView: UIView?
    @IBOutlet private weak var viewController: UIViewController?

    var presenter: TimeEditPresenter
    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?

    override init() {
        self.presenter = TimeEditPresenter()

        super.init()
    }

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
        self.runButton?.addTarget(self.presenter, action: #selector(TimeEditPresenter.runStopTimer), for: .touchUpInside)
        self.titleTextField?.addTarget(self.presenter, action: #selector(TimeEditPresenter.titleValueEdited(sender:)), for: .editingChanged)
        self.increaseButton?.addTarget(self.presenter, action: #selector(TimeEditPresenter.increaseButtonHandler), for: .touchUpInside)
        self.decreseButton?.addTarget(self.presenter, action: #selector(TimeEditPresenter.decreaseButtonHandler), for: .touchUpInside)
        self.hideDatePickerButton?.addTarget(self.presenter, action: #selector(TimeEditPresenter.hideDatePicker), for: .touchUpInside)
        self.datePicker?.addTarget(self.presenter, action: #selector(TimeEditPresenter.datePickerValueChanged(sender:)), for: .valueChanged)
        
        self.datePicker?.backgroundColor = UIColor.white
    }

    // MARK: - LifeCycleStateProtocol methods

    func viewWillAppear(_ animated: Bool) {

    }

    func viewDidAppear(_ animated: Bool) {

    }

    func viewWillDisappear(_ animated: Bool) {
        self.presenter.viewWillDisappear(animated)
    }

    func viewDidDisappear(_ animated: Bool) {

    }

    // MARK: - TimeEditPresenterDelegate methods

    func updateDatePickerValue(_ date: Date) {
        self.datePicker?.setDate(date, animated: true)
    }

    func showSaveButton() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self.presenter, action: #selector(TimeEditPresenter.saveChanges))
        self.viewController?.navigationItem.rightBarButtonItem = barButtonItem
    }

    func showApplyButton() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self.presenter, action: #selector(TimeEditPresenter.applyManualChanges))
        self.viewController?.navigationItem.rightBarButtonItem = barButtonItem
    }
    
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
