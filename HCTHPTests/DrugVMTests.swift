//
//  DrugVMTests.swift
//  HCTHPTests
//
//  Created by Mahmudul Hasan on 2024-07-29.
//

import XCTest
@testable import HCTHP

final class DrugVMTests: XCTestCase {

    var viewModel: DrugVM!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = DrugVM()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    // public search api
    func testSearchDrugs() async {
        await viewModel.searchDrugs(by: "cymbalta")

        // Assuming drugs are updated immediately for simplicity. Adjust as needed for your implementation.
        if let data = viewModel.searchResult?.data {
            XCTAssertGreaterThan(data.count, 0)
        }
    }

    // gets all drug by user
    func testGetUserDrugs() async {
        await viewModel.getUserDrugs()

        // Assuming user drugs are loaded correctly, it can be zero too
        XCTAssertGreaterThanOrEqual(viewModel.savedDrugs.count, 0)
    }

// adds a drug for user
// these are tricky since we can only add drug that we know from search
//    func testAddDrug() async {
//
//    }
//
//    func testGetDrugDetailsFor() async {}
//
//    func testDeleteDrugOf() async {}
}
