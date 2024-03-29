//
//  ScanView.swift
//  VacScan
//
//  Created by Thomas Wang on 1/24/24.
//

import SwiftUI
import VisionKit
import Vision

struct ScanView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var scans: [UIImage]
    @Binding var recognizedText: String
        
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $recognizedText, scans: $scans, parent: self)
    }
        
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        // nothing to do here
    }
        
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var recognizedText: Binding<String>
        var scans: Binding<[UIImage]>
        var parent: ScanView
            
        init(recognizedText: Binding<String>, scans: Binding<[UIImage]>, parent: ScanView) {
            self.recognizedText = recognizedText
            self.scans = scans
            self.parent = parent
        }
            
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let extractedImages = extractImages(from: scan)
            let processedText = recognizeText(from: extractedImages)
            
            var tempScans = [UIImage]()
            
            for scan in extractedImages {
                tempScans.append(UIImage(cgImage: scan))
            }
            
            scans.wrappedValue = tempScans
            
            recognizedText.wrappedValue = processedText
            
            parent.presentationMode.wrappedValue.dismiss()
        }
            
        fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var extractedImages = [CGImage]()
            for index in 0..<scan.pageCount {
                let extractedImage = scan.imageOfPage(at: index)
                guard let cgImage = extractedImage.cgImage else { continue }
                
                extractedImages.append(cgImage)
            }
            return extractedImages
        }
        
        fileprivate func recognizeText(from images: [CGImage]) -> String {
            var entireRecognizedText = ""
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard error == nil else { return }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let maximumRecognitionCandidates = 1
                for observation in observations {
                    guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
                    
                    entireRecognizedText += "\(candidate.string)\n"
                        
                }
            }
            recognizeTextRequest.recognitionLevel = .accurate
                
            for image in images {
                let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                
                try? requestHandler.perform([recognizeTextRequest])
            }
            
            return entireRecognizedText
        }
    }
}
