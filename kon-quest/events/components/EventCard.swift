import SwiftUI

struct EventCard: View {
    let event: Event

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Event image (if available)
            if let imageUrl = event.imageUrl, let url = URL(string: API_URL + imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
            } else {
                // Placeholder image
                Image(systemName: "photo")
                    .resizable()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack(spacing: 10) {
                    Image(systemName: "calendar")
                    Text(event.date)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                HStack(spacing: 10) {
                    Image(systemName: "mappin.and.ellipse")
                    Text(event.location)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Text(event.description)
                    .font(.body)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(16)
    }
}

#Preview {
    EventCard(event: .mock2)
        .padding()
}
