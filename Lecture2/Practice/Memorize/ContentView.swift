//
//  ContentView.swift
//  Memorize
//
//  Created by Charlie on 2020/12/17.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    
    var body: some View {
        HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture(perform: { viewModel.choose(card: card)
                })
            }
        }
        .padding()
        .font(Font.largeTitle)
        .foregroundColor(.gray)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceup{
                RoundedRectangle(cornerRadius: 10.0).fill(Color.gray)
                RoundedRectangle(cornerRadius:10.0).stroke(lineWidth: 3.0)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
