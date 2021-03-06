//
//  ShowFullOverview.swift
//  Movies
//
//  Created by Adam Young on 16/07/2020.
//

import SwiftUI

struct ShowPlotView: View {

    @Environment(\.presentationMode) private var presentationMode

    var plot: String

    var body: some View {
        #if os(watchOS)
        return content
        #elseif os(iOS)
        return content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Close", action: dismiss)
                }
            }
        #else
        return content
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Close", action: dismiss)
                }
            }
        #endif
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(plot)
                HStack {
                    Spacer()
                }
            }
            .multilineTextAlignment(.leading)
            .padding()
        }
        .navigationTitle("Plot")
    }

}

extension ShowPlotView {

    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }

}

struct ShowPlotView_Previews: PreviewProvider {

    static var previews: some View {
        ShowPlotView(plot: "Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text. Some overview text.")
    }

}
