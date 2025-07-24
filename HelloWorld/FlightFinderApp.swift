//
//  FlightFinderApp.swift
//  FlightFinder
//
//  Created by Bryann Bueno on 20/07/25.
//

import SwiftUI

@main
struct FlightFinderApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FlightDealsView()
            }
            .accentColor(.purple)
        }
    }
}
