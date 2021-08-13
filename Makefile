CC = gcc
CPPFLAGS = -MMD
CFLAGS = -Wall -Wextra -std=c99 -ggdb -O3
LDFLAGS =
LDLIBS = 
VALGRIND_FLAGS = --tool=cachegrind --branch-sim=yes -q

NROWS ?= 600
NCOLS ?= 600
CPPFLAGS += -DNROWS=$(NROWS) -DNCOLS=$(NCOLS)

SRC_DIR = ./src
BUILD_DIR = ./build

TARGET = cache_experiments

SRC = $(wildcard $(SRC_DIR)/*.c)

OBJ = $(SRC:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
ASM = $(SRC:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.s)
DEP = $(OBJ:%.o=%.d)

.PHONY: all cache run debug asm disasm clean

all: $(BUILD_DIR)/$(TARGET)

cache: cg_annotate.row.out cg_annotate.col.out
	./cache_report.sh $^

cachegrind.%.out: all
	valgrind $(VALGRIND_FLAGS) --cachegrind-out-file=$@ $(BUILD_DIR)/$(TARGET) $* 1

cg_annotate.%.out: cachegrind.%.out
	cg_annotate $< > $@

N ?= 5000
RUN_N ?= 3

run: all
	@echo $N iterations
	@echo "ROW-MAJOR:"
	@for n in `seq 1 $(RUN_N)`; do /usr/bin/time -f "%e" $(BUILD_DIR)/$(TARGET) row $N > /dev/null ; done
	@echo "COL-MAJOR:"
	@for n in `seq 1 $(RUN_N)`; do /usr/bin/time -f "%e" $(BUILD_DIR)/$(TARGET) col $N > /dev/null ; done

debug: all
	gdb $(BUILD_DIR)/$(TARGET)

asm: $(ASM)

disasm: $(BUILD_DIR)/disasm.out

clean:
	rm -rf $(BUILD_DIR) *.out.* *.out

.PHONY: F5 F6 F7 F8
F5: all
F6: run
F7: cache
F8: debug

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

$(BUILD_DIR)/disasm.out: $(BUILD_DIR)/$(TARGET)
	objdump -dS $< > $@
