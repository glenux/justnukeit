type item_t = 
    | Item_bonus
    | Item_malus
    | Item_none
;;

type block_t =
    | Block_solid
    | Block_reakable
    | Block_none
;;

type tileset_t =
    | Tileset_winter (* ice cubes,  *)
    | Tileset_summer (* mice, *)
    | Tileset_brick
    | Tileset_ufo (* rhombicuboctaedron, robots, etc. *)
    | Tileset_library (* crayon, books, papers, *)
;;

type level_t = {
    size_x : int ;
    size_y : int ;
    items : (item_t ref) array array ;
    blocks : (block_t ref) array array ;
    background: string ; (* FIXME: animated background *)
    foreground: string ; (* FIXME: animated foreground *)
    tileset : tileset_t;
};;


let default_x = 17;;

let default_y = 11;;

let create () = { 
    size_x = default_x ;
    size_y = default_y ;
    items = Array.make_matrix default_x default_y (ref Item_none) ;
    blocks = Array.make_matrix default_x default_y (ref Block_none) ; 
    tileset = Tileset_winter;
    background = "none" ;
    foreground = "noon" ;
}
;;

