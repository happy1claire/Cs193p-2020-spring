//
//  EmojiArtDocumentVIew.swift
//  EmojiArt
//
//  Created by Charlie on 2021/2/3.
//

import SwiftUI

struct EmojiArtDocumentVIew: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.emojiDeck.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: 40))
                            .onDrag { return NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
        }
        .padding(.horizontal)
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    Group {
                        if self.document.backgroundImage != nil {
                            Image(uiImage: self.document.backgroundImage!)
                        }
                    })
                    .edgesIgnoringSafeArea(.bottom)
                    .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                        var location = geometry.convert(location, from: .global)
                        location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                        return self.drop(providers: providers, at: location)
                    }
                ForEach(self.document.emojis) { emoji in
                    Text(emoji.text)
                        .font(self.font(for: emoji))
                        .position(self.position(for: emoji, in: geometry.size))
                }
            }
        }
    }
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("drop:\(url)")
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { String in
                self.document.addEmoji(String, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private var defaultEmojiSize: CGFloat = 40
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentVIew()
//    }
//}