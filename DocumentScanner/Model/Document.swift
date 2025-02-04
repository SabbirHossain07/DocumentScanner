//
//  Document.swift
//  DocumentScanner
//
//  Created by Sopnil Sohan on 3/2/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Document {
    var name: String
    var createdAt: Date = Date()
    @Relationship(deleteRule: .cascade, inverse: \DocumentPage.document)
    var pages: [DocumentPage]?
    var isLocked: Bool = false
    
    var uniqueViewID: String = UUID().uuidString
    
    init(name: String, pages: [DocumentPage]? = nil) {
        self.name = name
        self.pages = pages
    }
}
