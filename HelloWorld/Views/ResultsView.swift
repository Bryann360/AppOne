import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: FlightSearchViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.results) { flight in
                NavigationLink(destination: FlightDetailView(flight: flight)) {
                    FlightRowView(flight: flight)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Voos Encontrados")
        }
    }
}

#Preview {
    ResultsView(viewModel: FlightSearchViewModel())
}
