//
//  LogPassSubView.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 27.09.2021.
//

import SwiftUI
import Combine


struct LogPassSubView: View {
    
    @Binding var isAuthorization: Bool
    @State private var login = ""
    @State private var password = ""
    @State private var unCorrectLoginOrPassword = false
    
    private let keyboardIsOnPublisher = Publishers.Merge(
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .map { _ in true },
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
    )
        .removeDuplicates()
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0, green: 0.415446341, blue: 0.928019166, alpha: 1)).edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer().frame(height: 150)
                    Image("PikPng.com_vk-logo-png_4815508+").resizable().aspectRatio(contentMode: .fill).frame(maxWidth: 130, maxHeight: 130)
                    Spacer().frame(height: 44)
                    VStack(spacing: 5){
                        HStack {
                            Text("Email или телефон").foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            Spacer()
                            Text("a@a.com").foregroundColor(Color(#colorLiteral(red: 0.02752423473, green: 0.1253875196, blue: 0.9329798818, alpha: 1)))
                        }
                        TextField("", text: $login)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .frame(height: 35)
                    }
                    Spacer().frame(height: 20)
                    VStack(spacing: 5){
                        HStack {
                            Text("Пароль").foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                            Spacer()
                            Text("123456789").foregroundColor(Color(#colorLiteral(red: 0.02752423473, green: 0.1253875196, blue: 0.9329798818, alpha: 1)))
                        }
                        TextField("", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .frame(height: 35)
                    }
                }.padding(.leading, 40).padding(.trailing, 40)
                .padding(.top, 30)
                HStack{
                    Spacer().frame(width: 40)
                    GeometryReader { geometry in
                        VStack(alignment: .center) {
                            Button(action:{
                                login = "a@a.com"; password = "123456789"
                                
                                if login != "a@a.com" || password != "123456789" {
                                    unCorrectLoginOrPassword = true
                                }
                                else {
                                    isAuthorization = true
                                }
                            }) {
                                Text("Войти")
                            }
                            .frame(minWidth: geometry.frame(in: .global).size.width, minHeight: 37)
                            .background(Color(#colorLiteral(red: 0.2952880561, green: 0.672848165, blue: 0.818998754, alpha: 1)))
                            .foregroundColor(.white)
                            .disabled(login.isEmpty || password.isEmpty)
                            .alert(isPresented: $unCorrectLoginOrPassword, content: {
                                Alert(title: Text("ОШИБКА"), message: Text("Не правильно введен логин или пароль"), dismissButton: Alert.Button.default(Text("Ok"), action: ({
                                    unCorrectLoginOrPassword = false
                                    password = ""
                                    login = ""
                                })
                                )
                                )
                            })
                        }
                    }
                    Spacer().frame(width: 40)
                }.padding(.top, 30)
                Spacer().frame(height: 50)
            }
            .offset(y:-140)
            .onReceive(keyboardIsOnPublisher) { isKeyboardOn in
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

