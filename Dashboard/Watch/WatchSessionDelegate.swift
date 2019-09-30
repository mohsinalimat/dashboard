//
//  WatchSessionDelegate.swift
//  Dashboard
//
//  Created by Patrick Gatewood on 9/30/19.
//  Copyright © 2019 Patrick Gatewood. All rights reserved.
//

import WatchConnectivity
import CoreData

class WatchHandler: ObservableObject {
    @WatchSession(delegate: WatchSessionDelegate()) var watchSession: WCSession?
    
    private let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        observeCoreDataChanges()
    }
    
    private func observeCoreDataChanges() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: moc)
    }
    
    func replyHandler(reply: [String : Any]) {
        print("the watch received the phone's message")
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        // It's probaby better to exclusively look for inserts, updates, and deletes from within this notification, but this will suffice for innovation day.
        PersistenceClient.shared.getStoredServices { [weak self] result in
            guard let self = self else { return }
            print("moc object contexts changed")
            self.watchSession?.sendMessage(["message":"My Messege"], replyHandler: self.replyHandler, errorHandler: nil)
        }
    }
}

class WatchSessionDelegate: NSObject, WCSessionDelegate {
    
    
    // MARK - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("watch session activation completed")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("watch session inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("watch session deactivated")
    }
}
