(* vim: set ts=2 sw=2 et : *)
open Event;;

type config_t = {
  mutable width : int ;
  mutable height : int;
}

type notification_t =
  | Graphics_status of Graphics.status
  | Tick
;;

type game_event_t = 
  | MoveLeft
  | MoveRight
  | MoveUp
  | MoveDown
  | Action
  | ActionTwo
  | Help
  | Quit
  | NoEvent
;;

let image_filename = "images/test.png"
;;

let string_of_keyboard_event event =
  try
    let chr = Sdlkey.char_of_key event.Sdlevent.keysym 
    in 
    String.make 1 chr
  with
  | Invalid_argument _ -> "unknown-key"
;;

let rec event_loop () =
  print_endline "Event_loop...";
  Sdltimer.delay 20;
  let event_opt = Sdlevent.poll () 
  in 
  let match_event event = (
    match event with 
    | Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE} ->
        print_endline "You pressed escape! The fun is over now."

    | Sdlevent.KEYDOWN event -> 
        let keystr = string_of_keyboard_event event
        in
        print_endline ("You pressed " ^ keystr);
        event_loop ()

    | _ -> 
        event_loop ()
  ) in
  match event_opt with
  | None -> event_loop ()
  | Some event -> match_event event;
;;

let game_loop ~screen =
  let image = Sdlloader.load_image image_filename
  and image_from = Sdlvideo.rect 0 0 300 300 
  and image_to = Sdlvideo.rect 100 0 300 300 
  in
  Sdlvideo.blit_surface ~src:image ~src_rect:image_from ~dst:screen ~dst_rect:image_to ();
  Sdlvideo.flip screen;
  event_loop ();
;;

let main () =
  let player1 = Player.create ()
  and map1 = Maze.create ()
  and config = { width = 640 ; height = 480 }
  in
  ignore player1 ;
  ignore map1 ;
  (* open window *)
  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
  Sdlttf.init ();
  at_exit Sdlttf.quit;
  (* set parameters & title *)
  let screen = Sdlvideo.set_video_mode config.width config.height [`DOUBLEBUF]
  in
  game_loop ~screen:screen;
  (* close window *)
;;

main ();
