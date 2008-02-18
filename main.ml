(* vim: set ts=2 sw=2 et : *)
open Event;;

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


let dispatch_status optstatus =
  let dispatch_keypress key = 
    match key with
    | 'q' -> Quit
    | _ -> 
        Printf.printf "Unknown action for key (%c)\n" key; 
        NoEvent
  in
  match optstatus with
  | None -> (* only draw *) 
      NoEvent
  | Some st -> (* react depending on sort *)
      if st.Graphics.keypressed then dispatch_keypress st.Graphics.key
      else NoEvent
;;

let e_receive chan = 
  Event.sync ( Event.receive chan ) 
;;

let e_send chan data = 
  Event.sync ( Event.send chan data ) 
;;

let tick_run pfd_out req_channel notif_channel =
  let buf = String.make 1 ' ' in
  while true do
    let delay = e_receive req_channel in
    try 
      ignore ( ThreadUnix.timed_read pfd_out buf 0 1 delay );
      ignore ( e_send notif_channel Tick );
    with
    | Unix.Unix_error(Unix.ETIMEDOUT,_,_) ->
        ignore ( e_send notif_channel Tick );
  done
;;

let graphic_run listen_lst notif_channel =
  while true do
    let event = 
        Graphics.wait_next_event listen_lst
    in
    ignore (e_send notif_channel (Graphics_status event));
  done
;;

let game_loop () =
  let ( pfd_out, pfd_in ) = Unix.pipe ()
  and tick_request_channel = Event.new_channel ()
  and tick_notification_channel = Event.new_channel ()
  and graphic_notification_channel = Event.new_channel ()
  in
  let tick_listener = tick_run pfd_out tick_request_channel 
  and graphic_listener = graphic_run [Graphics.Key_pressed]
  in
  let thr_tick =  Thread.create tick_listener tick_notification_channel
  and thr_input = Thread.create graphic_listener graphic_notification_channel
  in
  let ack () = 
    ignore ( Unix.write pfd_in "." 0 1 )
  in
  let time_wait_next_event time lst = 
    e_send tick_request_channel time;
    match Event.select [Event.receive tick_notification_channel;
                        Event.receive graphic_notification_channel]
    with
    | Tick -> None
    | Graphics_status status -> 
        ack ();
        ignore( e_receive tick_notification_channel );
        Some status
  in
  let continue = ref true
  in
  while !continue do
    let opt_status = time_wait_next_event 0.05 [Graphics.Key_pressed]
    in
    match dispatch_status opt_status with
    | MoveLeft -> print_string "Move Left...\n";
    | MoveRight -> print_string "Move Right...\n";
    | MoveUp -> print_string "Move up\n";
    | MoveDown -> print_string "Move down\n";
    | Action -> print_string "Action\n";
    | ActionTwo -> print_string "ActionTwo\n";
    | Help -> print_string "Help\n";
    | NoEvent -> ();
    | Quit -> 
        continue := false ;
        print_string "Exiting...\n";
    | _ -> print_string "nothing...\n";
  done
;;

let main () =
  let player1 = Player.create ()
  and map1 = Maze.create ()
  in
  ignore player1 ;
  ignore map1 ;
  Graphics.open_graph " 320x200+50+50";
  Graphics.set_window_title "Just Nuke It";
  game_loop ();
  Graphics.close_graph ()
;;

main ();
