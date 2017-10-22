//
//  FoodRepositoryProtocol.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 22/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import Foundation

protocol FoodRepositoryProtocol {
    associatedtype T
    func add(user: T)
}