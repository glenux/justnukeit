type item_t = 
    | Bonus
    | Malus
    | NoItem
;;

type block_t =
    | Solid
    | Breakable
    | NoBlock
;;

type t = {
    mutable size_x : int ;
    mutable size_y : int ;
    mutable items : item_t array array ;
    mutable blocks : block_t array array ;
};;


let default_x = 10;;

let default_y = 10;;

let create () = { 
    size_x = default_x ;
    size_y = default_y ;
    items = Array.make_matrix default_x default_y NoItem ;
    blocks = Array.make_matrix default_x default_y NoBlock ; 
}
;;
