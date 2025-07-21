import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FlightSearchViewModel()
    @State private var showResults = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Origem", text: $viewModel.origin)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                TextField("Destino", text: $viewModel.destination)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                DatePicker("Data", selection: $viewModel.date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .tint(.accentColor)

                Button(action: {
                    viewModel.search()
                    showResults = true
                }) {
                    Text("Buscar Voos")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                }
                .padding(.top)

                Spacer()
            }
            .navigationTitle("FlightFinder")
            .sheet(isPresented: $showResults) {
                ResultsView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    SearchView()
}
