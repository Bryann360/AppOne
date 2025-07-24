import SwiftUI

struct FlightDealsView: View {
    let flights: [Flight]

    var body: some View {
        List(flights) { flight in
            FlightRowView(flight: flight)
        }
        .navigationTitle("Flight Deals")
    }
}

#Preview {
    NavigationStack {
        FlightDealsView(flights: [])
    }
}
