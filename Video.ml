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
    (* FIXME: test that screen surface exists *)
    video.screen <- Some screen_surface ;

    let image_intro_filename = "images/intro.jpg" in
    let image_intro = Sdlloader.load_image image_intro_filename in
    let image_intro_position = Sdlvideo.rect 0 0 640 480
    in (
      (* fill with white *)
      Sdlvideo.fill_rect screen_surface (Sdlvideo.map_RGB screen_surface  Sdlvideo.white) ;
      Sdlvideo.put_pixel screen_surface ~x:160 ~y:100 
      (Sdlvideo.map_RGB screen_surface Sdlvideo.red);
      Sdlvideo.flip screen_surface ;
      (* draw intro image *)
      Sdlvideo.blit_surface ~dst_rect:image_intro_position
      ~src:image_intro ~dst:screen_surface ();
      Sdlvideo.flip screen_surface ;
    )
  )
;;


(* set parameters & title *)
(* { screen = Sdlvideo.set_video_mode config.width config.height [`DOUBLEBUF];
} *)

let handle_event anon_ev =
    ignore anon_ev ;
    []
;;
