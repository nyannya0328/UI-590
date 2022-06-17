//
//  Home.swift
//  UI-590
//
//  Created by nyannyan0328 on 2022/06/17.
//

import SwiftUI

struct Home: View {
    @State var albums : [Album] = sampleAlbums
    @State var currentIndex : Int = 0
    @State var currentAlbum = sampleAlbums.first!
    var body: some View {
        VStack(spacing:0){
            
            Text(attString)
            .font(.caption)
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.bottom,40)
            
            VStack{
                
                AlbumArtWorkScroller()
                    .zIndex(1)
                
                standView
                    .zIndex(0)
                    
                
                
            }
            .padding(-15)
            .zIndex(1)
            
            
            TabView{
                
                
                ForEach($albums){$album in
                    albumCardView(album: album)
                        .offsetX { value, width in
                            
                            
                            if currentIndex == getIndex(album: album){
                                
                                var offset = ((value > 0 ? -value : value) / width) * 80
                                
                                offset = (-offset < 80 ? offset : -80)
                                album.diskOffset = offset
                                
                                
                            }
                            
                            if value == 0 && currentIndex != getIndex(album: album){
                                
                                album.diskOffset = 0
                                
                                withAnimation(.easeIn(duration: 0.6)){
                                    
                                    albums[currentIndex].showDisk = false
                                    currentIndex = getIndex(album: album)
                                    currentAlbum = albums[currentIndex]
                                    
                                    
                                }
                                
                                
                                withAnimation(.interactiveSpring(response: 0.5,dampingFraction:1,blendDuration:1).delay(0.4)){
                                    
                                    
                                    albums[currentIndex].showDisk = true
                                    
                                }
                                
                                
                                
                                
                            }
                        }
                    
                }
                
                
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.horizontal,-15)
            .zIndex(0)
            
            
            
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background{
         
            Color("BG").ignoresSafeArea(.all)
        }
        .onAppear{
            
            
            withAnimation(.interactiveSpring(response: 0.5,dampingFraction:1,blendDuration:1).delay(0.4)){
                
                
                albums[currentIndex].showDisk = true
                
            }
        }
        
        
    }
    func getIndex(album : Album)->Int{
        
        return albums.firstIndex { _album in
            return album.id == _album.id
        } ?? 0
    }
    
    @ViewBuilder
    func albumCardView(album : Album)->some View{
        
        
        VStack(alignment: .leading,spacing: 10){
            
            HStack{
                
                Text("Albums")
                    .font(.title2)
                    .foregroundColor(.gray)
                  .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack{
                    
                    ForEach(1...5,id: \.self){index in
                        
                         Image(systemName: "star.fill")
                            .font(.system(size: 6))
                            .foregroundColor(.gray.opacity(index > album.rating ? 0.2 : 1))
                    }
                    
                    Text("\(album.rating).0")
                        .font(.system(size: 15))
                        .foregroundColor(.gray.opacity(0.2))
                }
                
            }
            
            Text(album.albumName)
                .font(.largeTitle.weight(.black))
            
            Label {
                
                  Text("Ariana Grante")
            } icon: {
                
                  Text("By")
                    .foregroundColor(.gray.opacity(0.3))
                
            }
            
              Text(sampleText)
                .foregroundColor(.gray)
            
            HStack(spacing:10){
                
                
                ForEach(["Punk","Clasic Rock","Art Rock"],id:\.self){name in
                    
                    
                    Toggle(name, isOn: .constant(false))
                        .toggleStyle(.button)
                        .buttonStyle(.bordered)
                        .tint(.gray)
                    
                    
                    
                }

            }
            .padding(.top)
            
            
        }
        .padding(.top,30)
        .padding([.horizontal,.bottom])
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background{
         
            CustomConer(radi: 25, corner: [.bottomLeft,.bottomRight])
                .fill(.white.opacity(0.6))
        }
        .padding(.horizontal,30)
        
        
        
    }
    @ViewBuilder
    func AlbumArtWorkScroller()->some View{
        
        
        GeometryReader{proxy in
             let size = proxy.size
            
            LazyHStack(spacing:0){
                
                
                ForEach($albums){$album in
                    
                    
                    HStack(spacing:0){
                        
                        Image(album.albumImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180,height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style:.continuous))
                            .zIndex(1)
                        
                        
                        Image("Disk")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160,height: 160)
                            .overlay {
                                
                                Image(album.albumImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70,height: 70)
                                    .clipShape(Circle())
                                
                                
                            }
                            .rotationEffect(.init(degrees: album.showDisk ? 0 : 40))
                            .rotationEffect(.init(degrees: album.diskOffset / 80) * 40)
                            .offset(x:album.showDisk ? 80 : 0)
                            .offset(x:album.showDisk ? album.diskOffset : 0)
                            .scaleEffect(album.showDisk ? 1: 0.1)
                        
                            .padding(.leading,-180)
                            
                    
                            .zIndex(0)
                        
                       
                        
                    }
                    .offset(x:-40)
                    .frame(width:size.width,alignment: currentIndex > getIndex(album: album) ? .trailing : currentIndex == getIndex(album: album) ? .center : .leading)
                    
                    .scaleEffect(currentAlbum.id == album.id ? 1 : 0.8,anchor: .bottom)
                    .offset(x:currentIndex > getIndex(album: album) ? 100 : currentIndex == getIndex(album: album) ? 0 : 40)
                   
                 
                 
                    
                        
                }
                
                
                
                
            }
            .offset(x:CGFloat(currentIndex) * -size.width)
            
         
            
            
        }
        .frame(height:180)
        
        
        
    }
    var standView : some View {
        
        
        Rectangle()
            .fill(.white.opacity(0.3))
            .shadow(color: .gray.opacity(0.3), radius: 20,x:5,y:5)
            .frame(height:10)
            .overlay(alignment: .top) {
                
                Rectangle()
                    .fill(.white.opacity(0.7).gradient)
                    .frame(height:385)
                    .rotation3DEffect(.init(degrees: -98), axis: (x: 1, y: 0, z: 0),anchor:.top,anchorZ: 0.5,perspective: 1)
                    .shadow(color: .black.opacity(0.3), radius: 20,x:5,y:5)
                    .shadow(color: .black.opacity(0.3), radius: 5,x:0,y:15)
                  
                  
                
            }
            .scaleEffect(1.5)
        
        
    }
    var attString : AttributedString{
        
        var atr = AttributedString(stringLiteral: "My Library")
        
        if let range = atr.range(of: "Library"){
            
            atr[range].font = .largeTitle.bold()
            atr[range].foregroundColor = .orange.opacity(0.3)
        }
        return atr
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    
    func offsetX(cometition : @escaping(CGFloat,CGFloat) -> ())->some View{
        
        
        self
        
            .overlay {
                GeometryReader{proxy in
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .global).minX)
                        .onPreferenceChange(OffsetKey.self) { value in
                            
                            cometition(value,proxy.size.width)
                        }
                }
            }
        
    }
}

struct OffsetKey : PreferenceKey{
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        
        value = nextValue()
    }
}
