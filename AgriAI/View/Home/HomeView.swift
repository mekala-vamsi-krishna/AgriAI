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
    @State private var isDragOver = false
    @State private var isProcessing = false
    
    let model = SoilHealthModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 28) {
                        
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                            
                            Text("Upload Farm Document")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Upload Soil Health Cards, reports, or certificates. We’ll analyze and suggest the best actions.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        
                        // Upload area (Drag & Drop OR Tap)
                        if uploadedFileURL == nil {
                            VStack(spacing: 20) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(isDragOver ? Color.green.opacity(0.1) : Color(.systemGray6))
                                    .frame(height: 200)
                                    .overlay(
                                        VStack(spacing: 16) {
                                            Image(systemName: isDragOver ? "doc.badge.plus" : "doc.plaintext")
                                                .font(.system(size: 40))
                                                .foregroundColor(isDragOver ? .green : .gray)
                                                .scaleEffect(isDragOver ? 1.2 : 1.0)
                                                .animation(.easeInOut(duration: 0.2), value: isDragOver)
                                            
                                            VStack(spacing: 8) {
                                                Text(isDragOver ? "Drop your document here" : "Drag & Drop Document")
                                                    .font(.headline)
                                                    .foregroundColor(isDragOver ? .green : .primary)
                                                
                                                Text("Supports PDF, TXT files")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(isDragOver ? Color.green : Color.clear,
                                                    style: StrokeStyle(lineWidth: isDragOver ? 3 : 0, dash: [10]))
                                            .shadow(color: isDragOver ? Color.green.opacity(0.5) : .clear,
                                                    radius: isDragOver ? 8 : 0)
                                            .animation(.easeInOut(duration: 0.3), value: isDragOver)
                                    )
                                    .onDrop(of: [.fileURL], isTargeted: $isDragOver) { providers in
                                        handleDrop(providers: providers)
                                    }
                                    .onTapGesture {
                                        showFileImporter = true
                                    }
                                
                                Button(action: { showFileImporter = true }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "doc.badge.plus")
                                        Text("Upload Document")
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(LinearGradient(colors: [Color.green, Color.green.opacity(0.8)],
                                                               startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(15)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        
                        // Preview of selected file
                        if let fileURL = uploadedFileURL {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Selected Document")
                                        .font(.headline)
                                    Spacer()
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "doc.richtext")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(fileURL.lastPathComponent)
                                            .lineLimit(1)
                                        Text(getFileSize(for: fileURL))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: resetState) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                
                                // Analyze button
                                if !extractedText.isEmpty {
                                    Button(action: {
                                        isProcessing = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            analyzeFromText(extractedText)
                                            isProcessing = false
                                        }
                                    }) {
                                        Text("🔍 Analyze Soil")
                                            .font(.headline)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(LinearGradient(colors: [Color.green, Color.green.opacity(0.7)],
                                                                       startPoint: .leading,
                                                                       endPoint: .trailing))
                                            .foregroundColor(.white)
                                            .cornerRadius(18)
                                            .shadow(color: .green.opacity(0.4), radius: 6, x: 0, y: 4)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 60)
                    }
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
                        extractedText = "❌ Error reading file: \(error.localizedDescription)"
                    }
                }
                .navigationDestination(isPresented: $showResults) {
                    ResultsView(recommendations: recommendations)
                }
                
                // Processing overlay
                if isProcessing {
                    TreeLoadingView()
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func resetState() {
        uploadedFileURL = nil
        extractedText = ""
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (item, error) in
            DispatchQueue.main.async {
                if let data = item as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    uploadedFileURL = url
                    extractedText = extractTextFromPDF(url: url)
                }
            }
        }
        return true
    }
    
    private func getFileSize(for url: URL) -> String {
        do {
            let resources = try url.resourceValues(forKeys: [.fileSizeKey])
            if let fileSize = resources.fileSize {
                let kb = Double(fileSize) / 1024.0
                return String(format: "%.1f KB", kb)
            }
        } catch {}
        return ""
    }
    
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
    
    private func analyzeFromText(_ text: String) {
        func extract(_ label: String) -> Double? {
            let pattern = "\(label)[:\\s]+([0-9\\.]+)"
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
        
        recommendations = model.analyze(soil: soil)
        showResults = true
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
