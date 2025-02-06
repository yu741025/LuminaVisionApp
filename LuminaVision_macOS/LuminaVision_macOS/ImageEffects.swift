//
//  ImageEffects.swift
//  LuminaVision_macOS
//
//  Created by YOU SHU-YU on 2025/2/6.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageEffects {
    // 夢幻時光 - 柔和夢幻效果
    static func applyDreamyEffect(to image: NSImage) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // 溫和的柔焦
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(2.0, forKey: kCIInputRadiusKey)
        
        // 柔和的色彩調整
        guard let colorControls = CIFilter(name: "CIColorControls") else { return nil }
        colorControls.setValue(ciImage, forKey: kCIInputImageKey)
        colorControls.setValue(0.05, forKey: kCIInputBrightnessKey)
        colorControls.setValue(1.05, forKey: kCIInputContrastKey)
        colorControls.setValue(1.02, forKey: kCIInputSaturationKey)
        
        guard let outputImage = colorControls.outputImage,
              let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return NSImage(cgImage: outputCGImage, size: image.size)
    }
    
    // 復古印記 - 溫暖復古效果
    static func applyVintageEffect(to image: NSImage) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // 復古色調
        guard let sepia = CIFilter(name: "CISepiaTone") else { return nil }
        sepia.setValue(ciImage, forKey: kCIInputImageKey)
        sepia.setValue(0.6, forKey: kCIInputIntensityKey)
        
        // 添加復古質感
        guard let colorControls = CIFilter(name: "CIColorControls") else { return nil }
        colorControls.setValue(sepia.outputImage, forKey: kCIInputImageKey)
        colorControls.setValue(0.95, forKey: kCIInputSaturationKey)
        colorControls.setValue(1.1, forKey: kCIInputContrastKey)
        
        guard let outputImage = colorControls.outputImage,
              let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return NSImage(cgImage: outputCGImage, size: image.size)
    }
    
    // 月光剪影 - 優雅的黑白藝術效果
    static func applyWatercolorEffect(to image: NSImage) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // 步驟1：黑白處理
        guard let monoFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        monoFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // 步驟2：增強對比度
        guard let colorControls = CIFilter(name: "CIColorControls") else { return nil }
        colorControls.setValue(monoFilter.outputImage, forKey: kCIInputImageKey)
        colorControls.setValue(1.2, forKey: kCIInputContrastKey)
        
        // 步驟3：邊緣強化
        guard let edges = CIFilter(name: "CIEdgeWork") else { return nil }
        edges.setValue(colorControls.outputImage, forKey: kCIInputImageKey)
        edges.setValue(2.0, forKey: kCIInputRadiusKey)
        
        guard let outputImage = edges.outputImage,
              let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return NSImage(cgImage: outputCGImage, size: image.size)
    }
    
    // 真實水彩 - 柔和水彩暈染效果
    static func applyRealWatercolorEffect(to image: NSImage) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // 步驟1：色彩柔化
        guard let colorControls = CIFilter(name: "CIColorControls") else { return nil }
        colorControls.setValue(ciImage, forKey: kCIInputImageKey)
        colorControls.setValue(1.2, forKey: kCIInputSaturationKey)
        colorControls.setValue(0.8, forKey: kCIInputContrastKey)
        
        // 步驟2：添加水彩暈染效果
        guard let blur = CIFilter(name: "CIGaussianBlur") else { return nil }
        blur.setValue(colorControls.outputImage, forKey: kCIInputImageKey)
        blur.setValue(3.0, forKey: kCIInputRadiusKey)
        
        // 步驟3：添加紙張紋理
        guard let crystallize = CIFilter(name: "CICrystallize") else { return nil }
        crystallize.setValue(blur.outputImage, forKey: kCIInputImageKey)
        crystallize.setValue(20.0, forKey: kCIInputRadiusKey)
        
        // 步驟4：柔化邊緣
        guard let bloom = CIFilter(name: "CIBloom") else { return nil }
        bloom.setValue(crystallize.outputImage, forKey: kCIInputImageKey)
        bloom.setValue(3.0, forKey: "inputRadius")
        bloom.setValue(0.5, forKey: "inputIntensity")
        
        guard let outputImage = bloom.outputImage,
              let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return NSImage(cgImage: outputCGImage, size: image.size)
    }
    
    // 油畫印象 - 細膩油畫效果
    static func applyOilPaintingEffect(to image: NSImage) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // 步驟1：色彩分段
        guard let posterize = CIFilter(name: "CIColorPosterize") else { return nil }
        posterize.setValue(ciImage, forKey: kCIInputImageKey)
        posterize.setValue(6.0, forKey: "inputLevels")
        
        // 步驟2：邊緣強化
        guard let edges = CIFilter(name: "CIEdges") else { return nil }
        edges.setValue(posterize.outputImage, forKey: kCIInputImageKey)
        edges.setValue(2.0, forKey: kCIInputIntensityKey)
        
        // 步驟3：混合原圖
        guard let blend = CIFilter(name: "CISourceOverCompositing") else { return nil }
        blend.setValue(edges.outputImage, forKey: kCIInputImageKey)
        blend.setValue(posterize.outputImage, forKey: kCIInputBackgroundImageKey)
        
        // 步驟4：最終調整
        guard let colorControls = CIFilter(name: "CIColorControls") else { return nil }
        colorControls.setValue(blend.outputImage, forKey: kCIInputImageKey)
        colorControls.setValue(1.2, forKey: kCIInputSaturationKey)
        colorControls.setValue(1.1, forKey: kCIInputContrastKey)
        
        guard let outputImage = colorControls.outputImage,
              let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return NSImage(cgImage: outputCGImage, size: image.size)
    }
    
    // 童話色彩 - 夢幻童話效果
    static func applyFairyTaleEffect(to image: NSImage) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // 步驟1：提亮色彩
        guard let colorControls = CIFilter(name: "CIColorControls") else { return nil }
        colorControls.setValue(ciImage, forKey: kCIInputImageKey)
        colorControls.setValue(1.2, forKey: kCIInputSaturationKey)
        colorControls.setValue(0.1, forKey: kCIInputBrightnessKey)
        
        // 步驟2：添加夢幻光暈
        guard let bloom = CIFilter(name: "CIBloom") else { return nil }
        bloom.setValue(colorControls.outputImage, forKey: kCIInputImageKey)
        bloom.setValue(2.5, forKey: kCIInputRadiusKey)
        bloom.setValue(0.5, forKey: kCIInputIntensityKey)
        
        guard let outputImage = bloom.outputImage,
              let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return NSImage(cgImage: outputCGImage, size: image.size)
    }
}
