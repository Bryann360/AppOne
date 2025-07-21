import SwiftUI

struct FlightRowView: View {
    let flight: Flight

    var body: some View {
        HStack {
            Image(systemName: flight.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.accentColor)

            VStack(alignment: .leading) {
                Text(flight.airline)
                    .font(.headline)
                Text("\(flight.departure) - \(flight.arrival)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(flight.price)
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FlightRowView(flight: Flight(airline: "Swift Air", departure: "08:00", arrival: "10:00", price: "$199", icon: "airplane"))
}
