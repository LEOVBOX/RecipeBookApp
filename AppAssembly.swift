//
//  AppAssembly.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 18.11.2025.
//

import UIKit

class AppAssembly {
    static func makeStorageManager() -> StorageManager {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Fail to get AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        return StorageManager(mainContext: context)
    }
    
    static func getBackgroundImgae() -> UIImage? {
        UIImage(named: "Background")
    }
}
