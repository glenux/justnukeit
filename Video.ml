(* vim: set st=2 sw=2 et : *)

type t = {
  mutable screen : Sdlvideo.surface option;
  mutable height: int;
  mutable width : int
};;


let video = { 
  width = 0 ;
  height = 0 ;
  screen = None
};;

(** Initialize video, open windows, etc. *)
let init config = 
  Sdl.init [`VIDEO] ;
  at_exit Sdl.quit ;
  Sdlttf.init () ;
  at_exit Sdlttf.quit ;
  let bpp = 
    Sdlvideo.video_mode_ok 
    ~w:config.Config.video_width 
    ~h:config.Config.video_height 
    ~bpp:32
    [`DOUBLEBUF]
  in
  let screen_surface = 
    Sdlvideo.set_video_mode 
    ~w:config.Config.video_width 
    ~h:config.Config.video_height
    ~bpp:bpp
    [`DOUBLEBUF]
  in (
    video.width <- config.Config.video_width ;
    video.height <- config.Config.video_height ;
    video.screen <- Some screen_surface
  )
;;


(* set parameters & title *)
(* { screen = Sdlvideo.set_video_mode config.width config.height [`DOUBLEBUF];
} *)

let handle_event anon_ev =
    ignore anon_ev ;
    []
;;
