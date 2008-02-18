(* vim: set ts=2 sw=2 et : *)
type t = int * int

let zero = (0, 0);;

let ( + ) x y = 
        let (xa, xb) = x 
        and (ya, yb) = y
        in (xa + ya, xb + yb)
;;

let ( - ) x y =
        let (xa, xb) = x 
        and (ya, yb) = y
        in (xa + ya, xb + yb)
;;

let ( * ) x y =
        let (xa, xb) = x 
        and (ya, yb) = y
        in (xa * ya, xb * yb)
;;

let dot x y =
       let (xa, xb) = x 
       and (ya, yb) = y
       in 
       let na = xa * yb
       and nb = xb * ya
       in ( na, nb )
;;
