//
//  DrugIcon.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-22.
//

import SwiftUI

struct DrugIcon: View {
    /// width or height, icon will be square sized
    var withSize: CGFloat

    var body: some View {
        Image("drug_icon")
            .resizable()
            .frame(width: withSize, height: withSize)
    }
}
