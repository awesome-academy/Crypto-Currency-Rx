//
//  FavoriteCoin+CoreDataProperties.swift
//  
//
//  Created by namtrinh on 31/08/2021.
//
//

import Foundation
import CoreData

extension FavoriteCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCoin> {
        return NSFetchRequest<FavoriteCoin>(entityName: "FavoriteCoin")
    }

    @NSManaged public var iconUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var uuid: String?
}
