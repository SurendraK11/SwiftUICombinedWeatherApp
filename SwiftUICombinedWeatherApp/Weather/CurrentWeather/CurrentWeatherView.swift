
/// Surendra
///
///

import SwiftUI

struct CurrentWeatherView: View {
  
  @ObservedObject var currentWeatherViewModel: CurrentWeatherViewModel
  
  init(withViewModel viewModel: CurrentWeatherViewModel) {
    self.currentWeatherViewModel = viewModel
  }
  
  
  var body: some View {
    VStack {
        
        if self.currentWeatherViewModel.isLoading {
            ActivityIndicatorView().padding()
        }
        
        List(content: content)
          .onAppear {
            self.currentWeatherViewModel.refresh()
        }
        .onDisappear(perform: {
          self.currentWeatherViewModel.cancelSubscriptions()
        })
            
        .navigationBarTitle(Text(currentWeatherViewModel.city), displayMode: .inline)
        .listStyle(GroupedListStyle())
    }
    
  }
}

private extension CurrentWeatherView {
  func content() -> some View {
    if let rowViewModel = currentWeatherViewModel.dataSource {
      return AnyView(details(for: rowViewModel))
    } else {
      return AnyView(loading)
    }
  }
  
  func details(for viewModel: CurrentWeatherRowViewModel) -> some View {
    CurrentWeatherRow(viewModel: viewModel)
  }
  
  var loading: some View {
    Text("Loading \(currentWeatherViewModel.city)'s weather...")
      .foregroundColor(.gray)
  }
}



#if DEBUG
struct CurrentWeatherView_Previews: PreviewProvider {
  static var previews: some View {
    CurrentWeatherView(withViewModel: CurrentWeatherViewModel(withWeatherFetcher: WeatherFetcher(), city: "London"))
  }
}
#endif
