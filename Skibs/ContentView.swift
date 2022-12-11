//
//  ContentView.swift
//  Skibs
//
//  Created by Shaurya Gupta on 2022-12-03.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
import RiveRuntime

struct ContentView: View {
    @AppStorage("email") private var email: String = ""
    @State private var password = ""
    @State private var wrongEmail = 0
    @State private var wrongPass = 0
    @State private var errorMess: String = ""
    @State public var userUID = ""
    let db = Firestore.firestore()
    @AppStorage("isLoggedIn") var isLoggedIn = false
    public
    var body: some View {
        if isLoggedIn {
            Schedules()
        } else {
            login
        }
    }
    
    var login: some View {
        ZStack {
            Image("bg")
                .resizable()
                .opacity(0.3)
                .ignoresSafeArea()
            RiveViewModel(fileName: "shapes").view()
                .ignoresSafeArea(.all)
                .blur(radius: 30)
                .opacity(0.8)
            VStack {
                Image("calendarImage")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 400, height: 300)
                    .padding(.bottom,450)
            }
            
            Text("Log In or Sign Up")
                .ignoresSafeArea()
                .font(.custom("Oswald", size: 40, relativeTo: .largeTitle))
                .fontWeight(.black)
                .padding(.trailing,30)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .padding()
                .frame(width: 300, height: 52)
                .background(Color.black.opacity(0.08))
                .cornerRadius(10)
                .border(Color(.systemRed), width: CGFloat(wrongEmail))
                .padding(.top, 100)
                .padding(.leading, -10)
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .frame(width: 300, height: 52)
                .background(Color.black.opacity(0.08))
                .cornerRadius(10)
                .border(Color(.systemRed), width: CGFloat(wrongPass))
                .padding(.top, 250)
                .padding(.leading, -10)
            
            Text(errorMess)
                .foregroundColor(Color(.systemRed))
                .font(.custom("Oswald", size: 20, relativeTo: .title3))
                .padding(.top, 350)
            
            Button {
                UIApplication.shared.closeKeyboard()
                logIn(email: email, password: password)
            } label: {
                HStack(spacing: 15) {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .contentTransition(.identity)
                        .foregroundColor(Color(.black))
                    
                    Image(systemName: "arrow.right")
                        .font(.title)
                        .padding(.leading, -5)
                        .foregroundColor(Color(.black))
                }
                .frame(width: 300)
                .foregroundColor(.black)
                .padding(.horizontal, 25)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.black).opacity(0.08))
                }
            }
            .padding(.top, 450)
            
            Button {
                DispatchQueue.main.async {
                    createAccount(email: email, password: password)
                }
                UIApplication.shared.closeKeyboard()
            } label: {
                HStack(spacing: 15) {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .contentTransition(.identity)
                        .foregroundColor(Color(.black))
                    
                    Image(systemName: "arrow.right")
                        .font(.title)
                        .padding(.leading, -5)
                        .foregroundColor(Color(.black))
                }
                .frame(width: 300)
                .foregroundColor(.black)
                .padding(.horizontal, 25)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.black).opacity(0.08))
                }
            }
            .padding(.top, 600)
            
            Button {
                Auth.auth().sendPasswordReset(withEmail: email) { err in
                    if err != nil {
                        errorMess = err!.localizedDescription
                    }
                }
            } label: {
                Text("Forgot Password")
                    .font(.custom("Oswald", size: 20, relativeTo: .title2))
                    .padding(.top, 700)
                    .padding(.trailing, 230)
            }

            
        }
    }
    
 
    
    func createAccount(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            
            if err != nil {
                wrongPass = 2
                wrongEmail = 2
                errorMess = err?.localizedDescription ?? ""
                DispatchQueue.main.async {
                    withAnimation {
                        isLoggedIn = false
                    }
                }
            } else {
                wrongPass = 0
                wrongEmail = 0
                errorMess = ""
                DispatchQueue.main.async {
                    withAnimation {
                        isLoggedIn = true
                    }
                }
            }
        }
    }
    
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if err != nil {
                wrongPass = 2
                wrongEmail = 2
                errorMess = err?.localizedDescription ?? ""
                DispatchQueue.main.async {
                    withAnimation {
                        isLoggedIn = false
                    }
                }
            } else {
                wrongPass = 0
                wrongEmail = 0
                errorMess = ""
                DispatchQueue.main.async {
                    withAnimation {
                        isLoggedIn = true
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: Close Keyboard
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Root Controller
    func rootController()->UIViewController {
        guard let window = connectedScenes.first as? UIWindowScene else { return .init() }
        guard let viewController = window.windows.last?.rootViewController else {return .init()}
        
        return viewController
    }
}
