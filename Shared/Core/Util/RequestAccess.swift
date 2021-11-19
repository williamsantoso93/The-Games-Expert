//
//  RequestAccess.swift
//  Otospector DealerApp
//
//  Created by William Santoso on 07/07/21.
//

import SwiftUI
import Photos
import AVFoundation

enum RequestType {
    case photos
    case camera
}

enum RequestResult {
    case success
    case notAllow
    case decline
}

class RequestAccess {
    static func alertAccess(_ type: RequestType) -> Alert {
        switch type {
        case .photos:
            return Alert(title: Text("The Games does not have access to your photos. To enable access, tap settings and turn on photos"), primaryButton: .cancel(), secondaryButton: .default(Text("Settings"), action: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
        case .camera:
            return Alert(title: Text("The Games does not have access to your camera. To enable access, tap settings and turn on camera"), primaryButton: .cancel(), secondaryButton: .default(Text("Settings"), action: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
        }
    }
    
    static func cameraAccess(completion: @escaping (RequestResult) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isSuccess in
                completion(isSuccess ? .success : .notAllow)
            }
        case .denied, .restricted:
            completion(.decline)
        case .authorized:
            completion(.success)
        @unknown default:
            completion(.decline)
        }
    }
}
