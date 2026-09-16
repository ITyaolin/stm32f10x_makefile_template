
# toolchain
TOOLCHAIN    = arm-none-eabi-
CC           = $(TOOLCHAIN)gcc
CP           = $(TOOLCHAIN)objcopy
AS           = $(TOOLCHAIN)gcc -x assembler-with-cpp
HEX          = $(CP) -O ihex
BIN          = $(CP) -O binary -S

# define mcu, specify the target processor
MCU          = cortex-m3

# all the files will be generated with this name (main.elf, main.bin, main.hex, etc)
PROJECT_NAME=stm32f10x_makefile_template

# output directory
OUTPUT_DIR   = output

# specify define
DDEFS       =

# define root dir
ROOT_DIR     = .

# define include dir
INCLUDE_DIRS = .

# define stm32f10x lib dir
STM32F10x_LIB_DIR      = $(ROOT_DIR)/stm32f10x_lib

# define user dir
USER_DIR     = $(ROOT_DIR)/user

# link file
LINK_SCRIPT  = $(ROOT_DIR)/stm32_flash.ld

# stm32f10x lib src
STM32F10X_LIB_SRC      =

# user specific
SRC         =
SRC         += $(USER_DIR)/main.c

ASM_SRC      =

# user include
INCLUDE_DIRS  += $(USER_DIR)

# include sub makefiles
include makefile_std_lib.mk  # STM32 Standard Peripheral Library

INC_DIR  = $(patsubst %, -I%, $(INCLUDE_DIRS))

# run from Flash
DEFS	 = $(DDEFS) -DRUN_FROM_FLASH=1

# build output paths (mirror source tree under output/)
OBJECTS = $(addprefix $(OUTPUT_DIR)/, $(ASM_SRC:.s=.o) $(SRC:.c=.o) $(STM32F10X_LIB_SRC:.c=.o))

# collect unique output directories
OBJ_DIRS = $(sort $(dir $(OBJECTS)))

# Define optimisation level here
OPT = -Os

MC_FLAGS = -mcpu=$(MCU)

AS_FLAGS = $(MC_FLAGS) -g -gdwarf-2 -mthumb -Wa,-amhls=$(@:.o=.lst)
CP_FLAGS = $(MC_FLAGS) $(OPT) -g -gdwarf-2 -mthumb -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(@:.o=.lst) $(DEFS)
LD_FLAGS = $(MC_FLAGS) -g -gdwarf-2 -mthumb -nostartfiles -Xlinker --gc-sections -T$(LINK_SCRIPT) -Wl,-Map=$(OUTPUT_DIR)/$(PROJECT_NAME).map,--cref,--no-warn-mismatch

#
# makefile rules
#
all: $(OBJ_DIRS) $(OBJECTS) $(OUTPUT_DIR)/$(PROJECT_NAME).elf $(OUTPUT_DIR)/$(PROJECT_NAME).hex $(OUTPUT_DIR)/$(PROJECT_NAME).bin
	$(TOOLCHAIN)size $(OUTPUT_DIR)/$(PROJECT_NAME).elf

# create output directories (order-only prerequisite)
$(OBJ_DIRS):
	mkdir -p $@

# compile .c -> .o
$(OUTPUT_DIR)/%.o: %.c
	$(CC) -c $(CP_FLAGS) -I . $(INC_DIR) $< -o $@

# assemble .s -> .o
$(OUTPUT_DIR)/%.o: %.s
	$(AS) -c $(AS_FLAGS) $< -o $@

# link
$(OUTPUT_DIR)/%.elf: $(OBJECTS)
	$(CC) $(OBJECTS) $(LD_FLAGS) -o $@

$(OUTPUT_DIR)/%.hex: $(OUTPUT_DIR)/%.elf
	$(HEX) $< $@

$(OUTPUT_DIR)/%.bin: $(OUTPUT_DIR)/%.elf
	$(BIN)  $< $@

flash: $(OUTPUT_DIR)/$(PROJECT_NAME).bin
	st-flash write $(OUTPUT_DIR)/$(PROJECT_NAME).bin 0x8000000

erase:
	st-flash erase

clean:
	-rm -rf $(OUTPUT_DIR)
