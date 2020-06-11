//
// Corona-Warn-App
//
// SAP SE and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import Foundation
import XCTest

private extension TimeInterval {
	static let short = 1.0
	static let medium = 3.0
	static let long = 5.0
}

class ExposureSubmissionUITests: XCTestCase {
	var app: XCUIApplication!

	/// Use this method to grab localized strings correctly.
	private func localized(_ string: String) -> String {
		if let path =
			Bundle(for: ExposureSubmissionUITests.self)
				.path(
					forResource: deviceLanguage,
					ofType: "lproj"
			),
			let bundle = Bundle(path: path) {
			return NSLocalizedString(
				string,
				bundle: bundle,
				comment: ""
			)
		}
		fatalError("Localization could not be loaded.")
	}

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		setupSnapshot(app)
		app.setDefaults()
		app.launchArguments.append(contentsOf: ["-isOnboarded", "YES"])
		app.launchArguments += ["-AppleLanguages", "(de)"]
		app.launchArguments += ["-AppleLocale", "de_DE"]
	}


	/// Launch and wait until the app is ready.
	private func launch() {
		app.launch()
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: .long))
	}

	func test_NavigateToIntroVC() throws {
		launch()

		// Click submit card.
		XCTAssert(app.collectionViews.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .long))
		app.collectionViews.buttons["AppStrings.Home.submitCardButton"].tap()

		// TODO: Make sure this is the correct accesibility identifier.
		XCTAssert(app.navigationBars["Info"].waitForExistence(timeout: .medium))
	}

	func test_NavigateToHotlineVC() throws {
		launch()

		// Open Intro screen.
		XCTAssert(app.collectionViews.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .long))
		app.collectionViews.buttons["AppStrings.Home.submitCardButton"].tap()
		XCTAssert(app.navigationBars["Info"].waitForExistence(timeout: .medium))

		// Click next button.
		// TODO: Remove hardcoded key and add accessibility identifier for button.
		XCTAssertNotNil(app.buttons["Weiter"].waitForExistence(timeout: .medium))
		app.buttons["Weiter"].tap()

		// Select hotline
		XCTAssert(app.buttons["AppStrings.ExposureSubmissionDispatch.hotlineButtonDescription"].waitForExistence(timeout: .medium))
		app.buttons["AppStrings.ExposureSubmissionDispatch.hotlineButtonDescription"].tap()

		// TODO: Check if call screen behaves as expected.
	}

	func test_DataPrivacyDisclaimerShownOnQRCodeScan() throws {
		launch()

		// Open Intro screen.
		XCTAssert(app.collectionViews.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .long))
		app.collectionViews.buttons["AppStrings.Home.submitCardButton"].tap()
		XCTAssert(app.navigationBars["Info"].waitForExistence(timeout: .medium))

		// Click next button.
		// TODO: Remove hardcoded key and add accessibility identifier for button.
		XCTAssertNotNil(app.buttons["Weiter"].waitForExistence(timeout: .medium))
		app.buttons["Weiter"].tap()

		// Select QRCode screen.
		XCTAssert(app.buttons["AppStrings.ExposureSubmissionDispatch.qrCodeButtonDescription"].waitForExistence(timeout: .medium))
		app.buttons["AppStrings.ExposureSubmissionDispatch.qrCodeButtonDescription"].tap()

		// Test that data privacy alert is shown.
		XCTAssertTrue(app.alerts.firstMatch.exists)
	}

	func test_QRCodeScanOpened() throws {
		launch()

		// Open Intro screen.
		XCTAssert(app.collectionViews.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .long))
		app.collectionViews.buttons["AppStrings.Home.submitCardButton"].tap()
		XCTAssert(app.navigationBars["Info"].waitForExistence(timeout: .medium))

		// Click next button.
		// TODO: Remove hardcoded key and add accessibility identifier for button.
		XCTAssertNotNil(app.buttons["Weiter"].waitForExistence(timeout: .medium))
		app.buttons["Weiter"].tap()

		// Select QRCode screen.
		XCTAssert(app.buttons["AppStrings.ExposureSubmissionDispatch.qrCodeButtonDescription"].waitForExistence(timeout: .medium))
		app.buttons["AppStrings.ExposureSubmissionDispatch.qrCodeButtonDescription"].tap()

		// Deny the alert.
		XCTAssertTrue(app.alerts.firstMatch.exists)
		app.alerts.buttons.firstMatch.tap()

		// Check if QR Code screen was accessed
		XCTAssertTrue(app.navigationBars.firstMatch.identifier == localized(AppStrings.ExposureSubmissionQRScanner.title))
	}
}