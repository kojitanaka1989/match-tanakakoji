import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileHomeView: View {
    @State private var userName: String = "ゲスト"
    @State private var age: Int = 18
    @State private var gender: String = "未設定"
    @State private var location: String = "北海道 札幌市"
    @State private var bio: String = "自己紹介を追加してください"
    @State private var profileImage: UIImage? = UIImage(named: "default_profile")
    @State private var searchText: String = ""
    @State private var isShowingSearchView = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("マイページ")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // プロフィール画像
            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }
            
            Text(userName)
                .font(.title)
                .fontWeight(.bold)
            Text("\(age)歳・\(gender)")
                .foregroundColor(.gray)
            Text(location)
                .foregroundColor(.gray)
            Text(bio)
                .multilineTextAlignment(.center)
                .padding()
            
            Divider()
            
            // 検索ボタン
            Button(action: {
                isShowingSearchView = true
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                    Text("ユーザーを検索")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                .padding(.horizontal)
            }
            .fullScreenCover(isPresented: $isShowingSearchView) {
                UserSearchView()
            }
            
            // メニュー
            VStack(spacing: 10) {
                NavigationLink(destination: MatchListView()) {
                    ProfileMenuItem(title: "マッチリスト", iconName: "heart.fill")
                }
                
                NavigationLink(destination: ChatListView()) {
                    ProfileMenuItem(title: "メッセージ", iconName: "message.fill")
                }
                
                NavigationLink(destination: ProfileEditView()) {
                    ProfileMenuItem(title: "プロフィール編集", iconName: "pencil")
                }
                
                NavigationLink(destination: SettingsView()) {
                    ProfileMenuItem(title: "設定", iconName: "gearshape.fill")
                }
            }
            
            Spacer()
        }
    }
}

// 🔹 検索ページビュー
struct UserSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchQuery: String = ""
    @State private var users: [User] = []
    
    var filteredUsers: [User] {
        if searchQuery.isEmpty {
            return users
        } else {
            return users.filter { user in
                user.name.localizedCaseInsensitiveContains(searchQuery) ||
                user.location.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("検索キーワードを入力", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(filteredUsers) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text("\(user.age)歳・\(user.gender)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(user.location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .navigationTitle("ユーザー検索")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("閉じる") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchUsers()
        }
    }

    // 🔹 Firestore からユーザーを取得する関数
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("データ取得エラー: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self.users = documents.compactMap { doc -> User? in
                let data = doc.data()
                return User(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "未設定",
                    age: data["age"] as? Int ?? 18,
                    gender: data["gender"] as? String ?? "未設定",
                    location: "\(data["prefecture"] as? String ?? "未設定") \(data["city"] as? String ?? "未設定")",
                    bio: data["bio"] as? String ?? "自己紹介なし"
                )
            }
        }
    }
}

// 🔹 Firestore のデータを受け取るための User 構造体
struct User: Identifiable {
    var id: String
    var name: String
    var age: Int
    var gender: String
    var location: String
    var bio: String
}

// 🔹 メニューのUIコンポーネント
struct ProfileMenuItem: View {
    var title: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        .padding(.horizontal)
    }
}

// 🔹 仮のビュー（エラー回避用）
struct MatchListView: View {
    var body: some View {
        Text("マッチリスト画面")
    }
}

struct ChatListView: View {
    var body: some View {
        Text("チャット一覧画面")
    }
}

struct ProfileEditView: View {
    var body: some View {
        Text("プロフィール編集画面")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("設定画面")
    }
}

