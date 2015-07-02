//
//  NSBundle+TestAdditions.swift
//  Places
//
//  Created by Kazutoshi Baba on 6/25/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation

class Dummy {}

extension NSBundle {
  class func testBundle() -> NSBundle! {
  return NSBundle(forClass: Dummy.self) }
}