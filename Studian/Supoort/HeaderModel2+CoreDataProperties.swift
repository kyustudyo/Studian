//
//  HeaderModel2+CoreDataProperties.swift
//  
//
//  Created by 이한규 on 2022/01/28.
//
//

import Foundation
import CoreData


extension HeaderModel2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeaderModel2> {
        return NSFetchRequest<HeaderModel2>(entityName: "HeaderModel2")
    }

    @NSManaged public var textViewText: String?
    @NSManaged public var textFieldText2: String?
    @NSManaged public var textFieldText1: String?
    @NSManaged public var headerImage: Data?

}
