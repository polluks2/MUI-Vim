#------------------------------------------------------------------------------------------
# Host settings
#------------------------------------------------------------------------------------------
UNM?=$(shell uname)
ifeq ($(UNM),AmigaOS)
ifeq ($(shell uname),AmigaOS)
GOP=-E # Only if we're not cross compiling.
endif
MKF:=Make_ami.mak
else ifeq ($(UNM),AROS)
MKF:=Make_ami.mak
else ifeq ($(UNM),MorphOS)
MKF:=Make_ami.mak
else
#-This is just for testing purposes--------------------------------------------------------
MKF:=Makefile
endif

#------------------------------------------------------------------------------------------
# General settings
#------------------------------------------------------------------------------------------
SRC:=src
DST:=dist
VER=$(shell cat $(SRC)/.ver)
PAT=$(shell cat $(SRC)/.pat)

#------------------------------------------------------------------------------------------
# Build Vim
#------------------------------------------------------------------------------------------
.PHONY: vim
vim: $(SRC)/.ver $(SRC)/.pat
	$(MAKE) -C $(SRC) -f $(MKF) PATCHLEVEL=$(PAT)

#------------------------------------------------------------------------------------------
# Create archive
#------------------------------------------------------------------------------------------
.PHONY: $(DST)
$(DST): vim
	$(MAKE) -C $(DST) VER=$(VER) REV=$(PAT)

#------------------------------------------------------------------------------------------
# Determine version
#------------------------------------------------------------------------------------------
$(SRC)/.ver: $(SRC)/version.h
	@echo $(VDOT) > $@

#------------------------------------------------------------------------------------------
# Determine patch number
#------------------------------------------------------------------------------------------
$(SRC)/.pat: $(SRC)/version.c
	grep $(GOP) -m1 "^ \{4\}[0-9]\{1,4\}," $< | tr -d "[:space:]," > $@

#------------------------------------------------------------------------------------------
# Clean up
#------------------------------------------------------------------------------------------
.PHONY: clean
clean:
	$(MAKE) -C $(DST) $@
	$(MAKE) -C $(SRC) -f $(MKF) $@
	rm -f $(SRC)/.pat $(SRC)/.ver
