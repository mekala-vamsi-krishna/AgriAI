//
//  DocumentUploadView.swift
//  AgriAI
//
//  Created by Mekala Vamsi Krishna on 6/20/25.
//

import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct DocumentUploadView: View {
    @State private var selectedDocument: URL?
    @State private var isDragOver = false
    @State private var errorMessage: String?
    @State private var navigateToNextScreen = false
    @State private var documentText: String = ""
    @State private var showingDocumentPicker = false
    
    @State private var isUploading = false
    @State private var isUploaded = false
    
    @State private var isProcessing: Bool = false
    @State private var isProcessed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                            
                            Text("Upload Farm Document")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Share your farming documents, reports, or certificates with ease")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Upload area
                        if selectedDocument == nil && !isUploaded {
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
                                                
                                                Text("Supports PDF, DOC, DOCX, TXT files")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                isDragOver ? Color.green : Color.clear,
                                                style: StrokeStyle(lineWidth: isDragOver ? 3 : 0, dash: [10])
                                            )
                                            .shadow(color: isDragOver ? Color.green.opacity(0.5) : Color.clear,
                                                    radius: isDragOver ? 10 : 0)
                                            .animation(.easeInOut(duration: 0.3), value: isDragOver)
                                    )
                                    .scaleEffect(isDragOver ? 1.02 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isDragOver)
                                    .onDrop(of: [.fileURL], isTargeted: $isDragOver) { providers in
                                            handleDrop(providers: providers)
                                        }
                                    .onTapGesture {
                                        showingDocumentPicker = true
                                    }
                                
                                Button(action: {
                                    showingDocumentPicker = true
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "doc.badge.plus")
                                        Text("Upload Document")
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(LinearGradient(colors: [Color.green, Color.green.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(15)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Selected document preview
                        if let document = selectedDocument {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Selected Document")
                                        .font(.headline)
                                    Spacer()
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: getFileIcon(for: document))
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    
                                    VStack(alignment: .leading) {
                                        Text(document.lastPathComponent)
                                            .lineLimit(2)
                                        Text(getFileSize(for: document))
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
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        uploadSection
                        errorSection
                        
                        Spacer(minLength: 50)
                    }
                    .background(
                        NavigationLink(destination: DestinationView(text: documentText), isActive: $navigateToNextScreen) {
                            EmptyView()
                        }
                    )
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.large)
                .fileImporter(isPresented: $showingDocumentPicker,
                              allowedContentTypes: [.pdf, .plainText, .rtf, .data],
                              allowsMultipleSelection: false,
                              onCompletion: handleFileSelection)
                .blur(radius: isUploading ? 5 : 0)
                if isProcessing {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        RotatingGearsView()
                            .scaleEffect(1.5)
                        
                        Text("Processing...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            } // : ZStack
        }
    }
    
    private var uploadSection: some View {
        Group {
            if isUploaded {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        Text("Document uploaded successfully!")
                            .font(.body)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    
                    Button(action: {
                        isProcessing = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                isProcessing = false
                                navigateToNextScreen = true
                            }
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text("Proceed")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(LinearGradient(colors: [Color.blue, Color.blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var errorSection: some View {
        Group {
            if let error = errorMessage {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Logic
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        _ = provider.loadObject(ofClass: URL.self) { url, _ in
            DispatchQueue.main.async {
                if let url = url {
                    selectedDocument = url
                    isUploaded = true
                    errorMessage = nil
                    readDocumentText(from: url)
                }
            }
        }
        return true
    }
    
    private func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                selectedDocument = url
                isUploaded = true
                errorMessage = nil
                readDocumentText(from: url)
            }
        case .failure(let error):
            errorMessage = "Failed to select file: \(error.localizedDescription)"
        }
    }
    
    private func resetState() {
        selectedDocument = nil
        isUploaded = false
        isUploading = false
        errorMessage = nil
    }
    
    private func processDocument() {
        guard selectedDocument != nil else { return }

        isUploading = true
        isProcessing = true // optional depending on your UI
        navigateToNextScreen = false

        // Simulate delay so we can see the loading animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Simulate processing time (e.g. 3s total)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                isUploading = false
                isProcessing = false
                navigateToNextScreen = true
            }
        }
    }
    
    private func readDocumentText(from url: URL) {
        switch url.pathExtension.lowercased() {
        case "txt": readPlainText(url: url)
        case "pdf": readPDFText(url: url)
        default: documentText = "Unsupported file format."
        }
    }
    
    private func readPlainText(url: URL) {
        do {
            documentText = try String(contentsOf: url, encoding: .utf8)
        } catch {
            documentText = "Failed to read text: \(error.localizedDescription)"
        }
    }
    
    private func readPDFText(url: URL) {
        guard let pdf = PDFDocument(url: url) else {
            documentText = "Unable to open PDF."
            return
        }
        documentText = (0..<pdf.pageCount).compactMap {
            pdf.page(at: $0)?.string
        }.joined(separator: "\n")
    }
    
    private func getFileIcon(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "pdf": return "doc.richtext"
        case "doc", "docx": return "doc.text"
        case "txt": return "doc.plaintext"
        default: return "doc"
        }
    }
    
    private func getFileSize(for url: URL) -> String {
        guard let size = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize else {
            return "Unknown size"
        }
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }
}

// MARK: - Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview

struct DocumentUploadView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentUploadView()
    }
}
