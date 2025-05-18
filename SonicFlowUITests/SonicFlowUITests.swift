import XCTest

final class SonicFlowUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-isUITest") // ✅ Аргумент для обхода логина
        app.launch()
    }

    func testTabBarNavigation() throws {
        XCTAssertTrue(app.tabBars.buttons["Home"].exists)
        XCTAssertTrue(app.tabBars.buttons["Nature"].exists)
        XCTAssertTrue(app.tabBars.buttons["Sleep"].exists)
        XCTAssertTrue(app.tabBars.buttons["Meditation"].exists)
        XCTAssertTrue(app.tabBars.buttons["Ambience"].exists)

        app.tabBars.buttons["Sleep"].tap()
        XCTAssertTrue(app.staticTexts["Sleep Sounds"].exists)

        app.tabBars.buttons["Meditation"].tap()
        XCTAssertTrue(app.staticTexts["Meditation Sounds"].exists)
    }

    func testSoundPlayback() throws {
        app.tabBars.buttons["Nature"].tap()

        let oceanCell = app.scrollViews.otherElements.containing(.staticText, identifier: "Ocean").element
        XCTAssertTrue(oceanCell.exists)

        let playButton = oceanCell.buttons["play.fill"]
        XCTAssertTrue(playButton.exists)
        playButton.tap()

        let pauseButton = oceanCell.buttons["pause.fill"]
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2))
    }

    func testOpenTimerPopup() throws {
        app.tabBars.buttons["Ambience"].tap()

        let timerButton = app.scrollViews.buttons["timer"]
        XCTAssertTrue(timerButton.exists)
        timerButton.tap()

        let popupText = app.staticTexts["Set Timer"]
        XCTAssertTrue(popupText.waitForExistence(timeout: 2))
    }

    func testToggleFavorite() throws {
        app.tabBars.buttons["Sleep"].tap()

        let heartButton = app.scrollViews.buttons["heart"]
        XCTAssertTrue(heartButton.exists)
        heartButton.tap()

        let filledHeartButton = app.scrollViews.buttons["heart.fill"]
        XCTAssertTrue(filledHeartButton.waitForExistence(timeout: 2))
    }
}
