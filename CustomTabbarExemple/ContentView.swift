//
//  ContentView.swift
//  CustomTabbarExemple
//
//  Created by Rodrigo Carvalho on 23/08/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var selectedTab = "home"
    
    
    init () {
        UITabBar.appearance().isHidden = true
    }
    
    //Location For each Curve...
    @State var xAxis : CGFloat = 0
    
    @Namespace var animation
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
        TabView(selection: $selectedTab) {
            
            Color.red
                .ignoresSafeArea(.all,edges: .all)
                .tag("home")
            
            Color.blue
                .ignoresSafeArea(.all,edges: .all)
                .tag("toggle")
            
            Color.gray
                .ignoresSafeArea(.all,edges: .all)
                .tag("heart")
            
        }
            
            //Custom tab bar...
            
            HStack(spacing: 0){
                
                ForEach(tabs, id: \.self){ image in
                    
                    GeometryReader {reader in
                        Button(action: {
                            withAnimation(.spring()){
                                selectedTab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        }, label: {
                            Image(image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedTab == image ? getColor(image: image) : Color.gray)
                                .padding(selectedTab == image ? 15 : 0)
                                .background(Color.white.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()))
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: selectedTab == image ? (reader.frame(in: .global).minX - reader.frame(in: .global).midX) : 0,y: selectedTab == image ? -100 : -10)
                            
                        })
                        .onAppear(perform: {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 30, height: 30)
                    
                    if image != tabs.last{Spacer(minLength: 0)}
                    
                }
            }
            .padding(.horizontal,40)
            .padding(.vertical,30)
            .background(Color.white.clipShape(CustomShape(xAxis: xAxis)))
            .padding(.horizontal)
            //Bottom Edge...
//            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
//            .background(Color.white)
        }
        .ignoresSafeArea(.all, edges: .bottom)
//        .ignoresSafeArea(.all, edges: .trailing)
//        .ignoresSafeArea(.all, edges: .leading)
    }
    
    //getting Image Color...
    
    func getColor(image: String)-> Color{
        switch image {
        case "home":
            return Color.red
        case "toggle":
            return Color.blue
        case "heart":
            return Color.gray
        default:
            return Color.red
        }
    }
}

var tabs = ["home","toggle","heart"]

// Curve...

struct CustomShape : Shape {
    
    var xAxis: CGFloat
    
    // Animation Path...
//    var animatableData: CGFloat{
//        get {return xAxis}
//        set{xAxis = newValue}
//    }
    
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: -20, y: 0))
            path.addLine(to: CGPoint(x: rect.width + 20, y: 0))
            path.addLine(to: CGPoint(x: rect.width + 20, y: rect.maxY))
            path.addLine(to: CGPoint(x: -20, y: rect.height))
            
            let center = xAxis
            //Ponto da esquerda da curva
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            //Ponto do meio da curva
            let to1 = CGPoint(x: center, y: 35)
            
            let control1 = CGPoint(x: center - 40 , y: 0)
            let control2 = CGPoint(x: center - 40 , y: 0)
            
            //Ponto da direita da curva
            let to2 = CGPoint(x: center + 50, y: 0)
            
            let control3 = CGPoint(x: center + 40, y: 0)
            let control4 = CGPoint(x: center + 40, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
