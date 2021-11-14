//
//  ProfileScreen.swift
//  The Games
//
//  Created by William Santoso on 15/08/21.
//

import SwiftUI

struct ProfileScreen: View {
    @Environment(\.openURL) var openURL
    @State var isEditProfileShown = false
    @AppStorage("name") var name: String = "William Santoso"
    @AppStorage("github") var github: String = "https://github.com/williamsantoso93"
    @AppStorage("linkedin") var linkedin: String = "https://www.linkedin.com/in/williamsantoso93/"
    @AppStorage("instagram") var instagram: String = "https://www.instagram.com/william.santoso93/"
    @AppStorage("image") var imageData: Data?
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                if let uiimage = UIImage(data: imageData ?? Data()) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .frame(height: 125)
                        .clipShape(Circle())
                } else {
                    Image("profile")
                        .resizable()
                        .frame(height: 125)
                        .clipShape(Circle())
                }
                Text(name)
                    .bold()
                    .font(.title)
                    .lineLimit(2)
                    .width(UIScreen.main.bounds.width - 125 - 40)
                    .fixedSize(horizontal: true, vertical: true)
                Spacer(minLength: 0)
            }
            HStack(spacing: 40) {
                if !github.isEmpty {
                    Button {
                        goToURL(github)
                    } label: {
                        SocialMediaIcon(iconName: "github")
                    }
                }
                if !linkedin.isEmpty {
                    Button {
                        goToURL(linkedin)
                    } label: {
                        SocialMediaIcon(iconName: "linkedin")
                    }
                }
                if !instagram.isEmpty {
                    Button {
                        goToURL(instagram)
                    } label: {
                        SocialMediaIcon(iconName: "instagram")
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarItems(trailing:
                                Button {
                                    isEditProfileShown.toggle()
                                } label: {
                                    Text("Edit")
                                }
        )
        .sheet(isPresented: $isEditProfileShown, content: {
            EditProfileScreen(name: name, github: github, linkedin: linkedin, instagram: instagram, imageData: imageData)
        })
    }
    func goToURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        openURL(url)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileScreen()
        }
    }
}

struct SocialMediaIcon: View {
    var iconName: String
    var body: some View {
        Image(iconName)
            .resizable()
            .scaledToFit()
            .padding(5)
            .background(Color.white)
            .cornerRadius(10)
            .frame(width: 75, height: 75)
            .shadow(color: .primary.opacity(0.25), x: 2, y: 3, blur: 5)
    }
}
