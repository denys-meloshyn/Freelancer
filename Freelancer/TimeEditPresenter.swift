//
//  TimeEditPresenter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

enum TimerState {
    case none
    case run
    case pause
    case increaseManually
    case decreaseManually
}

protocol TimeEditPresenterDelegate: class {
    func showSaveButton()
    func showApplyButton()
    func showTimeReport(_ time: String?)
    func updateDatePickerValue(_ date: Date)
    func showTimeReportTitle(_ title: String?)
    func updateResumePauseButtonTitle(_ title: String)
    func updateDatepickerWithVisibility(_ visible: Bool)
}

class TimeEditPresenter: NSObject, LifeCycleStateProtocol {
    private var timer: Timer?
    private var datePickerValue: Date?
    private var timerState = TimerState.pause

    weak var viewController: UIViewController?
    weak var interaction: TimeEditInteraction?
    weak var delegate: TimeEditPresenterDelegate?

    func configure(with interaction: TimeEditInteraction?) {
        self.interaction = interaction
    }

    func initialConfiguration() {
        self.interaction?.initialConfiguration()

        // Configure init view state
        self.delegate?.showSaveButton()
        self.delegate?.showTimeReportTitle(self.interaction?.currentTime?.title)
        self.updateTime()
        self.updateRunButtonTitle()
    }
    
    func titleValueEdited(sender: UITextField?) {
        self.interaction?.currentTime?.title = sender?.text
    }

    func saveChanges() {
        self.stopTimer()
        self.interaction?.saveTimeEditChanges()
    }

    func runStopTimer() {
        switch self.timerState {
        case .run:
            self.stopTimer()
            
        case .pause:
            self.runTimer()
            
        default:
            break
        }
        
        self.updateRunButtonTitle()
    }
    
    func increaseButtonHandler() {
        // Stop timer and show date picker
        self.stopTimer()

        self.timerState = .increaseManually
        self.resetAndPresentDatePicker()
    }
    
    func decreaseButtonHandler() {
        // Stop timer and show date picker
        self.stopTimer()

        self.timerState = .decreaseManually
        self.resetAndPresentDatePicker()
    }

    func applyManualChanges() {
        guard let datePickerValue = self.datePickerValue else {
            self.timerState = .pause
            return
        }

        // Apply calculation
        switch self.timerState {
        case .decreaseManually:
            self.interaction?.subtractDate(datePickerValue)

        case .increaseManually:
            self.interaction?.addDate(datePickerValue)
        default:
            break
        }

        // Hide date picker
        self.hideDatePicker()

        // Update timer label
        self.updateRunButtonTitle()
        self.updateTime()
    }

    func hideDatePicker() {
        self.timerState = .pause
        self.delegate?.updateDatepickerWithVisibility(false)
        self.delegate?.showSaveButton()
    }

    func datePickerValueChanged(sender: UIDatePicker) {
        self.datePickerValue = sender.date
    }

    // MARK: - LifeCycleStateProtocol methods

    func viewWillAppear(_ animated: Bool) {

    }

    func viewDidAppear(_ animated: Bool) {

    }

    func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }

    func viewDidDisappear(_ animated: Bool) {

    }

    // MARK: - Private methods

    private func resetAndPresentDatePicker() {
        self.showDatePicker(with: 0, minute: 1, second: 0)
        self.delegate?.updateDatepickerWithVisibility(true)
        self.delegate?.showApplyButton()
    }

    private func showDatePicker(with hour: Int, minute minutes: Int, second seconds: Int) {
        guard let date = self.interaction?.generateDate(with: hour, minute: minutes, second: seconds) else {
            return
        }

        self.datePickerValue = date
        self.delegate?.updateDatePickerValue(date)
    }

    private func stopTimer() {
        // Stop timer and update UI
        self.timerState = .pause
        self.timer?.invalidate()
        self.updateRunButtonTitle()
    }
    
    private func runTimer() {
        // Activate timer and update UI
        self.timerState = .run
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] timer in
            self?.interaction?.increaseTimeOneSecond()
            self?.updateTime()
        })
    }
    
    private func updateTime() {
        self.delegate?.showTimeReport(Constants.formatLoggedTime(dateComponents: self.interaction?.currentTime?.spent()))
    }
    
    private func updateRunButtonTitle() {
        // Configure timer button title
        switch self.timerState {
        case .run:
            self.delegate?.updateResumePauseButtonTitle("Pause")
            
        case .pause:
            if let dateComponents = self.interaction?.currentTime?.spent(), dateComponents.second == 0 && dateComponents.minute == 0 && dateComponents.hour == 0 {
                self.delegate?.updateResumePauseButtonTitle("Start")
            } else {
                self.delegate?.updateResumePauseButtonTitle("Resume")
            }
        default:
            break
        }
    }
}
