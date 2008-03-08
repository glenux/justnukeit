
type timeslice_t = {
    (* Action *)
    action: Action.t;
    label: string ;
}

type t = timeslice_t list

let create () = 
    [];;


let add_slice timeline slice = timeline @ [slice];;

let add_action timeline action = ();;
