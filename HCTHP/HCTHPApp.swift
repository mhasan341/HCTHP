//
//  HCTHPApp.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-12.
//

import SwiftUI

@main
struct HCTHPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            #warning("Change here")
            //ContentView()
            MedicationHome()
                .environmentObject(AuthVM())
        }
    }
}
