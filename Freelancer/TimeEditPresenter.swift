//
//  TimeEditPresenter.swift
//  Freelancer
//
//  Created by Denys Meloshyn on 29/11/2016.
//  Copyright © 2016 Denys Meloshyn. All rights reserved.
//

import UIKit
import CoreData

protocol TimeEditPresenterDelegate: class {
    func showTimeReport(_ time: String?)
    func showTimeReportTitle(_ title: String?)
    func updateResumePauseButtonTitle(_ title: String)
}

class TimeEditPresenter: NSObject {
    private var isTimerRun = false
    
    let interaction = TimeEditInteraction()
    var currentTimeID: NSManagedObjectID?
    var currentProjectID: NSManagedObjectID?
    weak var viewController: UIViewController?
    weak var delegate: TimeEditPresenterDelegate?

    func initialConfiguration() {
        self.interaction.currentTimeID = self.currentTimeID
        self.interaction.currentProjectID = self.currentProjectID
        self.interaction.initialConfiguration()
        
        self.delegate?.showTimeReportTitle(self.interaction.currentTime?.title)
        self.updateTime()
        self.updateRunButtonTitle()
    }
    
    func titleValueEdited(sender: UITextField?) {
        self.interaction.currentTime?.title = sender?.text
    }

    func saveChanges() {
        self.interaction.saveTimeEditChanges()
    }
    
    func runStopTimer() {
        self.isTimerRun = !self.isTimerRun
        self.updateRunButtonTitle()
        
        if self.isTimerRun {
            self.runTimer()
        }
    }
    
    // MARK: - Private methods
    
    private func runTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {timer in
            self.interaction.increaseTimeOneSecond()
            self.updateTime()
            
            if self.isTimerRun {
                self.runTimer()
            }
        })
    }
    
    private func updateTime() {
        var time = ""
        let calendar = Calendar.current
        
        if let dateComponents = self.interaction.currentTime?.spent(), let date = calendar.date(from: dateComponents) {
            let formatter = Constants.defaultDateFormatter()
            time = formatter.string(from: date)
        }
        
        self.delegate?.showTimeReport(time)
    }
    
    private func updateRunButtonTitle() {
        if self.isTimerRun {
            self.delegate?.updateResumePauseButtonTitle("Pause")
        } else {
            if let dateComponents = self.interaction.currentTime?.spent(), dateComponents.second == 0 && dateComponents.minute == 0 && dateComponents.hour == 0 {
                self.delegate?.updateResumePauseButtonTitle("Start")
                return
            }
            
            self.delegate?.updateResumePauseButtonTitle("Resume")
        }
    }
}
