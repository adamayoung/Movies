//
//  MoviesUITests.swift
//  UITests (iOS)
//
//  Created by Adam Young on 25/09/2020.
//

import XCTest

class MoviesUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments = [
            "SKIP_ANIMATIONS"
        ]
        setupSnapshot(app)
        app.launch()
    }

    func testHomeSnapshot() throws {
        let seeMoreTrendingMoviesButton = app.tables.buttons["SeeMoreTrendingMovies"]
        guard seeMoreTrendingMoviesButton.waitForExistence(timeout: 5) else {
            XCTFail("See more Trending Movies button not found")
            return
        }

        sleep(10)
        snapshot("0Home")
    }

    func testTrendingMoviesSnapshot() throws {
        let seeMoreTrendingMoviesButton = app.tables.buttons["SeeMoreTrendingMovies"]
        guard seeMoreTrendingMoviesButton.waitForExistence(timeout: 5) else {
            XCTFail("See more Trending Movies button not found")
            return
        }

        seeMoreTrendingMoviesButton.tap()

        sleep(10)
        snapshot("1TrendingMovies")
    }

    func testTVShowDetailsSnapshot() throws {
        let seeMoreTrendingMoviesButton = app.tables.buttons["SeeMoreTrendingMovies"]
        guard seeMoreTrendingMoviesButton.waitForExistence(timeout: 5) else {
            XCTFail("See more Trending Movies button not found")
            return
        }

        app.tables["HomeView"].swipeUp()

        let trendingTVShowsCarousel = app.tables.scrollViews["TrendingTVShowsCarousel"]
        let firstTrendingTVShow = trendingTVShowsCarousel.images.firstMatch

        firstTrendingTVShow.tap()

        let tvShowDetailsView = app.tables["TVShowDetails"]
        guard tvShowDetailsView.waitForExistence(timeout: 5) else {
            XCTFail("TV Show details not found")
            return
        }

        sleep(10)
        snapshot("2TVShowDetails")
    }

}
