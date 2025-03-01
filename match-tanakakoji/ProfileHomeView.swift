import SwiftUI
import FirebaseAuth

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
        .navigationBarTitle("マイページ", displayMode: .inline)
    }
}

// 検索ページビュー
struct UserSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("検索キーワードを入力", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    Text("検索結果がここに表示されます")
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
    }
}

// メニューのUIコンポーネント
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

// 仮のビュー（エラー回避用）
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

