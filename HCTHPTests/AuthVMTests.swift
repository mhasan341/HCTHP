//
//  HCTHPTests.swift
//  HCTHPTests
//
//  Created by Mahmudul Hasan on 2024-07-29.
//

import XCTest
@testable import HCTHP

final class AuthVMTests: XCTestCase {

    var viewModel: AuthVM!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = AuthVM()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    func testLoginSuccess() async {
        await viewModel.login(email: "mahmud@housecall.ae", password: "password")

        XCTAssertNotNil(viewModel.authToken)
    }

    func testLoginFailure() async {
        // remove any old token
        viewModel.authToken = ""
        await viewModel.login(email: "wrong@example.com", password: "wrongpassword")

        XCTAssertEqual(viewModel.authToken, "")
    }

    func testRegisterSuccess() async {
        await viewModel.signUp(name: "Test User", email: "new@example.com", password: "password")

        XCTAssertNotNil(viewModel.authToken)
        XCTAssertNil(viewModel.registrationError)
    }

    func testRegisterFailure() async {
        // remove any old token
        viewModel.authToken = ""
        await viewModel.signUp(name: "Test User", email: "test@example.com", password: "password")

        // if user can't register, we don't have a token
        XCTAssertEqual(viewModel.authToken, "")
    }

}
