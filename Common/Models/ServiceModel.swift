//
//  ServiceModel.swift
//  Dashboard
//
//  Created by Patrick Gatewood on 2/20/19.
//  Copyright © 2019 Patrick Gatewood. All rights reserved.
//

import CoreData
import UIKit
import Combine

@objc(ServiceModel)
public class ServiceModel: NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
    
    @NSManaged var index: Int64
    @NSManaged var name: String
    @NSManaged var url: String
    @NSManaged var lastOnlineDate: Date
    
    /// Determine if the service was online in the last 5 minutes
    var wasOnlineRecently: Bool {
        return Date().timeIntervalSince(lastOnlineDate) <= 60 * 5
    }

    var image: UIImage {
        get {
            return PersistenceClient.fetchImage(named: name) ?? UIImage(named: "missing-image")!
        }
    }
    
    func populate(index: Int64, name: String, url: String, lastOnlineDate: Date) {
        self.index = index
        self.name = name
        self.url = url
        self.lastOnlineDate = lastOnlineDate
    }
    
    // MARK: - Combine
    var didChange = PassthroughSubject<Void, Never>()
    
    public override func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        didChange.send()
    }
}
