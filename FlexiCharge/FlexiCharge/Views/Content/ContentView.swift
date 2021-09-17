//
//  ContentView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var keyboardHeight: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
        ZStack(alignment: .bottom) {
                MapView()
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        offset = 0
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                VStack {
                    HStack {
                        VStack {
                            Button(action: {
                                findUserOnMap()
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                        .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
                                    Image("location-pin")
                                        .resizable()
                                        .frame(width: screenWidth * 0.06, height: screenWidth * 0.08, alignment: .center)
                                }
                            }).offset(x: screenWidth * -0.35)
                        }
                    }
                    HStack {
                        Button(action: {
                            cameraButton()
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                    .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
                                Image(systemName: "camera.fill")
                                    .font(Font.system(.title2))
                                    .foregroundColor(.white)
                            }
                        }).offset(x:screenWidth * -0.15)
                        Button(action: {
                            let maxHeight = screenHeight / 2
                            offset = -maxHeight
                            lastOffset = offset
                        }){
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                    .frame(width: screenWidth * 0.20, height: screenWidth * 0.20)
                                Image("white")
                            }
                        }
                        ZStack {
                            NavigationLink(destination: SettingsView()) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.30, green: 0.30, blue: 0.30))
                                        .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
                                    Image("person")
                                        .resizable()
                                        .frame(width: screenWidth * 0.07, height: screenWidth * 0.07, alignment: .center)
                                }
                            }
                        }.offset(x:screenWidth * 0.15)
                    }.padding(.bottom, screenHeight * 0.05)
                    .padding(.horizontal, screenWidth * 0.1)
                }
                IdentifyChargerView()
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.2))
                    .offset(y: screenHeight - self.keyboardHeight)
                    .offset(y: -offset > 0 ? -offset <= screenHeight ? offset : -screenHeight : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: {
                                                        value, out, _ in
                        out = value.translation.height
                        onChange()
                    })
                    .onEnded({value in
                        let maxHeight = screenHeight / 2
                        withAnimation {
                            if -offset > maxHeight / 2 {
                                offset = -maxHeight
                            } else {
                                offset = 0
                            }
                        }
                        lastOffset = offset
                    }))
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { data in
                            let height = data.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                            self.keyboardHeight = height.cgRectValue.height
                        }
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                            self.keyboardHeight = 0
                        }
                    }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    func cameraButton() {
        // Function to open camera and and scan qrcode and return a charer id
    }
    func findUserOnMap() {
        // Find the user on the map
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}