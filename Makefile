RESULT=justnukeit
SOURCES=\
		Position.ml \
		Maze.ml \
		Player.ml \
		main.ml
LIBS=bigarray sdl unix
INCDIRS=+sdl
LIBDIRS=+sdl
OCAMLFLAGS=-w A -g -thread

all: native-code

-include OCamlMakefile
