import Foundation
import SwiftUI

struct Airport: Identifiable {
    let id = UUID()
    let code: String
    let name: String
    let city: String?
    let country: String?
}

struct RefDataResponse: Decodable {
    let airports: [String: AirportDetails]?
    let metaAirports: [String: [String]]
}

struct AirportDetails: Decodable {
    let name: String?
    let city: String?
    let country: String?
}
