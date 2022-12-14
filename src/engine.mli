(** Module that defines functions to manage the game state and players.*)

open Cards

(** [player] represents the player in the game.*)
type player = {
  name : string;
  hand : card list;
  money : int;
  bet : int;
  folded : bool;
  position : int;
}

(** [pot] represents the main pot with amount and side pot in side_pots.*)
type pot = {
  amount : int;
  side_pots : int list;
}

(** [options] represents the various options one may select at the begining of
  the game.*)
type options = { starting_money : int }

(** [game_stage] represnts the current stage of the game. Bet of int represents
  which player is betting right now.*)
type game_stage =
  | Pre_Flop
  | Flop
  | Turn
  | River
  | Finish

(** [game_state] represesnts the state of the game, containing the stage, the
   players. *)
type game_state = {
  mutable stage : game_stage;
  mutable players : player list;
  mutable pot : pot;
  mutable deck : card list;
  mutable community_cards : card list;
  mutable current_bet : int;
  mutable options : options;
  mutable iterated : bool;
  mutable rounds : int;
}

(** The order in which players play their turn.*)
type turn_order = player list

(** The initial state of the game.*)
val init_state : game_state

(** Advances the game to another state.*)
val advance_state : game_state -> unit

(** Makes a player.*)
val make_player : string -> int -> player

(** Returns whether this game state is done betting or not.*)
val done_betting : game_state -> bool

(** Helper function for the function done betting.*)
val done_betting_help : turn_order -> bool

(** Retruns true if only 1 player is in the hand false otherwise.*)
val muck_check : game_state -> bool

(** Returns a list of the players in the hand.*)
val players_in_hand : game_state -> player list

(*Raise,fold, and check update game state as appropriately.*)

(** Parameters: current gamestate , the player number, and the bet you are making.
  raise_bet: if the raise is valid it modifies the list of players removing the
  player at the player number index from the list and concats a new updated
  player with the bet changed to the proper amount and returns unit, if the bet
  is invalid then it raises the Invalid_Raise exception*)
val raise_bet : game_state -> int -> int -> unit

(** Parameters: current gamestate , the player number. fold: modifies the list of
  players removing the player at the player number index from the list and
  concats a new updated player with fold as true and returns unit*)
val fold : game_state -> int -> unit

(** Perameters: current gamestate , player number. check: if the check is invalid
  then it raises the Invalid_Check exception otherwise it returns unit*)
val check : game_state -> int -> unit

(** Parameters: current gamestate , the player number, and the bet you are making.
  call: if the call is valid it modifies the list of players removing the player
  at the player number index from the list and concats a new updated player with
  the bet changed to the proper amount and returns unit, if the bet is invalid
  then it raises the Invalid_Call exception*)
val call : game_state -> int -> unit

(** Parameter: the current gamestate. update_pot: modifies the gamestate pot to be
  a new pot with the amount equal to the previous pot plus the sum of all the
  bets the players have made for that round and return unit*)
val update_pot : game_state -> unit

(** Represents the next turn.*)
val next_turn : unit -> unit

(** Iterates through the list of players and returns the highest bet*)
val top_bet : turn_order -> int

(** Checks to see if the bet is valid for the given player*)
val valid_bet : player -> turn_order -> int -> bool

(** If the bet is valid it returns a new player with the bet updated, otherwise it
  returns the original player*)
val make_bet : player -> turn_order -> int -> player

(** Returns the amount a given player would need to bet to call a bet*)
val call_amount : player -> turn_order -> int

(** Retruns true if there will be a side pot false otherwise*)
val is_side_pot : turn_order -> bool

(** Retruns true if there player is all in false otherwise*)
val all_in : player -> bool

(** Resets all the bets in that round.*)
val reset_bets : game_state -> unit

(* val set_bet : game_state -> player -> int -> unit *)
(*retruns a list of the vaious bet amounts of each sidepot ordered from lowest
  to highest*)

(*val side_pot_amount : turn_order -> int list*)

(** Retruns a list of the vaious bet amounts of each sidepot ordered from lowest
  to highest*)
val bet_list : turn_order -> int list

(** Retruns thelist after fixing bet values*)
val fix_values : int list -> int list

(** [draw_card] draws the top card of the deck and mutates the deck to no longer
   contain that card*)
val draw_card : game_state -> card

(** [deal_card] deals a card from the deck and mutates the deck to no longer
   contain that card*)
val deal_cards : game_state -> unit

(** [overturn_community_cards] over turns community card from the deck and 
    mutates the sate of community cards in the deck*)
val overturn_community_cards : game_state -> unit

(** Returns a list of the various pot amounts in order of precidence*)
val pot_amounts : turn_order -> int list -> int list

(** Decrements the round and resets the game, but keeps everybodies money. if the
  rounds is at zero, returns false. If rounds are not, returns true.\*)
val next_game : game_state -> unit
