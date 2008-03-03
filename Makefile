PROGRAMS=justnukeit

justnukeit_OBJS= \
				 Position \
				 Timeline \
				 Mouse \
				 Joystick \
				 Keyboard \
				 Menu \
				 Level \
				 Player \
				 Video \
				 Game \
				 main

justnukeit_INCS=sdl
justnukeit_LIBS=graphics unix threads bigarray sdl sdlloader sdlttf

MLI=$(wildcard *.mli)
ML=$(wildcard *.ml)

CMI=$(patsubst %.mli,%.cmi,$(MLI))
CMO=$(patsubst %.ml,%.cmo,$(ML))
CMX=$(patsubst %.ml,%.cmx,$(ML))

OCAMLDEP=ocamldep
OCAMLOPT=ocamlopt
OCAMLC=ocamlc

INCS=-I +sdl
LIBS=-ccopt -L+sdl
OPTS=-w A -g -thread $(INCS) $(LIBS)

define PROGRAM_template
ALL_OBJS   += $($(1)_OBJS)
$(1): $$($(1)_OBJS:=.cmx)
	@echo -n -e "\x1B[31;1m"
	@echo "[L] $(1)"
	@echo -n -e "\x1B[0m"
	$(OCAMLOPT) $(OPTS) $($(1)_LIBS:=.cmxa) $($(1)_OBJS:=.cmx) -o $(1)
	@echo ""
endef

$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAM_template,$(prog))))

.PHONY: all
all: $(PROGRAMS)

doc: $(ML) $(MLI)
	ocamldoc $(INCS) -d doc -html $(ML) $(MLI)

%.cmi: %.mli
	@echo -n -e "\x1B[31;1m"
	@echo "[I] $<"
	@echo -n -e "\x1B[0m"
	$(OCAMLOPT) $(OPTS) -i $<
	$(OCAMLOPT) $(OPTS) -c $<
	@echo ""

%.cmx: %.ml
	@echo -n -e "\x1B[31;1m"
	@echo "[C] $<"
	@echo -n -e "\x1B[0m"
	$(OCAMLOPT) $(OPTS) -i $<
	$(OCAMLOPT) $(OPTS) -c $<
	@echo ""

%.cmo %.cmi: %.ml %.cmi %.mli
	@echo "[O] $<"
	$(OCAMLC) $(OPTS) -i $<
	$(OCAMLC) $(OPTS) -c $<
	echo ""

%.cmo %.cmi: %.ml
	@echo -n -e "\x1B[31;1m"
	@echo "[O] $<"
	@echo -n -e "\x1B[0m"
	$(OCAMLC) $(OPTS) -i $<
	$(OCAMLC) $(OPTS) -c $<
	echo ""

clean:
	rm -f $(PROGRAMS) *~ *.cm* *.o *.a *.so .depend *.cmxa *.cma

.depend: $(ML) $(MLI)
	$(OCAMLDEP) $(ML) $(MLI) > .depend
	@echo ""


.SUFFIXES:

-include .depend

