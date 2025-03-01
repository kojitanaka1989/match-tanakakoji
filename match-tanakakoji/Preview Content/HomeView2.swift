import SwiftUI
import FirebaseStorage
import PhotosUI

struct HomeView2: View {
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isShowingCameraPicker = false
    @State private var uploadStatus: String = ""
    @State private var imageURL: URL?
    @State private var selectedDocumentType = "障害者手帳"
    @State private var navigateToProfileHome = false
    
    let documentTypes = ["障害者手帳", "障害者受給者証"]
    
    var body: some View {
        VStack {
            Text("身分証のアップロード")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Picker("書類の種類", selection: $selectedDocumentType) {
                ForEach(documentTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
            } else {
                //  見本の写真を表示Image
                HStack {
                    Image("sample_document2")
                        .resizable()
                        .scaledToFit()
                    Image("sample_document") // Assetsに追加した見本画像を表示
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 200)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Button("ライブラリから選択") {
                    isShowingImagePicker = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("カメラを使用") {
                    isShowingCameraPicker = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            
            Button(action: uploadImage) {
                Text("アップロード")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .disabled(selectedImage == nil)
            
            Text(uploadStatus)
                .foregroundColor(.red)
                .padding()
            
            if let imageURL = imageURL {
                Text("アップロード完了: \(imageURL.absoluteString)")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding()
            }
            
            // NavigationLink で ProfileHomeView へ遷移
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
                        .background(imageURL == nil ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .disabled(imageURL == nil) // アップロード完了しないと無効化
            }
            
            Spacer()
        }
        .sheet(isPresented: $isShowingImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        })
        .sheet(isPresented: $isShowingCameraPicker, content: {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        })
    }
    
    func uploadImage() {
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.8) else {
            uploadStatus = "画像を選択してください"
            return
        }
        
        let folderName = selectedDocumentType == "障害者手帳" ? "disability_cards" : "recipient_certificates"
        let storageRef = Storage.storage().reference().child("\(folderName)/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                uploadStatus = "アップロード失敗: \(error.localizedDescription)"
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    uploadStatus = "URL取得失敗: \(error.localizedDescription)"
                    return
                }
                
                imageURL = url
                uploadStatus = "アップロード完了"
            }
        }
    }
}

// 画像ピッカーの実装
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
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

