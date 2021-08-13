CC = gcc
CPPFLAGS = -MMD
CFLAGS = -Wall -Wextra -std=c99 -ggdb
LDFLAGS =
LDLIBS = 

NROWS ?= 550
NCOLS ?= 550
CPPFLAGS += -DNROWS=$(NROWS) -DNCOLS=$(NCOLS)

SRC_DIR = ./src
BUILD_DIR = ./build

TARGET = cache_experiments

SRC = $(wildcard $(SRC_DIR)/*.c)

OBJ = $(SRC:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
ASM = $(SRC:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.s)
DEP = $(OBJ:%.o=%.d)

.PHONY: F5 F6 F7 F8

F5: all
F6: run
F7: cache
F8: debug

.PHONY: all cache run debug asm clean

all: $(BUILD_DIR)/$(TARGET)

N ?= 1000
RUN_N ?= 3

VALGRIND_FLAGS = --tool=cachegrind --branch-sim=yes --cachegrind-out-file=cachegrind.out
cache: all 
	valgrind $(VALGRIND_FLAGS) $(BUILD_DIR)/$(TARGET) row 1
	cg_annotate cachegrind.out | tee row_cg_annotate.out
	valgrind $(VALGRIND_FLAGS) $(BUILD_DIR)/$(TARGET) col 1
	cg_annotate cachegrind.out | tee col_cg_annotate.out
	./cache_report.sh row_cg_annotate.out col_cg_annotate.out

run: all
	@echo "ROW-MAJOR:"
	@for n in `seq 1 $(RUN_N)`; do /usr/bin/time -f "%e" $(BUILD_DIR)/$(TARGET) row $(N) > /dev/null ; done
	@echo "COL-MAJOR:"
	@for n in `seq 1 $(RUN_N)`; do /usr/bin/time -f "%e" $(BUILD_DIR)/$(TARGET) col $(N) > /dev/null ; done

debug: all
	gdb $(BUILD_DIR)/$(TARGET)

asm: $(ASM)

clean:
	rm -rf $(BUILD_DIR) *.out.* *.out

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/$(TARGET): $(OBJ)
	mkdir -p $(BUILD_DIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(BUILD_DIR)/%.s: $(SRC_DIR)/%.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -S -o $@ $<

-include $(DEP)
