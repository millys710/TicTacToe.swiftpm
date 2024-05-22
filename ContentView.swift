import Foundation

class GameState: ObservableObject
{
    @Published var board = [[Cell]]()
    @Published var turn = Tile.Cross
    @Published var noughtsScore = 0
    @Published var crossesScore = 0
    @Published var showAlert = false
    @Published var alertMessage = "Draw"
    
    
    
    init()
    {
        resetBoard()
    }
    
    func turnText() -> String
    {
        return turn == Tile.Cross ? "Turn: X" : "Turn: O"
    }
    
    func placeTile(_ row: Int,_ column: Int)
    {
        if(board[row][column].tile != Tile.Empty)
        {
            return
        }
        
        board[row][column].tile = turn == Tile.Cross ? Tile.Cross : Tile.Nought
        
        
        if(checkForVictory())
        {
            if(turn == Tile.Cross)
            {
                crossesScore += 1
            }
            else
            {
                noughtsScore += 1
            }
            let winner = turn == Tile.Cross ? "Crosses" : "Noughts"
            alertMessage = winner + " Win!"
            showAlert = true
        }
        else
        {
            turn = turn == Tile.Cross ? Tile.Nought : Tile.Cross
        }
        
        if(checkForDraw())
        {
            alertMessage = "Draw"
            showAlert = true
        }
    }
    
    func checkForDraw() -> Bool
    {
        for row in board
        {
            for cell in row
            {
                if cell.tile == Tile.Empty
                {
                    return false
                }
            }
        }
        
        return true
    }
    
    func checkForVictory() -> Bool
    {
        // vertical victory
        if isTurnTile(0, 0) && isTurnTile(1, 0) && isTurnTile(2, 0)
        {
            return true
        }
        if isTurnTile(0, 1) && isTurnTile(1, 1) && isTurnTile(2, 1)
        {
            return true
        }
        if isTurnTile(0, 2) && isTurnTile(1, 2) && isTurnTile(2, 2)
        {
            return true
        }
        
        // horizontal victory
        if isTurnTile(0, 0) && isTurnTile(0, 1) && isTurnTile(0, 2)
        {
            return true
        }
        if isTurnTile(1, 0) && isTurnTile(1, 1) && isTurnTile(1, 2)
        {
            return true
        }
        if isTurnTile(2, 0) && isTurnTile(2, 1) && isTurnTile(2, 2)
        {
            return true
        }
        
        // diagonal victory
        if isTurnTile(0, 0) && isTurnTile(1, 1) && isTurnTile(2, 2)
        {
            return true
        }
        if isTurnTile(0, 2) && isTurnTile(1, 1) && isTurnTile(2, 0)
        {
            return true
        }
        
        
        return false
    }
    
    func isTurnTile(_ row: Int,_ column: Int) -> Bool
    {
        return board[row][column].tile == turn
    }
    
    func resetBoard()
    {
        var newBoard = [[Cell]]()
        
        for _ in 0...2
        {
            var row = [Cell]()
            for _ in 0...2
            {
                row.append(Cell(tile: Tile.Empty))
            }
            newBoard.append(row)
        }
        board = newBoard
    }
}

import Foundation
import SwiftUI

struct Cell
{
    var tile: Tile
    
    func displayTile() -> String
    {
        switch(tile)
        {
        case Tile.Nought:
            return "O"
        case Tile.Cross:
            return "X"
        default:
            return ""
        }
    }
    
    func tileColor() -> Color
    {
        switch(tile)
        {
        case Tile.Nought:
            return Color.red
        case Tile.Cross:
            return Color.black
        default:
            return Color.black
        }
    }
}

enum Tile
{
    case Nought
    case Cross
    case Empty
}
import SwiftUI

struct ContentView: View
{
    @StateObject var gameState = GameState()
    
    var body: some View
    {
        let borderSize = CGFloat(5)
        
        Text(gameState.turnText())
            .font(.title)
            .bold()
            .padding()
        Spacer()
        
//        Text(String(format: "Crosses: %d", gameState.crossesScore))
//            .font(.title)
//            .bold()
//            .padding()
        
        VStack(spacing: borderSize)
        {
            ForEach(0...2, id: \.self)
            {
                row in
                HStack(spacing: borderSize)
                {
                    ForEach(0...2, id: \.self)
                    {
                        column in
                        
                        let cell = gameState.board[row][column]
                        
                        Text(cell.displayTile())
                            .font(.system(size: 60))
                            .foregroundColor(cell.tileColor())
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(Color.white)
                            .onTapGesture {
                                gameState.placeTile(row, column)
                            }
                    }
                }
                
            }
        }
        .background(Color.black)
        .padding()
        .alert(isPresented: $gameState.showAlert)
        {
            Alert(
                title: Text(gameState.alertMessage),
                dismissButton: .default(Text("Okay"))
                {
                    gameState.resetBoard()
                }
            )
        }
        
//        Text(String(format: "Noughts: %d", gameState.noughtsScore))
//            .font(.title)
//            .bold()
//            .padding()
//        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
