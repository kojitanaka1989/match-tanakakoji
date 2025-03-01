//
//  UserSearchView.swift
//  match-tanakakoji
//
//  Created by 田中康志 on 2025/03/01.
//

//import SwiftUI
//import FirebaseFirestore
//
//struct UserSearchView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var searchQuery: String = ""
//    @State private var users: [User] = []
//
//    var filteredUsers: [User] {
//        if searchQuery.isEmpty {
//            return users
//        } else {
//            return users.filter { $0.name.contains(searchQuery) }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("検索キーワードを入力", text: $searchQuery)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                    .onChange(of: searchQuery) { _ in
//                        fetchUsers() // 🔹 入力時に検索
//                    }
//
//                List(filteredUsers) { user in
//                    VStack(alignment: .leading) {
//                        Text(user.name)
//                            .font(.headline)
//                        Text("\(user.age)歳・\(user.gender)・\(user.prefecture) \(user.city)")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        Text(user.bio)
//                            .font(.body)
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.vertical, 5)
//                }
//                .navigationTitle("ユーザー検索")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button("閉じる") {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                fetchUsers() // 🔹 画面表示時にユーザー一覧を取得
//            }
//        }
//    }
//
//    // 🔹 Firestore からユーザー情報を取得
//    func fetchUsers() {
//        let db = Firestore.firestore()
//        db.collection("users")
//            .order(by: "timestamp", descending: true) // 🔹 最新順
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("ユーザー情報の取得に失敗しました: \(error.localizedDescription)")
//                    return
//                }
//                
//                if let snapshot = snapshot {
//                    users = snapshot.documents.compactMap { doc in
//                        let data = doc.data()
//                        return User(
//                            id: doc.documentID,
//                            name: data["name"] as? String ?? "不明",
//                            age: data["age"] as? Int ?? 18,
//                            gender: data["gender"] as? String ?? "未設定",
//                            prefecture: data["prefecture"] as? String ?? "未設定",
//                            city: data["city"] as? String ?? "未設定",
//                            disability: data["disability"] as? String ?? "未設定",
//                            bio: data["bio"] as? String ?? "自己紹介なし"
//                        )
//                    }
//                }
//            }
//    }
//}
//
//// 🔹 ユーザーデータ構造
//struct User: Identifiable {
//    var id: String
//    var name: String
//    var age: Int
//    var gender: String
//    var prefecture: String
//    var city: String
//    var disability: String
//    var bio: String
//}
