//
//  File.swift
//  Set
//
//  Created by Сергей Дорошенко on 12/08/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import Foundation

/// Each set card propery can be described with this 3 types (or variants).
///
/// - type1: the first variant.
/// - type2: the second variant.
/// - type3: the third variant.
enum Type: Int, CaseIterable {
    case type1 = 1
    case type2
    case type3
}
