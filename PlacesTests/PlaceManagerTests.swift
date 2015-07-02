/*
 * Copyright (c) 2014 Razeware LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *  PlaceManagerTests.swift
 *  Places
 *
 *  Created by Soheil Azarpour on 7/4/14.
 */

import XCTest

class PlaceManagerTests: XCTestCase {
  
  let placeManager = PlaceManager.sharedManager()
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testPlaceManagerInitialization() {
    var optionalManager: PlaceManager? = PlaceManager.sharedManager()
    XCTAssertTrue(optionalManager != nil, "PlaceManager failed to return shared instance.")
  }
  
  func testLocalResourceFileURLGetter() {
    var localResourceURL: NSURL? = placeManager.localResourceFileURL
    XCTAssertNotNil(localResourceURL, "PlaceManager failed to return default local resource URL.")
  }
  
  func testAsyncFetchPlaces() {
    let expectation: XCTestExpectation = expectationWithDescription("Async fetch")
    
    var sampleURL: NSURL? = NSBundle.testBundle().URLForResource("SampleResponse", withExtension: "json")
    XCTAssertNotNil(sampleURL, "Failed to get a valid URL to sample response file in Test Bundle.")
    
    placeManager.localResourceFileURL = sampleURL!
    
    placeManager.fetchPlacesWithCompletion({ (places: [Place]) in
      var optionalPlaces: [Place]? = places
      XCTAssertTrue(count(places) == 600, "Expected to get 600 results from the sample response.")
      expectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(1.0, handler: { (error) in
        XCTAssertNil(error, "PlaceManager failed to process fetch from sample response in a reasonable time.");
    })
  }
  
  func testPerformanceProcessJSONRoot () {
    var sampleURL: NSURL? = NSBundle.testBundle().URLForResource("SampleResponse", withExtension: "json")
    XCTAssertNotNil(sampleURL, "Failed to get a valid URL to sample response file in Test Bundle.")
    
    if let data = NSData(contentsOfURL: sampleURL!) {
      var root = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as! NSMutableDictionary
      
      measureBlock({
        var places: [Place] = self.placeManager.processJSONRoot(root)
        XCTAssertTrue(count(places) == 600, "Expected to get 600 results from the sample response.")
      })
    }
  }
}