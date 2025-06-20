import SwiftUI

struct WeatherWidget: View {
    let weather: Weather?

    var body: some View {
        if let weather = weather {
            HStack(spacing: 8) {
                Image(systemName: weatherIcon(for: weather.current.weathercode))
                    .font(.title2)
                    .frame(width: 30)
                Text("\(Int(weather.current.temperature_2m.rounded()))°C")
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 5)
        }
    }

    private func weatherIcon(for code: Int) -> String {
        switch code {
        case 0: // Clear sky
            return "sun.max.fill"
        case 1, 2, 3: // Mainly clear, partly cloudy, overcast
            return "cloud.sun.fill"
        case 45, 48: // Fog
            return "cloud.fog.fill"
        case 51, 53, 55, 56, 57: // Drizzle
            return "cloud.drizzle.fill"
        case 61, 63, 65, 66, 67: // Rain
            return "cloud.rain.fill"
        case 71, 73, 75, 77: // Snow
            return "cloud.snow.fill"
        case 80, 81, 82: // Rain showers
            return "cloud.heavyrain.fill"
        case 85, 86: // Snow showers
            return "cloud.snow.fill"
        case 95, 96, 99: // Thunderstorm
            return "cloud.bolt.fill"
        default:
            return "questionmark.circle"
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        WeatherWidget(weather: Event.mock.weather)
    }
} 
