import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FlightSearchViewModel()
    @State private var showDeals = false
    @State private var animateButton = false
    @FocusState private var focusedField: Field?

    private enum Field {
        case origin
        case destination
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "airplane.departure")
                        .foregroundColor(.accentColor)
                    TextField("Origem", text: $viewModel.origin)
                        .focused($focusedField, equals: .origin)
                        .textFieldStyle(.plain)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.accentColor, lineWidth: 2))
                .padding(.horizontal)
                if focusedField == .origin {
                    suggestionView(for: viewModel.filteredOrigins) { code in
                        viewModel.origin = code
                        focusedField = nil
                    }
                }

                HStack {
                    Image(systemName: "airplane.arrival")
                        .foregroundColor(.accentColor)
                    TextField("Destino", text: $viewModel.destination)
                        .focused($focusedField, equals: .destination)
                        .textFieldStyle(.plain)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.accentColor, lineWidth: 2))
                .padding(.horizontal)
                if focusedField == .destination {
                    suggestionView(for: viewModel.filteredDestinations) { code in
                        viewModel.destination = code
                        focusedField = nil
                    }
                }

                DatePicker("Data", selection: $viewModel.date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .tint(.accentColor)

                Button(action: {
                    Task {
                        await viewModel.search()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                            animateButton = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            animateButton = false
                            showDeals = true
                        }
                    }
                }) {
                    Text("Buscar Voos")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .scaleEffect(animateButton ? 1.1 : 1.0)
                        .shadow(color: .accentColor.opacity(0.4), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                }
                .padding(.top, 8)

                Spacer()
            }
            .navigationTitle("FlightFinder")
            .sheet(isPresented: $showDeals) {
                NavigationStack {
                    FlightDealsView(flights: viewModel.results)
                }
            }
        }
        .task {
            await viewModel.loadAirports()
        }
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
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
