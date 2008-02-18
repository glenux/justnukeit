PROGRAMS=justnukeit

justnukeit_OBJS=Position.cmx Maze.cmx Player.cmx main.cmx
justnukeit_LIBS=graphics.cmxa unix.cmxa threads.cmxa

MODULES=$(patsubst %.mli,%,$(wildcard *.mli)) $(patsubst %.ml,%,$(wildcard *.ml))

CMI=$(patsubst %.ml,%.cmi,$(MODULES:=.ml))
CMO=$(patsubst %.ml,%.cmo,$(MODULES:=.ml))
CMX=$(patsubst %.ml,%.cmx,$(MODULES:=.ml))
LIB=

OCAMLDEP=ocamldep
OCAMLOPT=ocamlopt
OCAMLC=ocamlc

OPTS=-w A -g -thread

define PROGRAM_template
ALL_OBJS   += $$($(1)_OBJS)
$(1): $$($(1)_OBJS)
	@echo -n -e "\x1B[31;1m"
	@echo "[L] $@"
	@echo -n -e "\x1B[0m"
	$(OCAMLOPT) $(OPTS) $($(1)_LIBS) $($(1)_OBJS) -o $(1)
	@echo ""
endef

$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAM_template,$(prog))))

.PHONY: all
all: $(PROGRAMS)

%.cmi: %.mli
	@echo -n -e "\x1B[31;1m"
	@echo "[I] $<"
	@echo -n -e "\x1B[0m"
	@$(OCAMLC) -i $<
	#@$(OCAMLC) $(OPTS) -c $<
	@$(OCAMLOPT) $(OPTS) -c $<
	@echo ""

%.cmx: %.ml
	@echo -n -e "\x1B[31;1m"
	@echo "[C] $<"
	@echo -n -e "\x1B[0m"
	@$(OCAMLOPT) $(OPTS) -i $<
	@$(OCAMLOPT) $(OPTS) -c $<
	@echo ""

%.cmo %.cmi: %.ml %.cmi %.mli
	@echo "[O] $<"
	@$(OCAMLC) -i $<
	@$(OCAMLC) $(OPTS) -c $<
	echo ""

%.cmo %.cmi: %.ml
	@echo -n -e "\x1B[31;1m"
	@echo "[O] $<"
	@echo -n -e "\x1B[0m"
	@$(OCAMLC) -i $<
	@$(OCAMLC) $(OPTS) -c $<
	echo ""

clean:
	rm -f $(PROGRAMS) *~ *.cm* *.o *.a *.so .depend *.cmxa *.cma

.depend: $(MODULES:=.ml)
	$(OCAMLDEP) $(MODULES:=.ml) $(MODULES:=.mli) > .depend
	@echo ""


.SUFFIXES:

-include .depend

