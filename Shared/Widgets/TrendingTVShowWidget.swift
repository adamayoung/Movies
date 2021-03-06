//
//  TrendingTVShowWidget.swift
//  Movies
//
//  Created by Adam Young on 15/07/2020.
//

import Combine
import SwiftUI
import TMDb
import WidgetKit

struct TrendingTVShowWidget: Widget {

    private let kind = "TrendingTVShow"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TrendingTVShowEntryView(entry: entry)
        }
        .configurationDisplayName("Trending TV Show")
        .description("See the top trending TV show at the moment.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }

}

extension TrendingTVShowWidget {

    final class ProviderService {

        private var cancellables = Set<AnyCancellable>()
        private let tvShowsManager: TVShowsManager
        private let urlSession: URLSession

        init(tvShowsManager: TVShowsManager = TMDbTVShowsManager(), urlSession: URLSession = .shared) {
            TMDbAPI.setAPIKey(AppConstants.theMovieDatabaseAPIKey)
            self.tvShowsManager = tvShowsManager
            self.urlSession = urlSession
        }

        func fetch(completion: @escaping (Entry) -> Void) {
            tvShowsManager.fetchTrending()
                .retry(5)
                .map(\.first)
                .replaceError(with: nil)
                .flatMap { tvShow -> AnyPublisher<Entry, Never> in
                    let currentDate = Date()
                    guard
                        let thisTVShow = tvShow,
                        let backdropURL = thisTVShow.backdropImage?.originalURL
                    else {
                        return Just(Entry(date: currentDate, name: tvShow?.name))
                            .eraseToAnyPublisher()
                    }

                    return self.urlSession.dataTaskPublisher(for: backdropURL)
                        .map { $0.data as Data? }
                        .replaceError(with: nil)
                        .map { Entry(id: thisTVShow.id, date: currentDate, name: thisTVShow.name, backdropData: $0) }
                        .eraseToAnyPublisher()
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: completion)
                .store(in: &cancellables)
        }
    }

    struct Provider: TimelineProvider {

        private let service: ProviderService

        init(service: ProviderService = .init()) {
            self.service = service
        }

        func placeholder(in context: Context) -> TrendingTVShowWidget.Entry {
            Entry(date: Date(), name: "Game of Thrones", backdropImageName: "TrendingTVShowPlaceholderBackdrop")
        }

        func getSnapshot(in context: Context, completion: @escaping (TrendingTVShowWidget.Entry) -> Void) {
            service.fetch { entry in
                completion(entry)
            }
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<TrendingTVShowWidget.Entry>) -> Void) {
            let currentDate = Date()
            let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            service.fetch { entry in
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
        }

    }

}

extension TrendingTVShowWidget {

    struct Entry: TimelineEntry {

        var id: TVShow.ID?
        var date: Date
        var name: String?
        var backdropData: Data?
        var backdropImageName: String?

        var url: URL? {
            guard let id = id else {
                return nil
            }

            return URL(string: "movies://tvshows/\(id)")!
        }

    }

}

struct TrendingTVShowEntryView: View {

    var entry: TrendingTVShowWidget.Entry

    init(entry: TrendingTVShowWidget.Entry) {
        TMDbAPI.setAPIKey(AppConstants.theMovieDatabaseAPIKey)
        self.entry = entry
    }

    var body: some View {
        if let url = entry.url {
            content
                .widgetURL(url)
        } else {
            content
        }
    }

    private var content: some View {
        MovieWidgetView(type: .trendingTVShow, title: entry.name, backdropData: entry.backdropData, backdropImageName: entry.backdropImageName)
    }

}

struct TrendingTVShowWidget_Previews: PreviewProvider {

    static let entry = TrendingTVShowWidget.Entry(date: Date(), name: "Game of Thrones", backdropImageName: "TrendingTVShowPlaceholderBackdrop")

    static var previews: some View {
        Group {
            TrendingTVShowEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }

}
