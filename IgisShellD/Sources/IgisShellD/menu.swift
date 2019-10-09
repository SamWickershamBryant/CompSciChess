import Igis
import Foundation

class Menu {
    init(){
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
