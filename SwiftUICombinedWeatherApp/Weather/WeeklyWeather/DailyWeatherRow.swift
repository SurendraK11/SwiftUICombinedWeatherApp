/// Surendra
///
///

import SwiftUI

struct DailyWeatherRow: View {
  private let viewModel: DailyWeatherRowViewModel
  
  init(viewModel: DailyWeatherRowViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        Text("\(viewModel.day)")
        Text("\(viewModel.month)")
      }
      VStack(alignment: .leading, spacing: 0) {
        Text("\(viewModel.title)")
          .font(.body)
        Text("\(viewModel.fullDescription)")
          .font(.footnote)
      }
      .padding(.leading, 8)
      Spacer()
      VStack(alignment: .leading, spacing: 0) {
        Text("\(viewModel.temperature)°")
        .font(.title)
      }
    }
  }
}
