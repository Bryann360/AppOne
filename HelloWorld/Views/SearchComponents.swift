import SwiftUI

struct SearchField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var focusedField: FocusState<SearchView.Field?>.Binding
    let field: SearchView.Field

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.teal)
            TextField(placeholder, text: $text)
                .focused(focusedField, equals: field)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.teal, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct PrimaryActionButton: View {
    let title: String
    var animate: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.teal)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .scaleEffect(animate ? 1.1 : 1.0)
                .shadow(color: .teal.opacity(0.4), radius: 5, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
}
