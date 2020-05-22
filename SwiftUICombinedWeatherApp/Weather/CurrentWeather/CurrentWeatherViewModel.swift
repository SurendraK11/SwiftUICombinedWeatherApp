
/// Surendra
///
///

import Foundation
import Combine

class CurrentWeatherViewModel: ObservableObject, Identifiable {
  
  @Published var dataSource: CurrentWeatherRowViewModel?
  
  let city: String
  private let weatherFetcher: WeatherFetchable
  private var disposables = Set<AnyCancellable>()
  
  init(withWeatherFetcher weatherFetcher: WeatherFetchable, city: String) {
    self.city = city
    self.weatherFetcher = weatherFetcher
  }
  
//  func cancelPublisher()  {
//    for pub in disposables {
//      pub.cancel()
//    }
//    disposables.removeAll()
//  }
  
  func refresh() {
    weatherFetcher.currentWeatherForecast(forCity: city)
      .map(CurrentWeatherRowViewModel.init)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] (value) in
        guard let self = self else { return }
        switch value {
        case .failure:
          self.dataSource = nil
        case .finished:
          break
        }
      }) { [weak self] (weather) in
        guard let self = self else { return }
        self.dataSource = weather
    }
  .store(in: &disposables)
  
  }
}
