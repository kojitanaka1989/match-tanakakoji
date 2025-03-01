import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isRegistered = false  // 登録成功時に画面遷移するためのフラグ
    @FocusState private var isEmailFieldFocused: Bool // キーボードのフォーカス管理
    @FocusState private var isPasswordFieldFocused: Bool // パスワードフィールドのフォーカス管理

    var body: some View {
        NavigationStack {
            ZStack {
                // 🔹 背景画像の追加（全画面表示）
                Image("sample_document3") // `Assets.xcassets` に追加した画像の名前
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()

                // 🔹 半透明のオーバーレイを追加して見やすくする
                Color.black.opacity(0.3)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // 🍀 四葉のクローバーアイコン（デザイン変更）
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)

                    Text("ようこそ！")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("ステキなであいをみつけよう🍀")
                        .font(.subheadline)
                        .foregroundColor(.white)

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
                            .focused($isPasswordFieldFocused)
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
            // 🔹 `onAppear` を削除して自動フォーカスを防ぐ
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

