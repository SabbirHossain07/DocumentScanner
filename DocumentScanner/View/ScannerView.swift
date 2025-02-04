//
//  ScannerView.swift
//  DocumentScanner
//
//  Created by Sopnil Sohan on 3/2/25.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    var didFinishWithError: ((Error) -> Void)?
    var didCancel: () -> Void
    var didFinish: (VNDocumentCameraScan) -> Void
    
    @State private var isProcessing: Bool = false
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        
        // Customize the appearance (optional)
        controller.view.tintColor = UIColor.systemBlue
        controller.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScannerView
        
        init(parent: ScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            parent.isProcessing = true
            
            // Simulate processing delay (e.g., for image enhancement)
            DispatchQueue.global().async {
                // Perform any image processing here (e.g., cropping, filtering)
                DispatchQueue.main.async {
                    self.parent.isProcessing = false
                    self.parent.didFinish(scan)
                }
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.didCancel()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.didFinishWithError?(error)
        }
    }
}
