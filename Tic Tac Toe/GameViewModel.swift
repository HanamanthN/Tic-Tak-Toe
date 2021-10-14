//
//  GameViewModel.swift
//  Tic Tac Toe
//
//  Created by Hanamantraya Nagonde on 14/10/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled: Bool = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDrwa(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputeMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDrwa(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determineComputeMovePosition(in moves: [Move?]) -> Int {
        // If AI can win, then win
        let winPattern: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer}
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPattern {
            let winPosition = pattern.subtracting(computerPosition)
            if winPosition.count == 1 {
                let isAvailabel = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailabel { return winPosition.first! }
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human}
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPattern {
            let winPosition = pattern.subtracting(humanPosition)
            if winPosition.count == 1 {
                let isAvailabel = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailabel { return winPosition.first! }
            }
        }
        
        // If AI can't block then take middle square
        let centerSquarePosition = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquarePosition) {
            return centerSquarePosition
        }
        
        // If AI can't take middle square, then take random availabel square
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPattern: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
 
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player}
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPattern where pattern.isSubset(of: playerPosition) {
            return true
        }
        
        return false
    }
    
    func checkForDrwa(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
