//
//  ContentView.swift
//  Skibs
//
//  Created by Shaurya Gupta on 2022-12-03.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var wrongEmail = 0
    @State private var wrongPass = 0
    @State private var errorMess: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false
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
