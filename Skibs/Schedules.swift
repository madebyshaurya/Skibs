//
//  Schedules.swift
//  Skibs
//
//  Created by Shaurya Gupta on 2022-12-04.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreSwift
struct Schedules: View {
    let contentView = ContentView()
    var body: some View {
        NavigationView {
            List(content: {
                // Schedules
            })
                .navigationBarTitle("Schedules", displayMode: .automatic)
                .toolbar {
                    
                    Button(action: {
                        do {
                            contentView.isLoggedIn = false
                            try withAnimation(.easeOut) {
                                try Auth.auth().signOut()
                            }
                        } catch {
                            print(error)
                        }
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    })
                }
                .tint(.red)
        }
    }
}

struct Schedules_Previews: PreviewProvider {
    static var previews: some View {
        Schedules()
    }
}
