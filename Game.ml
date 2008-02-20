(* vim: set st=2 sw=2 et : *)

let rec refresh_input () = 
  (* poll events *)
  let get_handler_fun ev = 
    match ev with
    (* key events *)
    | Sdlevent.KEYDOWN _ -> Keyboard.handle_event
    | Sdlevent.KEYUP _ -> Keyboard.handle_event
    (* mouse events *)
    | Sdlevent.MOUSEMOTION _ -> Mouse.handle_event
    | Sdlevent.MOUSEBUTTONDOWN _ -> Mouse.handle_event
    | Sdlevent.MOUSEBUTTONUP _ -> Mouse.handle_event
    (* joystick events *)
    | Sdlevent.JOYAXISMOTION _ -> Joystick.handle_event
    | Sdlevent.JOYBALLMOTION _ -> Joystick.handle_event
    | Sdlevent.JOYHATMOTION _ -> Joystick.handle_event
    | Sdlevent.JOYBUTTONDOWN _ -> Joystick.handle_event
    | Sdlevent.JOYBUTTONUP _ -> Joystick.handle_event
    (* video events *)
    | Sdlevent.VIDEORESIZE _ -> ignore
    | Sdlevent.VIDEOEXPOSE -> ignore
    | Sdlevent.ACTIVE _ -> ignore
    (* system events *)
    | Sdlevent.QUIT -> ignore
    | Sdlevent.SYSWM -> ignore
    (* user defined events *)
    | Sdlevent.USER _ -> ignore
  in

  let some_event = Sdlevent.poll ()
  in

  match some_event with
  | Some ev -> 
      if ev = Sdlevent.QUIT then ()
      else
        let handler_fun = get_handler_fun ev
        in 
        handler_fun ev ;
        refresh_input ()
    | None -> ()
;;
