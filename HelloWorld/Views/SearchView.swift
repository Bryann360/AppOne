import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FlightSearchViewModel()
    @State private var showResults = false
    @State private var animateButton = false
    @FocusState private var focusedField: Field?

    private enum Field {
        case origin
        case destination
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                header

                SearchField(icon: "airplane.departure",
                            placeholder: "Origem",
                            text: $viewModel.origin,
                            focusedField: $focusedField,
                            field: .origin)
                if focusedField == .origin {
                    suggestionView(for: viewModel.filteredOrigins) { code in
                        viewModel.origin = code
                        focusedField = nil
                    }
                }

                SearchField(icon: "airplane.arrival",
                            placeholder: "Destino",
                            text: $viewModel.destination,
                            focusedField: $focusedField,
                            field: .destination)
                if focusedField == .destination {
                    suggestionView(for: viewModel.filteredDestinations) { code in
                        viewModel.destination = code
                        focusedField = nil
                    }
                }

                DatePicker("Data", selection: $viewModel.date, displayedComponents: .date)
                    .font(.system(.subheadline, design: .rounded))
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .tint(.teal)

                PrimaryActionButton(title: "Buscar Voos", animate: animateButton) {
                    viewModel.search()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                        animateButton = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateButton = false
                        showResults = true
                    }
                }
                .padding(.top)

                Spacer()
            }
            .sheet(isPresented: $showResults) {
                ResultsView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.loadAirports()
        }
        .background(
            LinearGradient(colors: [Color.teal.opacity(0.15), Color.indigo.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }

    private var header: some View {
        Text("Breton")
            .font(.largeTitle.bold())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .padding(.horizontal)
            .background(Color.teal)
            .ignoresSafeArea(edges: .top)
    }

    private func suggestionView(for airports: [Airport], selection: @escaping (String) -> Void) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(airports) { airport in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(airport.code)
                                .font(.subheadline)
                                .bold()
                            Text(airport.name)
                                .font(.caption)
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(6)
                    .onTapGesture {
                        selection(airport.code)
                    }
                    Divider()
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 120)
    }

}

#Preview {
    SearchView()
}
