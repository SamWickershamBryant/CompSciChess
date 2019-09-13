import Igis

class Piece {

    let type : String
    let color : String // "b" or "w"
    var hasMoved : Bool
    
    init(type:String, color:String) {
        self.type = type
        self.color = color
    }

    func id() -> String {
        return "Color: \(self.color), Type: \(self.type)" 
    }
}
