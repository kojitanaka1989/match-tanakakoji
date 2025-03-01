import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = "ゲスト"
    @State private var bio: String = "自己紹介を追加してください"
    @State private var age: Int = 18
    @State private var selectedGender = "未設定"
    @State private var selectedPrefecture = "北海道"
    @State private var selectedCity = "札幌市中央区"
    @State private var selectedDisability = "未設定"
    @State private var profileImage: UIImage? = UIImage(named: "default_profile")
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var selectedImage: UIImage?
    @State private var isShowingPhotoOptions = false
    @State private var navigateToProfileHome = false

    let genders = ["未設定", "男性", "女性", "その他"]
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
    
    let citiesByPrefecture: [String: [String]] = [
        "北海道": ["札幌市中央区", "札幌市北区", "函館市", "旭川市"],
        "東京都": ["千代田区", "中央区", "港区", "新宿区"]
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("ようこそ！")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("ステキなであいをみつけよう🎉")
                .font(.subheadline)
                .foregroundColor(.gray)
            
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
                
                Text("性別")
                    .font(.headline)
                Picker("性別を選択", selection: $selectedGender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Text("都道府県")
                    .font(.headline)
                Picker("都道府県を選択", selection: $selectedPrefecture) {
                    ForEach(prefectures, id: \.self) { prefecture in
                        Text(prefecture).tag(prefecture)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedPrefecture) { newPrefecture in
                    selectedCity = citiesByPrefecture[newPrefecture]?.first ?? "未設定"
                }
                .padding(.horizontal)
                
                Text("市町村")
                    .font(.headline)
                Picker("市町村を選択", selection: $selectedCity) {
                    ForEach(citiesByPrefecture[selectedPrefecture] ?? ["未設定"], id: \.self) { city in
                        Text(city).tag(city)
                    }
                }
                .pickerStyle(MenuPickerStyle())
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
            
            NavigationLink(
                destination: ProfileHomeView(),
                isActive: $navigateToProfileHome
            ) {
                Button(action: {
                    navigateToProfileHome = true
                }) {
                    Text("登録完了")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

