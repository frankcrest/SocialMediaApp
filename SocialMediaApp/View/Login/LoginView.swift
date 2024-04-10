//
//  LoginView.swift
//  SocialMediaApp
//
//  Created by Frank Chen on 2024-03-30.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    // MARK: UserDetails
    @State var emailID: String = ""
    @State var password: String = ""
    // MARK: View Properties
    @State var createdAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    // MARK: User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Lets Sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome Back, \n You have been m isde")
                .font(.title3)
                .hAlign(.leading)
            
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                
                HelperView()
            }
            
            // MARK: Register Button
            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(.gray)
                
                Button("Register Now") {
                    createdAccount.toggle()
                }.fontWeight(.bold)
                    .foregroundStyle(.black)
            }
            .font(.callout)
            .VAlign(.bottom)
        }
        .VAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        //MARK: Register View VIA Sheets
        .fullScreenCover(isPresented: $createdAccount) {
            RegisterView()
        }
        .alert(errorMessage, isPresented: $showError) {
            
        }
    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User found")
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    // MARK: If User is found then fetching user data from Firestore
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // MARK: UI Updating Must be run on the Main thread
        await MainActor.run {
            // Setting UserDefaults data and Changing App's Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        }
    }
    
    func resetPassword() {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            } catch {
                await setError(error)
            }
        }
    }
    
    // MARK: Displaiying Erros VIA Alert
    
    func setError(_ error: Error) async {
        await MainActor.run {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        }
    }
    
    @ViewBuilder func HelperView() -> some View {
        VStack(spacing:12) {
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, color: .gray.opacity(0.5))
                .padding(.top, 25)
            
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, color: .gray.opacity(0.5))
            
            Button("Reset password?") {
                resetPassword()
            }
            .font(.callout)
            .fontWeight(.medium)
            .tint(.black)
            .hAlign(.trailing)
            
            Button {
                loginUser()
            } label: {
                Text("Sign in")
                    .foregroundStyle(.white)
                    .hAlign(.center)
                    .fillView(color: .black)
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    RegisterView()
}
