//
//  RecommendedMoviesView.swift
//  Movies
//
//  Created by Adam Young on 24/07/2020.
//

import SwiftUI

struct RecommendedMoviesView: View {

    var movieID: Movie.ID

    @EnvironmentObject private var movieStore: MovieStore

    private var movies: [Movie]? {
        movieStore.recommendations(forMovie: movieID)
    }

    var body: some View {
        content
            .overlay(Group {
                if movies == nil {
                    ProgressView()
                }
            })
            .onAppear(perform: fetch)
            .navigationTitle("Recommendations")
    }

    @ViewBuilder private var content: some View {
        if let movies = movies {
            MoviesCollection(movies: movies)
                .transition(AnyTransition.opacity.animation(Animation.easeOut.speed(0.5)))
        } else {
            List { }
        }
    }

}

extension RecommendedMoviesView {

    private func fetch() {
        guard movies == nil else {
            return
        }

        movieStore.fetchRecommendations(forMovie: movieID)
    }

}

// struct RecommendedMoviesView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        RecommendedMoviesView(movieID: 1)
//    }
//
// }
