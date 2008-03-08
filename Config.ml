(* vim: set ts=2 sw=2 et: *)
exception ParseError
;;

type t = {
  mutable config_dir : string ;
  mutable video_width : int ;
  mutable video_height : int ; 
  mutable show_fps : bool
}

let create () =
  let config_dir = Printf.sprintf "%s/.justnukeit" ( Unix.getenv "HOME" )
  in
  {
    config_dir = config_dir ;
    video_width = 0 ;
    video_height = 0 ;
    show_fps = false 
  }
;;

let parse_cmdline config =
  let usagemsg = ( "Usage: " ^ Sys.argv.(0) ^ " <options>\n" ) in
  Arg.parse 
  ( 
    Arg.align [
      ("-config", Arg.String (fun x -> config.config_dir <- x ) , "<dir> Load configuration from given directory");
    ]
  ) (fun x -> ignore x ) usagemsg
;;


let parse_file_load config config_file = 
  ignore config ;
  ignore config_file
;;

let parse_file_test config config_file =
  let  config_perms = [Unix.R_OK; Unix.W_OK; Unix.F_OK]
  in

  let dir_exist = 
    print_string ( "Testing configuration dir '" ^ config.config_dir ^ "'\n" ) ;
    try Unix.access config.config_dir config_perms ; true
    with _ -> false
  in 

  let file_exist = 
    print_string ( "Testing configuration file '" ^ config_file ^ "'\n" ) ;
    try Unix.access config_file config_perms ; true
    with _ -> false 
  in

  print_string ( "Dir = " ^ ( string_of_bool dir_exist ) ^ " / File = " 
  ^ ( string_of_bool file_exist ) ^ "\n" ) ;

  match ( dir_exist, file_exist ) with
  | ( false, false ) -> 
      (* create missing directory *)
      Unix.mkdir config.config_dir 0o750
      (* dump default config *)
  | ( false, true ) -> (* problem! *)
      raise ParseError
  | ( true, false ) -> 
      (* dump default config *)
      ()
  | ( true, true ) -> 
      (* load file *)
      ()
;;

let parse_file config = 
  let config_file = 
    Printf.sprintf "%s/config" config.config_dir ;
  in

  parse_file_test config config_file; 
  parse_file_load config config_file
;;

