import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FlightSearchViewModel()
    @State private var showResults = false
    @State private var animateButton = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "airplane.departure")
                        .foregroundStyle(.accent)
                    TextField("Origem", text: $viewModel.origin)
                        .textFieldStyle(.plain)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.accentColor, lineWidth: 2))
                .padding(.horizontal)

                HStack {
                    Image(systemName: "airplane.arrival")
                        .foregroundStyle(.accent)
                    TextField("Destino", text: $viewModel.destination)
                        .textFieldStyle(.plain)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.accentColor, lineWidth: 2))
                .padding(.horizontal)

                DatePicker("Data", selection: $viewModel.date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                    .tint(.accentColor)

                Button(action: {
                    viewModel.search()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                        animateButton = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateButton = false
                        showResults = true
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
                .padding(.top)

                Spacer()
            }
            .navigationTitle("FlightFinder")
            .sheet(isPresented: $showResults) {
                ResultsView(viewModel: viewModel)
            }
        }
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    SearchView()
}
