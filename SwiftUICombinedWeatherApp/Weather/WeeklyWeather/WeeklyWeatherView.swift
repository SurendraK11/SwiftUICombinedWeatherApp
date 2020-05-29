
/// Surendra
///
///

import SwiftUI

struct WeeklyWeatherView: View {
    
    @ObservedObject var weeklyWeatherViewModel: WeeklyWeatherViewModel
    
    init(withViewModel viewModel: WeeklyWeatherViewModel) {
        self.weeklyWeatherViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                searchField
                if weeklyWeatherViewModel.dataSource.isEmpty {
                    emptySection
                } else {
                    cityHourlyWeatherLinkSection
                    forecastSection
                }
            }
                
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Weather ⛅️")
        }
    }
}

private extension WeeklyWeatherView {
    var searchField: some View {
        HStack(alignment: .center, spacing: 0) {
            TextField("e.g. London", text: $weeklyWeatherViewModel.city)
        }
    }
    
    var forecastSection: some View {
        Section {
            ForEach(weeklyWeatherViewModel.dataSource) { viewModel in
                DailyWeatherRow.init(viewModel: viewModel)
            }
            
            //      //Short form
            //      ForEach(weeklyWeatherViewModel.dataSource, content: DailyWeatherRow.init(viewModel:))
        }
    }
    
    var emptySection: some View {
        Section {
            Text("No results found")
                .foregroundColor(.gray)
        }
    }
    
    var cityHourlyWeatherLinkSection: some View {
        Section {
            NavigationLink(destination: weeklyWeatherViewModel.currentWeatherView) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(weeklyWeatherViewModel.city)
                    Text("Weather toda")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    
}

#if DEBUG
struct WeeklyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyWeatherView(withViewModel: WeeklyWeatherViewModel(withwWatherFetcher: WeatherFetcher()))
    }
}
#endif
