//
//  HomeView.swift
//  match-tanakakoji
//
//  Created by 田中康志 on 2025/02/23.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode // 画面を戻るための環境変数
    @State private var name: String = "ゲスト"
    @State private var bio: String = "自己紹介を追加してください"
    @State private var age: Int = 18
    @State private var selectedPrefecture = "東京都"
    @State private var city: String = ""
    @State private var selectedDisability = "未設定"
    @State private var profileImage: UIImage? = UIImage(named: "default_profile") // デフォルト画像
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var selectedImage: UIImage?
    @State private var isShowingPhotoOptions = false // カメラ or フォトライブラリ選択用

    let prefectures = [
        "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
        "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
        "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県",
        "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県",
        "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県",
        "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県",
        "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]
    
    let disabilityTypes = ["未設定", "身体障害", "知的障害", "精神障害"]

    var body: some View {
        VStack(spacing: 20) {
            Text("ようこそ！")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("ステキなであいをみつけよう🎉")
                .font(.subheadline)
                .foregroundColor(.gray)

            // プロフィール画像
            Button(action: {
                isShowingPhotoOptions = true
            }) {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
            }
            .actionSheet(isPresented: $isShowingPhotoOptions) {
                ActionSheet(title: Text("写真を選択"), buttons: [
                    .default(Text("カメラを起動")) {
                        showCameraPicker = true
                    },
                    .default(Text("フォトライブラリから選択")) {
                        showImagePicker = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage, profileImage: $profileImage)
            }
            .sheet(isPresented: $showCameraPicker) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage, profileImage: $profileImage)
            }

            // ユーザー情報編集
            VStack(alignment: .leading, spacing: 10) {
                Text("名前")
                    .font(.headline)
                TextField("名前を入力", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Text("年齢")
                    .font(.headline)
                Picker("年齢を選択", selection: $age) {
                    ForEach(18...99, id: \.self) { age in
                        Text("\(age)歳").tag(age)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 100)
                .padding(.horizontal)

                Text("都道府県")
                    .font(.headline)
                Picker("都道府県を選択", selection: $selectedPrefecture) {
                    ForEach(prefectures, id: \.self) { prefecture in
                        Text(prefecture).tag(prefecture)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)

                Text("市町村")
                    .font(.headline)
                TextField("市町村を入力", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Text("特性（障害の種類）")
                    .font(.headline)
                Picker("特性を選択", selection: $selectedDisability) {
                    ForEach(disabilityTypes, id: \.self) { disability in
                        Text(disability).tag(disability)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Text("自己紹介")
                    .font(.headline)
                TextField("自己紹介を入力", text: $bio)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding()

            // ログアウトボタン
            Button(action: logoutUser) {
                Text("ログアウト")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true) // 戻るボタンを非表示にする
    }

    // ログアウト処理
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            presentationMode.wrappedValue.dismiss() // ログアウト後、前の画面に戻る
        } catch let signOutError as NSError {
            print("ログアウト失敗: \(signOutError.localizedDescription)")
        }
    }
}

// 画像選択用のImagePicker（カメラ＆フォトライブラリ対応）
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Binding var profileImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.profileImage = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

