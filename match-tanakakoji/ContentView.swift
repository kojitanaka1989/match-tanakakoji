//
//  ContentView.swift
//  match-tanakakoji
//
//  Created by 田中康志 on 2025/02/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isRegistered = false  // 登録成功時に画面遷移するためのフラグ
    @FocusState private var isEmailFieldFocused: Bool // キーボードのフォーカス管理

    var body: some View {
        NavigationStack {
            ZStack {
                // 🍀 幸せを呼ぶ四葉のクローバーの背景画像
                Image("clover_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3) // 画像の透明度を調整

                VStack(spacing: 20) {
                    // 🍀 四葉のクローバーアイコンに変更
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)

                    Text("ようこそ！")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("ステキなであいをみつけよう🍀")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    VStack(spacing: 15) {
                        TextField("メールアドレス", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .focused($isEmailFieldFocused)

                        SecureField("パスワード", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .textContentType(.password)
                    }
                    .padding(.horizontal, 20)

                    VStack(spacing: 10) {
                        Button(action: registerUser) {
                            Text("登録する")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: loginUser) {
                            Text("ログインする")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)

                    Text(message)
                        .foregroundColor(.red)
                        .bold()

                    Spacer()
                }
                .padding()
            }
            .onAppear {
                isEmailFieldFocused = true  // 画面表示時にキーボードを開く
            }
            // 登録・ログイン成功後に HomeView へ遷移
            .navigationDestination(isPresented: $isRegistered) {
                HomeView()
            }
        }
    }

    // ユーザー登録処理
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "登録失敗: \(error.localizedDescription)"
            } else {
                message = "登録成功！"
                isRegistered = true  // 登録成功時に HomeView へ遷移
            }
        }
    }

    // ログイン処理
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "ログイン失敗: \(error.localizedDescription)"
            } else {
                message = "ログイン成功！"
                isRegistered = true  // ログイン成功時に HomeView へ遷移
            }
        }
    }
}

