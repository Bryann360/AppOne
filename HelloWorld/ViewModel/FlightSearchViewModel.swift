import Foundation
import SwiftUI

@MainActor
class FlightSearchViewModel: ObservableObject {
    @Published var origin: String = ""
    @Published var destination: String = ""
    @Published var date: Date = Date()
    @Published var results: [Flight] = []
    @Published var airports: [Airport] = []

    func loadAirports() async {
        guard let url = URL(string: "https://seats.aero/_api/vuerefdata") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(RefDataResponse.self, from: data)

            var codes = Set<String>()
            for group in decoded.metaAirports.values {
                codes.formUnion(group)
            }

            var list: [Airport] = []
            if let details = decoded.airports {
                for code in codes {
                    let info = details[code]
                    list.append(
                        Airport(code: code,
                                name: info?.name ?? code,
                                city: info?.city,
                                country: info?.country)
                    )
                }
            } else {
                for code in codes {
                    list.append(Airport(code: code, name: code, city: nil, country: nil))
                }
            }

            airports = list.sorted { $0.code < $1.code }
        } catch {
            print("Failed to fetch airports: \(error)")
        }
    }

    var filteredOrigins: [Airport] {
        if origin.isEmpty { return [] }
        return airports.filter {
            $0.code.localizedCaseInsensitiveContains(origin) ||
            $0.name.localizedCaseInsensitiveContains(origin)
        }.prefix(5).map { $0 }
    }

    var filteredDestinations: [Airport] {
        if destination.isEmpty { return [] }
        return airports.filter {
            $0.code.localizedCaseInsensitiveContains(destination) ||
            $0.name.localizedCaseInsensitiveContains(destination)
        }.prefix(5).map { $0 }
    }

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
