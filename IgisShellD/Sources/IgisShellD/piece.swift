import Igis

class Piece : CustomStringConvertible {

    let type : String
    let color : String // "b" or "w"
    var position : String // Placeholder 
    var hasMoved : Bool
    
    init(type:String, color:String, position: String, hasMoved: Bool) {
        self.type = type
        self.color = color
        self.position = position
        self.hasMoved = hasMoved
    }

    func id() -> String {
        return "Color: \(self.color), Type: \(self.type), \(position)" 
    }
    
    var description : String {
        return "Type:\(type), Color:\(color), Position:\(position), hasMoved:\(hasMoved)"
    }
}
