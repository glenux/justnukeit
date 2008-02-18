
type t = {
    mutable name : string ;
    mutable lifes : int ;
    mutable position : Position.t;
} 

let create () = { 
    name = "Unnamed player" ; 
    lifes = 3 ;
    position = Position.zero ;
}
