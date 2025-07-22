import Foundation
import SwiftUI

struct Airport: Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let city: String?
    let country: String?
}

struct AirportResponse: Decodable {
    let metaAirports: [String: AirportDetails]
}

struct AirportDetails: Decodable {
    let name: String?
    let city: String?
    let country: String?
}
