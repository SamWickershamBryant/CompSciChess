
import Igis
import Foundation

class Menu {
    
    var gameRect : Rect 
    var mainRect : Rect //width will be >=65% of gameRect (until divisible by 8)
                        //height will be <=canvasHeight (until divisible by 10))
    var sideBarRect : Rect //width will be <=35% of gameRect (until mainRect divisible by 8)
                           //height will be = mainRect
    var topMarginRect : Rect //height will be 10% of mainRect
    var boardRect : Rect //height will be 80% of mainRect
    var bottomMarginRect : Rect //height will be 10% mainRect
    
    var boardSettings : BoardSettings

    var game : Game? = nil
    var lastRenderedState = -1
    let userId : Int
        
    var canvasSize : Size
    
    init(userId:Int) {
        gameRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:50, height:50))
        mainRect = Rect(topLeft:Point(x:10, y:0), size:Size(width:50, height:50))
        sideBarRect = Rect(topLeft:Point(x:20, y:0), size:Size(width:50, height:50))

        topMarginRect = Rect(topLeft:Point(x:20, y:0), size:Size(width:5, height:5))
        boardRect = Rect(topLeft:Point(x:20, y:0), size:Size(width:5, height:5))
        bottomMarginRect = Rect(topLeft:Point(x:20, y:0), size:Size(width:5, height:5))

        self.userId = userId
        self.canvasSize = Size(width: 10000, height: 8000)
        self.boardSettings = BoardSettings(topLeft:Point(x:100,y:100),
                                           size:0,
                                           outLineColor:Color(.black),
                                           inLineColor:Color(.black),
                                           squareColor:[Color(red:201, green:172, blue:113), Color(red:115, green:92, blue:46)],
                                           lineWidth:2)

        
    }

    func onClick(point:Point) {
        if game != nil {
            game!.onClick(boardSettings:boardSettings, point:point, userId:userId)
            print(boardSettings)
        }
    }
    
    func joinGame(game:Game) {
        self.game = game
    }

    func update(imageLibrary:ImageLibrary, canvas:Canvas) {
        if gameNeedsToRender() {
            renderGame(imageLibrary:imageLibrary, canvas:canvas)
            print("render game")
        }
    }

    func gameNeedsToRender() -> Bool {
        guard game != nil else {
            print("join a game first")
            return false
        }
        return game!.gameState != lastRenderedState
    }

    func renderGame(imageLibrary:ImageLibrary, canvas:Canvas) {
        guard game != nil else {
            print("join a game first")
            return
        }
        if game!.isReady(imageLibrary:imageLibrary) {
            game!.renderGame(imageLibrary:imageLibrary, boardSettings:boardSettings, canvas:canvas)
            lastRenderedState = game!.gameState
        } else {
            lastRenderedState -= 1
        }
        
        canvas.render(Rectangle(rect:gameRect, fillMode:.stroke), Rectangle(rect:sideBarRect, fillMode:.stroke))
    }
    
//  |-----------------------gameRect-----------------------|

//  |---------mainRect-------------|------sideBarRect------|
    ////////////////////////////////////////////////////////
    //                             //                     //
    /////////////////////////////////                     //
    //                             //                     //
    //                             //                     //
    //                             //                     //
    //                             //                     //
    //                             //                     //
    //                             //                     //
    //                             //                     //
    /////////////////////////////////                     //
    //                             //                     //
    ////////////////////////////////////////////////////////
    
    func setAllRects(canvas:Canvas) {
        setMainRect(canvas:canvas)
        setSideBarRect(canvas:canvas)
        setGameRect(canvas:canvas)
        spliceMainRect(canvas:canvas)
        setBoardSettings()
        return
    }
    
    func setMainRect(canvas:Canvas) {
        let canvasWidth = canvasSize.width
        let canvasHeight = canvasSize.height
        var updatedWidth = 0
        
        let x = Double(canvasSize.width)
        var y = 30.0
        y = (0.0000677506775068*(x*x)) - (0.122967479675*x)
        y = y + 95.7926829268
                
        updatedWidth = canvasWidth - ((canvasWidth * Int(y)) / 100)
        while updatedWidth % 8 != 0 {
            updatedWidth += 1
        }
        var updatedHeight = canvasHeight
        while updatedHeight % 10 != 0 {
            updatedHeight -= 1
        }
        
        mainRect = Rect(topLeft:Point(x:0, y:0),
                        size:Size(width:updatedWidth, height:updatedHeight))

       // print("")
       // print("x = \(x)")
       /// print("y = \(y)")
       // print("updatedWidth = \(updatedWidth)")
        return
    }
    
    func setSideBarRect(canvas:Canvas) {
        let updatedWidth = canvasSize.width - mainRect.size.width
        let updatedHeight = mainRect.size.height
        sideBarRect = Rect(topLeft:Point(x:mainRect.topLeft.x + mainRect.size.width, y:mainRect.topLeft.y),
                                  size:Size(width:updatedWidth,
                                            height:updatedHeight))
        return
    }

    func setGameRect(canvas:Canvas) {
        gameRect = Rect(topLeft:Point(x:0, y:0),
                        size:Size(width:mainRect.size.width + sideBarRect.size.width, height:mainRect.size.height))
        return
    }
    
    func spliceMainRect(canvas:Canvas) {
        let mainWidth = mainRect.size.width
        let mainHeight = mainRect.size.height
        topMarginRect.size = Size(width:mainWidth, height:mainHeight / 10)
        boardRect.size = Size(width:mainWidth, height:(mainHeight / 10) * 8)
        bottomMarginRect.size = Size(width:mainWidth, height:mainHeight / 10)
        
        //making the board a square and redistributing the excess space
        let boardWidth = boardRect.size.width
        var boardHeight = boardRect.size.height
        var excessSpace = 0
        if boardHeight > boardWidth {
                    
            repeat {
                boardHeight -= 1
                excessSpace += 1
            } while boardHeight != boardWidth

            topMarginRect.size = Size(width:mainWidth, height:(mainHeight/10) + (excessSpace/2))
            excessSpace -= excessSpace/2
            bottomMarginRect.size = Size(width:mainWidth, height:(mainHeight/10) + excessSpace)
            boardRect.size = Size(width:mainWidth, height:boardHeight)
        }
        if boardHeight < boardWidth {
                                
            repeat {
                boardHeight += 1
                excessSpace -= 1
            } while boardHeight != boardWidth
            
            topMarginRect.size = Size(width:mainWidth, height:(mainHeight/10) + excessSpace/2)
            excessSpace -= excessSpace/2
            bottomMarginRect.size = Size(width:mainWidth, height:(mainHeight/10) + excessSpace)
            boardRect.size = Size(width:mainWidth, height:boardHeight)
        }

        topMarginRect.topLeft = Point(x:mainRect.topLeft.x, y:mainRect.topLeft.y)
        boardRect.topLeft = Point(x:mainRect.topLeft.x, y:topMarginRect.size.height)
        bottomMarginRect.topLeft = Point(x:mainRect.topLeft.x, y:topMarginRect.size.height + boardRect.size.height)
        return
    }

    func setBoardSettings() {
        boardSettings = BoardSettings(topLeft:boardRect.topLeft,
                                      size:boardRect.size.width,
                                      outLineColor:Color(.black),
                                      inLineColor:Color(.black),
                                      squareColor:[Color(red:201, green:172, blue:113), Color(red:115, green:92, blue:46)],
                                      lineWidth:2)
        return
    }

    
}




/*
 when board is finished, the future plan is for menu to take controls and keep track of which players are playing...
 menu will also hold and display the game class (which containes board and timer in the future). Menu will start on some sort of home page
 then when you navigate to start a game it will call game class which will call board and timer and so on... menu feeds control inputs to game only
 of the players that are actually playing. others can still spectate however.

 in painter menu will be different for each each person and when they start a game, both them and the other play have the game loaded in a "player" mode
 where their inputs are sent to the game to control the board. If they are not a player it will be a "spectator" mode in which their clicks on the board will
 not be sent to that game. The game will still update when the players that are playing make a move.

 How will painter see the game that wasnt started by a user? a static variable in painter called games[] will hold all games currently running.The spectator's menu
 will open and display the game the player chooses and whenever the timer ticks, or a move is made, it will update in real time for the spectator.
 Updating will occurr by the spectator menu checking if its boardstate is equal to the boardstate of the game in the games[] array. If they differ, it will update
 and redisplay the board. For the timer ig it will also check if the time has changed and if so redisplay the clock.
 
 */
