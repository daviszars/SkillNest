//
//  AppDelegate.swift
//  SkillNest
//
//  Created by Davis Zarins on 23/05/2024.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configureRealm()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1, // Increment this number whenever you make schema changes
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Perform any migration logic here
                    // Example: migration.renameProperty(onType: MyRealmObject.className(), from: "oldPropertyName", to: "newPropertyName")
                }
            })
        
        Realm.Configuration.defaultConfiguration = config
        
        // Try opening the Realm file to apply the migration
        do {
            _ = try Realm()
        } catch let error as NSError {
            fatalError("Realm configuration failed: \(error.localizedDescription)")
        }
    }

}

