import SwiftUI

struct FlightDetailView: View {
    let flight: Flight

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: flight.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(
                    LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom)
                )

            Text(flight.airline)
                .font(.largeTitle)
                .padding(.top)

            Text("Saída: \(flight.departure)")
            Text("Chegada: \(flight.arrival)")
            Text("Preço: \(flight.price)")
                .font(.title2)
                .padding(.top)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [Color.white, Color.accentColor.opacity(0.1)], startPoint: .top, endPoint: .bottom))
        )
        .padding()
        .navigationTitle("Detalhes")
    }
}

#Preview {
    FlightDetailView(flight: Flight(airline: "Swift Air", departure: "08:00", arrival: "10:00", price: "$199", icon: "airplane"))
}
