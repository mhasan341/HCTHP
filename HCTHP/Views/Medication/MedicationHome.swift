//
//  MedicationHome.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-17.
//

import SwiftUI

struct MedicationHome: View {
    @StateObject private var drugVM = DrugVM()
    

    var body: some View {
        NavigationStack {
            if let userDrugs = drugVM.savedDrugs {
                List(userDrugs.data) { item in
                    MedicationItem(medineName: item.name)
                }
                .refreshable {
                    Task {
                        await drugVM.getUserDrugs()
                    }

                }
                .navigationTitle("My Medications")
            } else {
                ContentUnavailableView("Sorry we couldn't find any saved drug", image: "drug", description: nil)
            }


        }
        
    }

    
}
