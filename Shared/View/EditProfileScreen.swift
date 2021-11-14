//
//  EditProfileScreen.swift
//  The Games (iOS)
//
//  Created by William Santoso on 21/08/21.
//

import SwiftUI
import Photos
import AVFoundation

struct EditProfileScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var name: String = ""
    @State var github: String = ""
    @State var linkedin: String = ""
    @State var instagram: String = ""
    @State var imageData: Data?
    let userDefault = UserDefaults.standard
    @State var isShowImagePicker = false
    @State var isShowAlertRequest = false
    var body: some View {
        NavigationView {
            VStack(spacing: 16.0) {
                HStack(spacing: 16.0) {
                    if let uiimage = UIImage(data: imageData ?? Data()) {
                        Image(uiImage: uiimage)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .clipShape(Circle())
                    } else {
                        Image("profile")
                            .resizable()
                            .frame(width: 125, height: 125)
                            .clipShape(Circle())
                    }
                    Button {
                        showImagePicker()
                    } label: {
                        Text("Edit Profile Image")
                    }
                    .padding(.top, 4)
                    Spacer()
                }
                TitleTextField(title: "Name", text: $name, placeHolder: "William Santoso")
                TitleTextField(title: "Github", text: $github, placeHolder: "https://github.com/williamsantoso93")
                TitleTextField(title: "LinkedIn", text: $linkedin, placeHolder: "https://www.linkedin.com/in/williamsantoso93/")
                TitleTextField(title: "Instagram", text: $instagram, placeHolder: "https://www.instagram.com/william.santoso93/")
                Spacer()
            }
            .padding()
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    Button {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Text("Cancel")
                                    },
                                trailing:
                                    Button {
                                        userDefault.set(name, forKey: "name")
                                        userDefault.set(github, forKey: "github")
                                        userDefault.set(linkedin, forKey: "linkedin")
                                        userDefault.set(instagram, forKey: "instagram")
                                        if let imageData = imageData {
                                            userDefault.set(imageData, forKey: "image")
                                        }
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Text("Save")
                                    }
            )
            .sheet(isPresented: $isShowImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    DispatchQueue.main.async {
                        if let data = image?.jpegData(compressionQuality: 1) {
                            imageData = data
                        }
                        isShowImagePicker = false
                    }
                }
            }
            .alert(isPresented: $isShowAlertRequest, content: {
                Alert(title: Text("The Games does not have access to your photos. To enable access, tap settings and turn on photos"), primaryButton: .cancel(), secondaryButton: .default(Text("Settings"), action: {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }))
            })
        }
    }
    
    func showImagePicker() {
        photosAccess { status in
            switch status {
            case .success:
                isShowImagePicker.toggle()
            case .notAllow:
                break
            case .decline:
                isShowAlertRequest.toggle()
            }
        }
    }
    
    func photosAccess(completion: @escaping (RequestResult) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .notDetermined, .restricted, .denied:
                    completion(.notAllow)
                case .authorized, .limited:
                    completion(.success)
                @unknown default:
                    completion(.notAllow)
                }
            }
        case .denied, .restricted:
            completion(.decline)
        case .authorized, .limited:
            completion(.success)
        @unknown default:
            completion(.decline)
        }
    }
}

struct EditProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileScreen()
    }
}

struct TitleTextField: View {
    var title: String
    @Binding var text: String
    var placeHolder: String
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text(title)
            TextField(placeHolder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
