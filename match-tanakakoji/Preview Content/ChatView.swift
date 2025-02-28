import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
//import FirebaseFirestoreSwift

struct ChatView: View {
    @State private var messageText = "" // 入力するメッセージ
    @State private var messages: [Message] = [] // メッセージ一覧
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            // 📩 チャットのメッセージリスト
            List(messages) { message in
                HStack {
                    if message.isMyMessage {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
            .listStyle(PlainListStyle()) // デフォルトのスタイルを適用

            // ✍️ メッセージ入力エリア
            HStack {
                TextField("メッセージを入力...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Text("送信")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            fetchMessages()
        }
    }

    // 📤 メッセージを送信する処理
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        guard let userID = Auth.auth().currentUser?.uid else {
            print("エラー: ユーザーが認証されていません")
            return
        }

        let newMessage = Message(
            id: UUID().uuidString, // 一意のIDを設定
            text: messageText,
            timestamp: Timestamp(),
            userID: userID
        )

        do {
            try db.collection("messages").document(newMessage.id).setData([
                "text": newMessage.text,
                "timestamp": newMessage.timestamp,
                "userID": newMessage.userID
            ])
            messageText = "" // 送信後、入力欄を空にする
        } catch {
            print("メッセージの保存に失敗: \(error.localizedDescription)")
        }
    }

    // 📥 Firebase からメッセージを取得する処理（リアルタイム更新）
    func fetchMessages() {
        db.collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("エラー: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    self.messages = documents.compactMap { doc in
                        let data = doc.data()
                        let text = data["text"] as? String ?? ""
                        let userID = data["userID"] as? String ?? ""
                        let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                        return Message(id: doc.documentID, text: text, timestamp: timestamp, userID: userID)
                    }
                }
            }
    }
}

// 💬 メッセージのデータモデル
struct Message: Identifiable {
    let id: String
    let text: String
    let timestamp: Timestamp
    let userID: String

    var isMyMessage: Bool {
        return userID == Auth.auth().currentUser?.uid
    }
}

