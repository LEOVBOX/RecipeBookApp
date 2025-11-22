//
//  Ingredient+CoreDataProperties.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 21.11.2025.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var title: String?
    @NSManaged public var measure: String?
    @NSManaged public var recipe: Recipe?

}

extension Ingredient : Identifiable {

}
