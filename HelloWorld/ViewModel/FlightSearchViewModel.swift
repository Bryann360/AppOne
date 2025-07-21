import Foundation
import SwiftUI

@MainActor
class FlightSearchViewModel: ObservableObject {
    @Published var origin: String = ""
    @Published var destination: String = ""
    @Published var date: Date = Date()
    @Published var results: [Flight] = []

    func search() {
        results = mockFlights()
    }

    private func mockFlights() -> [Flight] {
        [
            Flight(airline: "Swift Air", departure: "08:00", arrival: "10:00", price: "$199", icon: "airplane"),
            Flight(airline: "Code Airlines", departure: "12:00", arrival: "14:30", price: "$249", icon: "airplane.circle"),
            Flight(airline: "Test Flights", departure: "18:00", arrival: "20:15", price: "$179", icon: "airplane"),
        ]
    }
}
