//
//  Home.swift
//  DocumentScanner
//
//  Created by Sopnil Sohan on 3/2/25.
//

import SwiftUI
import SwiftData
import VisionKit

struct Home: View {
    @State private var showScannerView: Bool = false
    @State private var scanDocumnet: VNDocumentCameraScan?
    @State private var documentName: String = "New Document"
    @State private var askDocumentName: Bool = false
    @State private var isLoading: Bool = false
    @Query(sort: [.init(\Document.createdAt, order: .reverse)], animation: .snappy(duration: 0.25, extraBounce: 0)) private var documents: [Document]
    
    @Namespace private var animationID
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 15) {
                    ForEach(documents) { documents in
                        NavigationLink {
                            DocumentDetailView(document: documents)
                                .navigationTransition(.zoom(sourceID: documents.uniqueViewID, in: animationID))
                        } label: {
                            DocumentCardView(document: documents, animationID: animationID)
                                .foregroundStyle(Color.primary)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Document's")
            .safeAreaInset(edge: .bottom) {
                createButton()
            }
        }
        .fullScreenCover(isPresented: $showScannerView) {
            ScannerView { error in
                
            } didCancel: {
                showScannerView = false
            } didFinish: { scan in
                scanDocumnet = scan
                showScannerView = false
                askDocumentName = true
            }
            .ignoresSafeArea()
        }
        .alert("Document Name", isPresented: $askDocumentName) {
            TextField("New Document", text: $documentName)
            
            Button("Save") {
                createDocument()
            }
            .disabled(documentName.isEmpty)
        }
        .loadingScreen(status: $isLoading)
    }
    @ViewBuilder
    private func createButton() -> some View {
        Button {
            showScannerView.toggle()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "document.viewfinder.fill")
                    .font(.title3)
                Text("Scan Document")
            }
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .padding(.horizontal, 20)
            .padding(.vertical)
            .background(.blue.gradient, in: .capsule)
        }
        .hSpacing(.center)
        .padding(.vertical, 10)
        .background {
            Rectangle()
                .fill(.linearGradient(colors: [Color.white.opacity(0), Color.white.opacity(0.5), .white, .white], startPoint: .top, endPoint: .bottom))
        }
        .ignoresSafeArea()
    }
    
    private func createDocument() {
        guard let scanDocumnet else { return }
        isLoading = true
        Task.detached(priority: .high) { [documentName] in
            let document = Document(name: documentName)
            var pages: [DocumentPage] = []
            
            for pageIndex in 0..<scanDocumnet.pageCount {
                let pageImage = scanDocumnet.imageOfPage(at: pageIndex)
                
                guard let pageData = pageImage.jpegData(compressionQuality: 0.65) else { return }
                let documentPage = DocumentPage(pageIndex: pageIndex, pageData: pageData, document: document)
                pages.append(documentPage)
            }
            
            document.pages = pages
            
            await MainActor.run {
                context.insert(document)
                try? context.save()
                self.scanDocumnet = nil
                isLoading = false
                self.documentName = "New Documnet"
            }
        }
    }
}
