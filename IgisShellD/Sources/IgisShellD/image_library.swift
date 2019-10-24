import Igis
import Foundation

class ImageLibrary {
    static let pieces : [Piece] = [Pawn("w"),
                                   Rook("w"),
                                   Knight("w"),
                                   Bishop("w"),
                                   King("w"),
                                   Queen("w"),
                                   Pawn("b"),
                                   Rook("b"),
                                   Knight("b"),
                                   Bishop("b"),
                                   King("b"),
                                   Queen("b")]
                                        
    var image : [String : Image?] = ["p":nil,
                                     "r":nil,
                                     "n":nil,
                                     "b":nil,
                                     "k":nil,
                                     "q":nil,
                                     "P":nil,
                                     "R":nil,
                                     "N":nil,
                                     "B":nil,
                                     "K":nil,
                                     "Q":nil
    ]
    func fenType(_ piece:Piece) -> String {
        if piece.color == "b" {
            return piece.type.uppercased()
        } else {
            return piece.type
        }
    }

    init(){

    }

    func displayImage(piece:Piece, rect:Rect, canvas:Canvas) {
        if imageReady(piece) {
            image[fenType(piece)]!!.renderMode = .destinationRect(rect)
            canvas.render(image[fenType(piece)]!!)
        } else {
            print("image is not ready")
        }
    }

    func imagesReady() -> Bool {
        for piece in ImageLibrary.pieces {
            if imageReady(piece) == false {
                return false
            }
        }
        return true
    }
    
    func imageReady(_ piece:Piece) -> Bool {
        if image[fenType(piece)]! != nil {
            return image[fenType(piece)]!!.isReady
        } else {
            print("please load the image!")
            return false
        }
    }

    
    func loadImages(canvas:Canvas) {
        for piece in ImageLibrary.pieces {
            loadImage(piece, canvas:canvas)
        }
    }

    func loadImage(_ piece:Piece, canvas:Canvas) {
        if image[fenType(piece)]! == nil {
            image[fenType(piece)]! = (imageDisplay(piece)) as Image?
            canvas.setup(image[fenType(piece)]!!)
            print("load iamge \(fenType(piece)) <-")
        } else {

        }
    }

    private func imageDisplay(_ piece:Piece) -> Image {
        if piece.color == "b" {
            guard let url =
                    URL(string:piece.imageLinkBlack) else {
                fatalError("Can't load url for \(piece.color), \(piece.type)")
            }
            return Image(sourceURL:url)
        } else {
            guard let url =
                    URL(string:piece.imageLinkWhite) else {
                fatalError("Can't load url for \(piece.color), \(piece.type)")
            }
            return Image(sourceURL:url)
        } 
    }
}
