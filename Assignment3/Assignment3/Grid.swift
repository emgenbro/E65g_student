//
//  Grid.swift
//
import Foundation

public typealias Position = (row: Int, col: Int)
public typealias PositionSequence = [Position]

// Implement the wrap around rules
public func normalize(position: Position, to modulus: Position) -> Position {
    let modRows = modulus.row, modCols = modulus.col
    return Position(
        row: ((position.row % modRows) + modRows) % modRows,
        col: ((position.col % modCols) + modCols) % modCols
    )
}

// Provide a sequence of all positions in a range
public func positionSequence (from: Position, to: Position) -> PositionSequence {
    return (from.row ..< to.row)
        .map { row in zip( [Int](repeating: row, count: to.col - from.col), from.col ..< to.col ) }
        .flatMap { $0 }
}
/**
 1. Using the CellState enum provided in the template (Grid.swift) make the following additions (10 points)
	•	Give the enum a raw type of String
	•	Assign the name of the case as the String value for each case
	•	equip the enum with a description method which uses a switch statement to hand back the raw value
	•	equip the enum with an allValues method which returns an array of all available values for the enum
	•	equip the enum with a method toggle(value:CellState)-> CellState which when passed .empty or .died, returns .alive, when passed .alive or .born returns .empty
 **/
public enum CellState : String {
    case alive="alive", empty="emtpy", born="born", died="died"
    
    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
    var description: String {
        switch self {
          case .alive: return CellState.alive.rawValue
          case .empty: return CellState.empty.rawValue
          case .born:  return CellState.born.rawValue
          case .died:  return CellState.died.rawValue
        }
    }
    static let allValues = [alive, empty, born, died]
    mutating func toggle() {
        switch self {
        case .empty, .died:
            self = .alive
        case .alive, .born:
            self = .empty
        }
    }
    public func toggle(value: CellState) -> CellState {
        switch value {
        case .empty, .died:
            return .alive
        case .alive, .born:
            return .empty
        }
    }
}

public struct Cell {
    var position = Position(row:0, col:0)
    var state = CellState.empty
}

public struct Grid {
    private var _cells: [[Cell]]
    fileprivate var modulus: Position { return Position(_cells.count, _cells[0].count) }
    
    // Get and Set cell states by position
    public subscript (pos: Position) -> CellState {
        get { let pos = normalize(position: pos, to: modulus); return _cells[pos.row][pos.col].state }
        set { let pos = normalize(position: pos, to: modulus); _cells[pos.row][pos.col].state = newValue }
    }
    
    // Allow access to the sequence of positions
    public let positions: PositionSequence
    
    // Initialize _cells and positions
    public init(_ rows: Int, _ cols: Int, cellInitializer: (Position) -> CellState = { _, _ in .empty } ) {
        _cells = [[Cell]]( repeatElement( [Cell](repeatElement(Cell(), count: rows)), count: cols) )
        positions = positionSequence(from: Position(0,0), to: Position(rows, cols))
        positions.forEach { _cells[$0.row][$0.col].position = $0; self[$0] = cellInitializer($0) }
    }
    
    private static let offsets: [Position] = [
        (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
        (row:  0, col:  -1),                     (row:  0, col:  1),
        (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
    ]
    private func neighbors(of position: Position) -> [CellState] {
        return Grid.offsets.map {
            let neighbor = normalize(position: Position(
                row: (position.row + $0.row),
                col: (position.col + $0.col)
            ), to: modulus)
            return self[neighbor]
        }
    }
    
    private func nextState(of position: Position) -> CellState {
        switch neighbors(of: position).filter({ $0.isAlive }).count {
        case 2 where self[position].isAlive,
             3: return self[position].isAlive ? .alive : .born
        default: return self[position].isAlive ? .died  : .empty
        }
    }
    
    // Generate the next state of the grid
    public func next() -> Grid {
        var nextGrid = Grid(modulus.row, modulus.col)
        positions.forEach { nextGrid[$0] = self.nextState(of: $0) }
        return nextGrid
    }
}

public extension Grid {
    public var description: String {
        return positions
            .map { (self[$0].isAlive ? "*" : " ") + ($0.1 == self.modulus.col - 1 ? "\n" : "") }
            .joined()
    }
    public var living: [Position] { return positions.filter { return  self[$0].isAlive   } }
    public var dead  : [Position] { return positions.filter { return !self[$0].isAlive   } }
    public var alive : [Position] { return positions.filter { return  self[$0] == .alive } }
    public var born  : [Position] { return positions.filter { return  self[$0] == .born  } }
    public var died  : [Position] { return positions.filter { return  self[$0] == .died  } }
    public var empty : [Position] { return positions.filter { return  self[$0] == .empty } }
}

extension Grid: Sequence {
    public struct SimpleGridIterator: IteratorProtocol {
        private var grid: Grid
        
        public init(grid: Grid) {
            self.grid = grid
        }
        
        public mutating func next() -> Grid? {
            grid = grid.next()
            return grid
        }
    }
    
    public struct HistoricGridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [Position]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                guard lhs.positions.count == rhs.positions.count else { return false }
                let zipped = zip(lhs.positions, rhs.positions)
                for pair in zipped { if pair.0.row != pair.1.row || pair.0.col != pair.1.col { return false } }
                return true
            }
            
            init(_ positions: [Position], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: Grid
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> Grid? {
            if history.hasCycle { return nil }
            let newGrid = grid.next()
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            return grid
        }
    }
    
    public func makeIterator() -> HistoricGridIterator {
        return HistoricGridIterator(grid: self)
    }
}

func gliderInitializer(row: Int, col: Int) -> CellState {
    switch (row, col) {
    case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
    default: return .empty
    }
}

func emptyInitializer(row: Int, col: Int) -> CellState {
    return .empty
}

