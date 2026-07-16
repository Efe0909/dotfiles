local ls = require 'luasnip'
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s(
    { trig = 'mkproj', dscr = 'Simple, reliable Makefile scaffold (src → build → bin)' },
    fmt(
      [[
# ── {project} build script ───────────────────────────────────────────────
SRC_DIR := src
OBJ_DIR := build
BIN_DIR := bin

# ---------------------------------------------------------------
# 🔧 Build profile ─ pick ONE by setting BUILD=debug|release|sanitize
# (override from CLI: make BUILD=release)
# ---------------------------------------------------------------
BUILD ?= debug

# ---------------------------------------------------------------
# Compiler / flags (baseline)
# ---------------------------------------------------------------
CC       ?= gcc
CXX      ?= g++
BASEWARN  = -Wall -Wextra
CFLAGS    = $(BASEWARN)
CXXFLAGS  = $(BASEWARN)
LDFLAGS  ?=

# ---------------------------------------------------------------
# 🚦 Profile switches (auto-append to CFLAGS/CXXFLAGS)
# ---------------------------------------------------------------
ifeq ($(BUILD),debug)
  CFLAGS   += -O0 -g -DDEBUG
  CXXFLAGS += -O0 -g -DDEBUG
endif

ifeq ($(BUILD),release)
  CFLAGS   += -O2 -DNDEBUG
  CXXFLAGS += -O2 -DNDEBUG
endif

ifeq ($(BUILD),sanitize)
  CFLAGS   += -O1 -g -fsanitize=address -fno-omit-frame-pointer
  CXXFLAGS += -O1 -g -fsanitize=address -fno-omit-frame-pointer
  LDFLAGS  += -fsanitize=address
endif

# ---------------------------------------------------------------
# Source / object lists
# ---------------------------------------------------------------
CSRC      := $(wildcard $(SRC_DIR)/*.c)
CPPSRC    := $(wildcard $(SRC_DIR)/*.cpp)
OBJ_C     := $(patsubst $(SRC_DIR)/%.c,  $(OBJ_DIR)/%.o, $(CSRC))
OBJ_CPP   := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o, $(CPPSRC))
OBJECTS   := $(OBJ_C) $(OBJ_CPP)

TARGET    := $(BIN_DIR)/{bin}

.PHONY: all clean rebuild dirs

all: dirs $(TARGET)

dirs:
	@mkdir -p $(OBJ_DIR) $(BIN_DIR)

# ---------------------------------------------------------------
# %.c / %.cpp  →  %.o
# ---------------------------------------------------------------
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC)  $(CFLAGS)  -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ---------------------------------------------------------------
# Link objects into final binary
# ---------------------------------------------------------------
$(TARGET): $(OBJECTS)
	$(CXX) $^ $(LDFLAGS) -o $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

rebuild: clean all
# ─────────────────────────────────────────────────────────────────────
      ]],
      {
        project = i(1, 'ProjectName'),
        bin = i(2, 'app'),
      }
    )
  ),
}
