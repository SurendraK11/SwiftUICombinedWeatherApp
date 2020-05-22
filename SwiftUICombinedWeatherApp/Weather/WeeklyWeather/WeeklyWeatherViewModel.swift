
/// Surendra
///
///

import Foundation
import Combine
import SwiftUI

class WeeklyWeatherViewModel: ObservableObject, Identifiable {
  
  @Published var city = ""
  @Published var dataSource = [DailyWeatherRowViewModel]()
  
  private var disposables = Set<AnyCancellable>()
  
  private let weatherFetcher: WeatherFetcher
  
  init(withwWatherFetcher weatherFetcher: WeatherFetcher, scheduler: DispatchQueue = DispatchQueue(label: "WeatherViewModel")) {
    self.weatherFetcher = weatherFetcher
    
    $city
      .dropFirst(1)
      .debounce(for: .seconds(0.5), scheduler: scheduler)
      .sink(receiveValue: fetchWeather(forCity:))
      .store(in: &disposables)

  }
  
  func fetchWeather(forCity city: String) {
    weatherFetcher.weeklyWeatherForecast(forCity: city)
      .map { response in
        response.list.map (DailyWeatherRowViewModel.init)
      }
      .map(Array.removeDuplicates)
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { [weak self] (value) in
      guard let self = self else { return }
      switch value {
      case .failure:
        self.dataSource = []
      case .finished:
        break
      }
    }) { [weak self]  (forecast) in
      guard let self = self else { return }
      self.dataSource = forecast
    }
  .store(in: &disposables)
  }
}

extension WeeklyWeatherViewModel {
  var currentWeatherView: some View {
    return WeeklyWeatherBuilder.makeCurrentWeatherView(withCity: city, weatherFetcher: weatherFetcher)
  }
}
