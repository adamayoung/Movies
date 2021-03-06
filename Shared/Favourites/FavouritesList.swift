//
//  FavouritesList.swift
//  Movies
//
//  Created by Adam Young on 02/09/2020.
//

import SwiftUI

struct FavouritesList: View {

    var movies: [Movie]
    var tvShows: [TVShow]
    var people: [Person]

    var body: some View {
        #if os(iOS)
        content
            .listStyle(GroupedListStyle())
        #else
        content
        #endif
    }

    private var content: some View {
        List {
            if !movies.isEmpty {
                Section(header: moviesSectionHeader) {
                    MoviesCarousel(movies: movies, imageType: .backdrop(displaySize: .medium))
                        .listRowInsets(EdgeInsets())
                }
            }

            if !tvShows.isEmpty {
                Section(header: tvShowsSectionHeader) {
                    TVShowsCarousel(tvShows: tvShows, imageType: .backdrop(displaySize: .medium))
                        .listRowInsets(EdgeInsets())
                }
            }

            if !people.isEmpty {
                Section(header: peopleSectionHeader) {
                    PeopleCarousel(people: people, displaySize: .medium)
                        .listRowInsets(EdgeInsets())
                }
            }
        }
    }

    private var moviesSectionHeader: some View {
        HStack(alignment: .center) {
            Text("Movies")
                .font(.title)
                .fontWeight(.heavy)

            Spacer()
            NavigationLink(destination: FavouriteMoviesView()) {
                Text("See all")
                    .font(.body)
                    .foregroundColor(.accentColor)
            }
        }
        .textCase(.none)
        .foregroundColor(.primary)
    }

    private var tvShowsSectionHeader: some View {
        HStack(alignment: .center) {
            Text("TV Shows")
                .font(.title)
                .fontWeight(.heavy)

            Spacer()
            NavigationLink(destination: FavouriteTVShowsView()) {
                Text("See all")
                    .font(.body)
                    .foregroundColor(.accentColor)
            }
        }
        .textCase(.none)
        .foregroundColor(.primary)
    }

    private var peopleSectionHeader: some View {
        HStack(alignment: .center) {
            Text("People")
                .font(.title)
                .fontWeight(.heavy)

            Spacer()
            NavigationLink(destination: FavouritePeopleView()) {
                Text("See all")
                    .font(.body)
                    .foregroundColor(.accentColor)
            }
        }
        .textCase(.none)
        .foregroundColor(.primary)
    }

}

struct FavouritesList_Previews: PreviewProvider {

    static var previews: some View {
        FavouritesList(movies: [], tvShows: [], people: [])
    }

}
