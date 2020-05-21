import Foundation
import Combine

protocol WeatherFetchable {
  
  func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, WeatherError>
  func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherError>
  
}

class WeatherFetcher {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

// MARK: - OpenWeatherMap API
private extension WeatherFetcher {
  struct OpenWeatherAPI {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5"
    static let key = "84ea3b88663731852705d2d15c4497f0"
  }
  
  func makeWeeklyForecastComponents(
    withCity city: String
  ) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/forecast"
    
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
  
  func makeCurrentDayForecastComponents(
    withCity city: String
  ) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/weather"
    
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
}


extension WeatherFetcher: WeatherFetchable {
  func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, WeatherError> {
    return forecast(with: makeWeeklyForecastComponents(withCity: city))
  }
  
  func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherError> {
    return forecast(with: makeCurrentDayForecastComponents(withCity: city))
  }
  
  private func forecast<T> (with component: URLComponents) -> AnyPublisher<T, WeatherError> where T: Decodable {
    
    guard let url = component.url else {
      let error = WeatherError.network(description: "url issue")
      return Fail(error: error).eraseToAnyPublisher()
    }
    
    return session.dataTaskPublisher(for: URLRequest(url: url))
      .mapError { error in
        .network(description: error.localizedDescription)
    }
    .flatMap(maxPublishers: .max(1)) { response in
      decode(response.data)
    }
    .eraseToAnyPublisher()
    
  }
  
}
