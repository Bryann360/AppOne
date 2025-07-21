//
//  HelloWorldTests.swift
//  HelloWorldTests
//
//  Created by Bryann Bueno on 20/07/25.
//

import Testing
@testable import HelloWorld

struct HelloWorldTests {

    @Test func searchReturnsResults() async throws {
        let vm = FlightSearchViewModel()
        await vm.search()
        #expect(vm.results.count > 0)
    }

}
