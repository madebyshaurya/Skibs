//
//  Schedules.swift
//  Skibs
//
//  Created by Shaurya Gupta on 2022-12-04.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
struct Schedules: View {
    let contentView = ContentView()
    @State var isEditing = false
    @State var startTime: String = ""
    @State var endTime: String = ""
    @State var array: [String] = []
    @State var dicData: [String: String]?
    @State var times: [String] = []
    @State var singleArray: String = ""
    @State var time: String = ""
    let db = Firestore.firestore()
    let userEmail = Auth.auth().currentUser?.email
    var body: some View {
        if isEditing == false {
            NavigationView {
                ZStack {
                    Image("bg")
                        .resizable()
                        .opacity(0.3)
                        .ignoresSafeArea()
                    
                    
                    TabView {
//                            ForEach(array, id: \.self) { title in
//                                ForEach(times, id: \.self) { time in
                                    ZStack {
                                        Color.red
                                        Text("Hello")
                                    }
//                                }
//                            }
                    }
                    .tabViewStyle(.page)
                    .navigationTitle("Schedules")
                    .toolbar {
                        
                        Button {
                            withAnimation(.easeIn){
                                isEditing = true
                            }
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 26, height: 26)
                        }
                        
                        Button(action: {
                            do {
                                contentView.isLoggedIn = false
                                try Auth.auth().signOut()
                            } catch {
                                print(error)
                            }
                        }, label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        })
                        .tint(.red)
                        
                    }
                    
                }
            }
        } else {
            edit
        }
    }
    
    // MARK: Edit
    var edit: some View {
        VStack {
            Spacer()
            VStack {
                Image("editPic")
                    .padding(.bottom, 150)
            }
            VStack {
                VStack {
                    VStack {
                        Text("Free from:")
                            .fontWeight(.bold)
                            .padding(.trailing, 200)
                        
                        TextField("10:00 AM", text: $startTime)
                            .textContentType(.dateTime)
                            .padding()
                            .frame(width: 300, height: 52)
                            .background(Color.black.opacity(0.08))
                            .cornerRadius(10)
                            .padding(.leading, -10)
                    }
                    VStack {
                        Text("To:")
                            .fontWeight(.bold)
                            .padding(.trailing, 250)
                            .padding(.top, 20)
                        TextField("12:00 PM", text: $endTime)
                            .textContentType(.emailAddress)
                            .padding()
                            .frame(width: 300, height: 52)
                            .background(Color.black.opacity(0.08))
                            .cornerRadius(10)
                            .padding(.leading, -10)
                    }
                }
                .padding(.top, 250)
                Spacer()
                HStack {
                    Button {
                        setData(startTime: startTime, endTime: endTime)
                        withAnimation(.easeOut) {
                            isEditing = false
                        }
                    } label: {
                        HStack(spacing: 15) {
                            Text("Save")
                                .fontWeight(.semibold)
                                .contentTransition(.identity)
                                .font(.title2)
                                .foregroundColor(Color(.black))
                            
                            Image(systemName: "square.and.arrow.down")
                                .font(.title)
                                .padding(.leading, -5)
                                .padding(.bottom, 6)
                                .foregroundColor(Color(.black))
                        }
                        .frame(width: 225)
                        .foregroundColor(.black)
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(.black).opacity(0.08))
                        }
                    }
                    .padding(.trailing, -25)
                    
                    Button {
                        withAnimation(.easeOut) {
                            isEditing = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "xmark.app.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color(.black))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(.red).opacity(0.08))
                        }
                        
                    }
                    .padding(.leading, 30)
                }
            }
            .padding(.top, -350)
            Spacer()
        }
    }
    func setData(startTime: String, endTime: String) {
        db.collection("schedules").document(userEmail!).updateData([
            "Free": "\(startTime) - \(endTime)"
        ]) { err in
            if err != nil {
                db.collection("schedules").document(userEmail!).setData([
                    "Free": "\(startTime) - \(endTime)"
                ])
            }
        }
    }
    
    func getDocumentTitle() /*-> [String]*/ {
        db.collection("schedules")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                            array.append(document.documentID)
                            print(array)
                    }
                }
            }
//        return array!
    }
    
    func getDocumentData() /*-> [String]*/ {
        db.collection("schedules")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        dicData = document.data() as? [String: String]
                        times.append(contentsOf: dicData!.values)
                    }
                }
                print(times)
            }
//        return times!
    }
}
struct Schedules_Previews: PreviewProvider {
    static var previews: some View {
        Schedules()
    }
}
