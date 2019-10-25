import Igis
import Foundation

struct BoardSettings : CustomStringConvertible {
    var topLeft : Point
    var size : Int
    var outLineColor : Color
    var inLineColor : Color
    var squareColor : [Color]
    var lineWidth : Int

    init(topLeft:Point, size:Int, outLineColor:Color, inLineColor:Color, squareColor:[Color], lineWidth:Int) {
        self.topLeft = topLeft
        self.size = size
        self.outLineColor = outLineColor
        self.inLineColor = inLineColor
        self.squareColor = squareColor
        self.lineWidth = lineWidth
    }
    var description : String {
        return "tL:\(topLeft.x), \(topLeft.y);\n" +
          "size:\(size);" 
          
    }
}
