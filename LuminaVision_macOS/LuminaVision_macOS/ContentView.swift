//
//  ContentView.swift
//  LuminaVision_macOS
//
//  Created by 游述宇 on 2025/2/6.
//
import SwiftUI
import UniformTypeIdentifiers


struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var processedImage: NSImage?
    @State private var currentEffect: String?
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 充滿愛意的標題
            Text("LuminaVision")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.brown)
                .padding(.top)
            
            // 溫暖的相片展示窗口
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.windowBackgroundColor))
                    .frame(height: 300)
                    .shadow(radius: 3)
                
                if let image = processedImage ?? selectedImage {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .animation(.easeInOut, value: currentEffect)
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("讓我們一起創造美好回憶")
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                }
                
                if isProcessing {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .brown))
                }
            }
            .padding()
            
            // 溫柔的操作按鈕
            HStack(spacing: 20) {
                Button(action: openImagePicker) {
                    Label("選擇照片", systemImage: "photo.on.rectangle")
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: saveProcessedImage) {
                    Label("珍藏美好", systemImage: "heart.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
                .disabled(selectedImage == nil)
            }
            
            // 充滿藝術感的濾鏡按鈕組
            VStack(spacing: 15) {
                Text("為回憶添加色彩")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // 第一排濾鏡
                HStack(spacing: 15) {
                    FilterButton(title: "夢幻時光", color: .pink) {
                        applyEffect("dreamy")
                    }
                    FilterButton(title: "復古印記", color: .brown) {
                        applyEffect("vintage")
                    }
                }
                
                // 第二排濾鏡
                HStack(spacing: 15) {
                    FilterButton(title: "月光剪影", color: .blue) {
                        applyEffect("watercolor")
                    }
                    FilterButton(title: "真實水彩", color: .cyan) {
                        applyEffect("realwatercolor")
                    }
                }
                
                // 第三排濾鏡
                HStack(spacing: 15) {
                    FilterButton(title: "童話色彩", color: .purple) {
                        applyEffect("fairytale")
                    }
                    FilterButton(title: "原始照片", color: .gray) {
                        resetImage()
                    }
                }
            }
            .disabled(selectedImage == nil)
        }
        .frame(minWidth: 500, minHeight: 600)
        .padding()
    }
    
    private func openImagePicker() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image]
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                if let image = NSImage(contentsOf: url) {
                    selectedImage = image
                    processedImage = nil
                    currentEffect = nil
                }
            }
        }
    }
    
    private func saveProcessedImage() {
        guard let imageToSave = processedImage ?? selectedImage else { return }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType.jpeg, UTType.png]  // 修改這裡
        savePanel.nameFieldStringValue = "我們的美好回憶.jpg"
        
        savePanel.begin { response in  // 確保我們可以在閉包中存取屬性
            if response == .OK, let url = savePanel.url {
                guard let data = imageToSave.tiffRepresentation,
                      let bitmap = NSBitmapImageRep(data: data),
                      let imageData = bitmap.representation(using: .jpeg, properties: [:]) else { return }
                
                do {  // 加入錯誤處理
                    try imageData.write(to: url)
                } catch {
                    print("保存時發生錯誤：\(error)")
                }
            }

        }
    }
    
    private func applyEffect(_ effect: String) {
        guard let image = selectedImage else { return }
        isProcessing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let processedImage: NSImage?
            
            switch effect {
            case "dreamy":
                processedImage = ImageEffects.applyDreamyEffect(to: image)
            case "vintage":
                processedImage = ImageEffects.applyVintageEffect(to: image)
            case "watercolor":
                processedImage = ImageEffects.applyWatercolorEffect(to: image)
            case "oilpainting":
                processedImage = ImageEffects.applyOilPaintingEffect(to: image)
            case "fairytale":
                processedImage = ImageEffects.applyFairyTaleEffect(to: image)
            default:
                processedImage = nil
            }
            
            DispatchQueue.main.async {
                self.processedImage = processedImage
                self.currentEffect = effect
                self.isProcessing = false
            }
        }
    }
    
    private func resetImage() {
        processedImage = nil
        currentEffect = nil
    }
}

struct FilterButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(color)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(minWidth: 100)
        }
        .buttonStyle(.bordered)
    }
}
