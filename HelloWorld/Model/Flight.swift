import Foundation
import SwiftUI

struct Flight: Identifiable {
    let id = UUID()
    let airline: String
    let departure: String
    let arrival: String
    let price: String
    let icon: String
}
