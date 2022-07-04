//
//  Element.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 7.06.22.
//

import Foundation

struct Element {
    let name: String
    let path: URL
    let type: ElementType
}

enum ElementType {
    case folder
    case photo
}
