//
//  DocumentPage.swift
//  DocumentScanner
//
//  Created by Sopnil Sohan on 3/2/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class DocumentPage {
    var pageIndex: Int
    @Attribute(.externalStorage)
    var pageData: Data
    
    // Correct inverse relationship
    var document: Document?
    
    init(pageIndex: Int, pageData: Data, document: Document? = nil) {
        self.pageIndex = pageIndex
        self.pageData = pageData
        self.document = document
    }
}
