//
//  ReminderView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-19.
//

import SwiftUI
import UIKit
import EventKit
import EventKitUI

struct ReminderView: UIViewControllerRepresentable {

    var store: EKEventStore

    func makeUIViewController(context: Context) -> some UIViewController {
        
        let vc = EKEventEditViewController()
        vc.eventStore = store

        let event = EKEvent(eventStore: store)
        event.calendar = EKCalendar(for: .reminder, eventStore: store)
        event.title = "It's time to take medication"

        vc.event = event

        vc.editViewDelegate = context.coordinator
        
        return vc
    }

    func makeCoordinator() -> EventCoordinator {
        EventCoordinator(parent: self)
    }

    // we are not using advance reminder/event here, so not doing it
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }


}


/// to handle the delegates
class EventCoordinator: NSObject, EKEventEditViewDelegate {
    
    var parent: ReminderView

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {

        controller.dismiss(animated: true)
    }

    init(parent: ReminderView) {
        self.parent = parent
    }


}
