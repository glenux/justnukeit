
let rec refresh_input () = 
    (* poll events *)
    let get_handler_fun ev = 
        match ev with
        | Sdlevent.KEYDOWN _ -> Keyboard.handle_event
        | Sdlevent.KEYUP _ -> Keyboard.handle_event

        | Sdlevent.MOUSEMOTION _ -> Mouse.handle_event
        | Sdlevent.MOUSEBUTTONDOWN _ -> Mouse.handle_event
        | Sdlevent.MOUSEBUTTONUP _ -> Mouse.handle_event

        (*
        | Sdlevent.JOYAXISMOTION _ -> Joystick.handle_event
        | Sdlevent.JOYBALLMOTION _ -> Joystick.handle_event
        | Sdlevent.JOYHATMOTION _ -> Joystick.handle_event
        | Sdlevent.JOYBUTTONDOWN _ -> Joystick.handle_event
        | Sdlevent.JOYBUTTONUP _ -> Joystick.handle_event
        *)

        | _ -> ignore
    in

    let some_event = Sdlevent.poll ()
    in

    match some_event with
    | Some Sdlevent.QUIT -> ()
    | Some ev -> 
        let handler_fun = get_handler_fun ev
        in 
        handler_fun ev ;
        refresh_input ()
    | None -> ()
;;
