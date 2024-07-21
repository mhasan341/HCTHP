//
//  ScrollableContentNotAvailableView.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-22.
//

import SwiftUI

struct ScrollableContentNotAvailableView: View {

    var contentTitle: String
    var contentDescription: String?
    /// pills.circle is default
    var systemImage: String = "pills.circle"

    var body: some View {
        ScrollView {
            // scrollView tightens view, so we want to put some space
            Spacer(minLength: 200)
            // we may opt for a system image as well
            //ContentUnavailableView("You don't have any medications to show", image: "drug_icon", description: nil)
            // Actuall this looks better
            // force unwrapping an optional won't cause an issue as we are checking first if it's not nil then we are force unwrapping
            ContentUnavailableView(contentTitle, systemImage: systemImage, description: contentDescription != nil ? Text(contentDescription!) : nil)
        }
    }
}
