import SwiftUI

struct FlightDealsView: View {
    struct AirlineDeal: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        let points: Int
        let price: String
    }

    struct CreditCardDeal: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        let points: Int
    }

    @State private var selectedSegment: Segment = .outbound

    enum Segment: String, CaseIterable, Identifiable {
        case outbound = "VOOS DE IDA"
        case inbound = "VOOS DE VOLTA"
        var id: String { rawValue }
    }

    private let airlines: [AirlineDeal] = [
        AirlineDeal(name: "Gol", icon: "airplane", points: 7500, price: "R$320"),
        AirlineDeal(name: "Latam", icon: "airplane.circle", points: 8200, price: "R$350"),
        AirlineDeal(name: "Azul", icon: "airplane", points: 9000, price: "R$400")
    ]

    private let creditCards: [CreditCardDeal] = [
        CreditCardDeal(name: "iupp", icon: "creditcard", points: 9500),
        CreditCardDeal(name: "livelo", icon: "creditcard", points: 9800),
        CreditCardDeal(name: "Esfera", icon: "creditcard", points: 10200)
    ]

    private let dates = ["30 SET", "1 OUT", "2 OUT", "3 OUT", "4 OUT"]

    private let flights: [Flight] = [
        Flight(airline: "Gol", departure: "06:00", arrival: "07:00", price: "7.500 pts + R$320", icon: "airplane"),
        Flight(airline: "Latam", departure: "08:00", arrival: "09:10", price: "8.200 pts + R$350", icon: "airplane.circle"),
        Flight(airline: "Azul", departure: "10:00", arrival: "11:30", price: "9.000 pts + R$400", icon: "airplane")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header

                Button(action: {}) {
                    Text("Menores preços em datas próximas")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                sectionAirlines
                section123Milhas
                sectionCreditCards

                Picker("", selection: $selectedSegment) {
                    ForEach(Segment.allCases) { segment in
                        Text(segment.rawValue).tag(segment)
                    }
                }
                .pickerStyle(.segmented)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(dates, id: \.self) { date in
                            Text(date)
                                .padding(6)
                                .background(Capsule().fill(Color.gray.opacity(0.2)))
                        }
                    }
                }

                TextField("Filtrar resultados", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)

                VStack(spacing: 12) {
                    ForEach(flights) { flight in
                        FlightRowView(flight: flight)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Ofertas")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("SAO → RIO")
                .font(.title2)
                .bold()
            Text("Sexta 30 SET - Sexta 14 OUT")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var sectionAirlines: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Companhias")
                .font(.headline)
            ForEach(airlines) { deal in
                HStack {
                    Image(systemName: deal.icon)
                    Text(deal.name)
                    Spacer()
                    Text("\(deal.points) pts + \(deal.price)")
                }
                .padding(6)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
            }
        }
    }

    private var section123Milhas: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("123milhas")
                .font(.headline)
            HStack {
                Image(systemName: "tag")
                Text("R$ 300")
                Spacer()
            }
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
        }
    }

    private var sectionCreditCards: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cartão de crédito")
                .font(.headline)
            ForEach(creditCards) { deal in
                HStack {
                    Image(systemName: deal.icon)
                    Text(deal.name)
                    Spacer()
                    Text("\(deal.points) pts")
                }
                .padding(6)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
            }
        }
    }
}

#Preview {
    NavigationStack {
        FlightDealsView()
    }
}
