//
//  SettingsPageView.swift
//  Swift Belay
//
//  Created by William Yang on 2/6/23.
//

import SwiftUI

struct SettingsPageView: View {
    let user: User
    
    var body: some View {
        List {
            Section(header: Text("Account")) {
                NavigationLink(destination: AccountDetailView(user: user)) {
                    Label("Account info", systemImage: "person")
                }
                Label("Preferences", systemImage: "slider.vertical.3")
            }
            Section(header: Text("General")) {
                Label("Settings", systemImage: "gear")
                Label("Notifications", systemImage: "bell.badge")
                Label("Privacy", systemImage: "hand.raised")
                Label("Appearance", systemImage: "paintpalette")
                Label("Help and Support", systemImage: "questionmark")
                Label("About", systemImage: "info.circle")
            }
        }
    }
}

struct SettingsPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsPageView(user: User.testUser)
        }
    }
}
