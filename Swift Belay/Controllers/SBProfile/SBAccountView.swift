//
//  SwiftUIView.swift
//  Swift Belay
//
//  Created by William Yang on 2/27/23.
//

import SwiftUI

struct AccountDetailView: View {
    let user: BelayUser
    var body: some View {
        List {
            Text(user.firstName)
            Text(user.lastName)
        }
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(user: BelayUser.testUser)
    }
}
