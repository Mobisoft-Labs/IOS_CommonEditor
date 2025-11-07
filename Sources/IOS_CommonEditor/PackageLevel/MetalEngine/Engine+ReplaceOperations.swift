//
//  Engine+ParentOperations.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

// functionality to add text or sticker
extension MetalEngine{
    
    // Method to replace a sticker image with a new image model
    func replaceSticker(imageModel: ImageModel, currentModel: StickerInfo) {
        if imageModel.sourceType == .SERVER {
            // Check if the server paths match
            if imageModel.serverPath == currentModel.serverPath {
                // Only crop the image
            } else {
                // Update the image properties in the database
            }
        } else {
            // Check if the local paths match
            if imageModel.localPath == currentModel.localPath {
                // Only crop the image
            } else {
                // Handle different local path case
            }
        }
    }
}
