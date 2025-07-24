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
            for code in codes {
                let info = decoded.airports?[code]
                let resolvedName = decoded.airportNames?[code] ?? info?.name ?? code
                list.append(
                    Airport(code: code,
                            name: resolvedName,
                            city: info?.city,
                            country: info?.country)
                )
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

    private let token = "pro_2jYo3iV7cYMPIExYfkMhdWbcn2Y"

    struct SearchResponse: Decodable {
        let data: [SearchItem]
    }

    struct SearchItem: Decodable {
        let ID: String
        let Date: String
        let Route: SearchRoute
        let YAirlines: String?
        let JAirlines: String?
        let YMileageCostRaw: Int?
        let JMileageCostRaw: Int?
        let YTotalTaxesRaw: Int?
        let JTotalTaxesRaw: Int?
    }

    struct SearchRoute: Decodable {
        let OriginAirport: String
        let DestinationAirport: String
    }

    func search() async {
        guard let url = URL(string: "https://seats.aero/partnerapi/search?take=500&include_trips=false&only_direct_flights=false&include_filtered=false") else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Partner-Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)

            let filtered = decoded.data.filter { item in
                let originMatch = origin.isEmpty || item.Route.OriginAirport.localizedCaseInsensitiveCompare(origin) == .orderedSame
                let destMatch = destination.isEmpty || item.Route.DestinationAirport.localizedCaseInsensitiveCompare(destination) == .orderedSame
                return originMatch && destMatch
            }

            results = filtered.map { item in
                let airline = (item.JAirlines?.isEmpty == false ? item.JAirlines : item.YAirlines) ?? ""
                let miles = item.JMileageCostRaw ?? item.YMileageCostRaw ?? 0
                let taxes = item.JTotalTaxesRaw ?? item.YTotalTaxesRaw ?? 0
                return Flight(
                    airline: airline,
                    departure: item.Route.OriginAirport,
                    arrival: item.Route.DestinationAirport,
                    price: "\(miles) mi + $\(taxes)",
                    icon: "airplane"
                )
            }
        } catch {
            print("Failed to search flights: \(error)")
            results = []
        }
    }
}
