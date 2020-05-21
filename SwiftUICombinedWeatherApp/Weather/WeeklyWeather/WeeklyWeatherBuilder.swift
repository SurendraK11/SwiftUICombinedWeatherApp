import SwiftUI

enum WeeklyWeatherBuilder {
  static func makeCurrentWeatherView(withCity city: String, weatherFetcher: WeatherFetchable) -> some View {
    let viewModel = CurrentWeatherViewModel(withWeatherFetcher: weatherFetcher, city: city)
    return CurrentWeatherView(withViewModel: viewModel)
  }
}
