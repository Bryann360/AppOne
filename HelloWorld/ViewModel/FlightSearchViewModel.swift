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
        var components = URLComponents(string: "https://seats.aero/partnerapi/search")
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "take", value: "500"),
            URLQueryItem(name: "include_trips", value: "false"),
            URLQueryItem(name: "only_direct_flights", value: "false"),
            URLQueryItem(name: "include_filtered", value: "false")
        ]
        if !origin.isEmpty {
            queryItems.append(URLQueryItem(name: "origin", value: origin))
        }
        if !destination.isEmpty {
            queryItems.append(URLQueryItem(name: "destination", value: destination))
        }
        components?.queryItems = queryItems

        guard let url = components?.url else { return }

        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Partner-Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                let text = String(data: data, encoding: .utf8) ?? "<no body>"
                print("Unexpected response: \(response)\n\(text)")
                results = []
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)

                results = decoded.data.map { item in
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
                let text = String(data: data, encoding: .utf8) ?? "<unreadable>"
                print("Decoding error: \(error)\nRaw response: \n\(text)")
                results = []
            }
        } catch {
            print("Failed to search flights: \(error)")
            results = []
        }
    }
}
