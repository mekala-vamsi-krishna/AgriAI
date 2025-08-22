//
//  DocumentUploadView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/20/25.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct HomeView: View {
    @State private var recommendations: [Recommendation] = []
    @State private var showResults = false
    @State private var extractedText: String = ""
    @State private var showFileImporter = false
    @State private var uploadedFileURL: URL?

    let model = SoilHealthModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // Title
                Text("Soil Health Analysis")
                    .font(.title.bold())
                    .foregroundColor(.green)
                    .padding(.top, 10)

                // File upload area
                if let fileURL = uploadedFileURL {
                    ZStack(alignment: .topTrailing) {
                        // Background for clarity
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .shadow(radius: 5)

                        // File view
                        if fileURL.pathExtension.lowercased() == "pdf" {
                            PDFKitView(url: fileURL)
                                .frame(height: 250)
                                .cornerRadius(10)
                                .clipped()
                        } else {
                            Text(fileURL.lastPathComponent)
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }

                        // Delete button
                        Button(action: {
                            uploadedFileURL = nil
                            extractedText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                                .padding(8)
                        }
                    }
                    .frame(height: 250) // fixes uneven background height
                    .padding(.horizontal)
                }

                // Upload Button (show only if no file)
                if uploadedFileURL == nil {
                    Button(action: {
                        showFileImporter = true
                    }) {
                        Label("Upload Soil Health Card", systemImage: "doc.text.fill")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }

                // Analyze button (show only if extractedText is not empty)
                if !extractedText.isEmpty {
                    Button(action: {
                        analyzeFromText(extractedText)
                    }) {
                        Text("Analyze Soil")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.pdf, .plainText],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedFile = try result.get().first else { return }
                    uploadedFileURL = selectedFile
                    if selectedFile.startAccessingSecurityScopedResource() {
                        defer { selectedFile.stopAccessingSecurityScopedResource() }
                        if selectedFile.pathExtension.lowercased() == "pdf" {
                            extractedText = extractTextFromPDF(url: selectedFile)
                        } else {
                            let data = try Data(contentsOf: selectedFile)
                            extractedText = String(data: data, encoding: .utf8) ?? ""
                        }
                    }
                } catch {
                    extractedText = "Error reading file: \(error.localizedDescription)"
                }
            }
            .navigationDestination(isPresented: $showResults) {
                ResultsView(recommendations: recommendations)
            }
        }
    }


    // MARK: - PDF Text Extraction
    private func extractTextFromPDF(url: URL) -> String {
        guard let pdf = PDFDocument(url: url) else { return "" }
        var fullText = ""
        for i in 0..<pdf.pageCount {
            if let page = pdf.page(at: i), let pageText = page.string {
                fullText += pageText + "\n"
            }
        }
        return fullText
    }

    // MARK: - Parser + Analyzer
    private func analyzeFromText(_ text: String) {
        func extract(_ label: String) -> Double? {
            let pattern = "\(label)[:\\s]+([0-9\\.]+)"  // allow ":" OR spaces
            if let range = text.range(of: pattern, options: .regularExpression) {
                let match = String(text[range])
                if let number = match.components(separatedBy: CharacterSet(charactersIn: ": ")).last?
                    .trimmingCharacters(in: .whitespaces),
                   let val = Double(number) {
                    return val
                }
            }
            return nil
        }

        let soil = SoilData(
            ph: extract("Soil pH") ?? -1,
            nitrogen: extract("Nitrogen") ?? -1,
            organicCarbon: extract("Organic Carbon") ?? -1,
            zinc: extract("Zinc") ?? -1,
            iron: extract("Iron") ?? -1,
            manganese: extract("Manganese") ?? -1,
            copper: extract("Copper") ?? -1,
            boron: extract("Boron") ?? -1
        )

        let allMissing = [
            soil.ph, soil.nitrogen, soil.organicCarbon,
            soil.zinc, soil.iron, soil.manganese,
            soil.copper, soil.boron
        ].allSatisfy { $0 == -1 }

        if allMissing {
            extractedText = "Could not extract any soil values. Please upload a valid Soil Health Card."
            showResults = false
        } else {
            recommendations = model.analyze(soil: soil)
            showResults = true
        }
    }
}

// MARK: - PDFKit View for Preview
struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: url)
        pdfView.backgroundColor = UIColor.systemGray6
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}


// MARK: - Preview
#Preview {
    HomeView()
}
