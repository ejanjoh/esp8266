################################################################################
#
#       Autor:      Jan Johansson (ejanjoh)
#       Copyright:  Copyright (c) 2016 Jan Johansson (ejanjoh), All rights reserved.
#       Created:    2016-11-04
#       Updated:    
#
#       Project:    makefile esp210
#       File name:  make_esp210.mk
#
#
#       version history mapped on changes in this file:
#       -----------------------------------------------
#       ver 1:      Created
#       ver 3:      Corrected typo
#
#       Reference:  https://github.com/arduino/Arduino/wiki/Arduino-IDE-1.5-3rd-party-Hardware-specification
#                   https://github.com/esp8266/Arduino
#                   $(RUNTIME_PLATFORM_PATH)/boards.txt
#                   $(RUNTIME_PLATFORM_PATH)/platform.txt
#                   $(RUNTIME_PLATFORM_PATH)/programmers.txt
#
#       Note:       Tested on Mac OS X and Linux Debian, will most likely work 
#                   on Windows with modifications...
#
#       License:    This program is free software; you can redistribute it and/or
#                   modify it under the terms of the GNU General Public License as
#                   published by the Free Software Foundation; either version 2 of the 
#                   License, or (at your option) any later version.
#
#                   This program is distributed in the hope that it will be useful,
#                   but WITHOUT ANY WARRANTY; without even the implied warranty of 
#                   MERCHANTABILITY or FITNESS FOR A PARTICULAR /PURPOSE.  See the 
#                   GNU General Public License for more details.
#
################################################################################


# User defined, global predefined or by the ide "normaly" defined properties
TOOLS_PATH                  := <your path e.g. .../test>/Arduino15/packages/esp8266/tools/
ARDUINO_PATH                := <your path e.g. .../test>/
PROJ_PATH                   := <your path e.g. .../test/sketch_dir>

RUNTIME_PLATFORM_PATH       := $(ARDUINO_PATH)Arduino15/packages/esp8266/hardware/esp8266/2.3.0/
RUNTIME_TOOLS_XTENSA-LX106-ELF-GCC_PATH := $(TOOLS_PATH)xtensa-lx106-elf-gcc/1.20.0-26-gb404fb9-2/
RUNTIME_IDE_VERSION         := 10612
RUNTIME_TOOLS_ESPTOOL_PATH  := $(TOOLS_PATH)esptool/0.4.9/

BUILD_PATH                  := <your path e.g. .../test/build>
BUILD_F_CPU                 := 80000000L
BUILD_BOARD                 := ESP8266_ESP210
BUILD_ARCH                  := ESP8266
BUILD_CORE_PATH             := $(ARDUINO_PATH)Arduino15/packages/esp8266/hardware/esp8266/2.3.0/cores/esp8266/
BUILD_VARIANT_PATH          := $(RUNTIME_PLATFORM_PATH)variants/generic/
BUILD_PROJECT_NAME          := test
BUILD_FLASH_LD              := eagle.flash.4m.ld
BUILD_FLASH_MODE            := qio
BUILD_FLASH_FREQ            := 40
BUILD_FLASH_SIZE            := 4M

UPLOAD_VERBOSE              := -v
UPLOAD_RESETMETHOD          := ck
UPLOAD_SPEED                := 115200
SERIAL_PORT                 := /dev/cu.SLAB_USBtoUART


# Includes
INCLUDE                     := $(shell find $(PROJ_PATH) -name "*.h")
INCLUDE                     += $(shell find $(BUILD_CORE_PATH) -name "*.h")
INCLUDE                     += $(shell find $(BUILD_VARIANT_PATH) -name "*.h")
INCLUDE_PATHS               := $(sort $(dir $(INCLUDE)))
INCLUDES                    := $(foreach dir, $(INCLUDE_PATHS), -I $(dir))


# Source
TEMP_PROJ_PATHS             := $(shell find $(PROJ_PATH) -type d)
TEMP_CORE_PATHS             := $(shell find $(BUILD_CORE_PATH) -type d)
VPATH                       := $(TEMP_PROJ_PATHS) 
VPATH                       += $(TEMP_CORE_PATHS)


# Objects - Note, the linker script used in this environment need the source
# file extension before the object file extension. In addition ".ino" ---> ".cpp.o"
OBJECT_FILES    := $(foreach dir, $(VPATH), $(patsubst $(dir)/%.S, $(BUILD_PATH)/%.S.o, $(wildcard $(dir)/*.S)))
OBJECT_FILES    += $(foreach dir, $(VPATH), $(patsubst $(dir)/%.c, $(BUILD_PATH)/%.c.o, $(wildcard $(dir)/*.c)))
OBJECT_FILES    += $(foreach dir, $(VPATH), $(patsubst $(dir)/%.cpp, $(BUILD_PATH)/%.cpp.o, $(wildcard $(dir)/*.cpp)))
OBJECT_FILES    += $(foreach dir, $(VPATH), $(patsubst $(dir)/%.ino, $(BUILD_PATH)/%.cpp.o, $(wildcard $(dir)/*.ino)))

PROJ_OBJ_FILES  := $(foreach dir, $(TEMP_PROJ_PATHS), $(patsubst $(dir)/%.S, $(BUILD_PATH)/%.S.o, $(wildcard $(dir)/*.S)))
PROJ_OBJ_FILES  += $(foreach dir, $(TEMP_PROJ_PATHS), $(patsubst $(dir)/%.c, $(BUILD_PATH)/%.c.o, $(wildcard $(dir)/*.c)))
PROJ_OBJ_FILES  += $(foreach dir, $(TEMP_PROJ_PATHS), $(patsubst $(dir)/%.cpp, $(BUILD_PATH)/%.cpp.o, $(wildcard $(dir)/*.cpp)))
PROJ_OBJ_FILES  += $(foreach dir, $(TEMP_PROJ_PATHS), $(patsubst $(dir)/%.ino, $(BUILD_PATH)/%.cpp.o, $(wildcard $(dir)/*.ino)))

CORE_OBJ_FILES  := $(foreach dir, $(TEMP_CORE_PATHS), $(patsubst $(dir)/%.S, $(BUILD_PATH)/%.S.o, $(wildcard $(dir)/*.S)))
CORE_OBJ_FILES  += $(foreach dir, $(TEMP_CORE_PATHS), $(patsubst $(dir)/%.c, $(BUILD_PATH)/%.c.o, $(wildcard $(dir)/*.c)))
CORE_OBJ_FILES  += $(foreach dir, $(TEMP_CORE_PATHS), $(patsubst $(dir)/%.cpp, $(BUILD_PATH)/%.cpp.o, $(wildcard $(dir)/*.cpp)))


# Tools paths
COMPILER_PATH               := $(RUNTIME_TOOLS_XTENSA-LX106-ELF-GCC_PATH)/bin/
COMPILER_SDK_PATH           := $(RUNTIME_PLATFORM_PATH)tools/sdk/
PATH                        := $(RUNTIME_TOOLS_ESPTOOL_PATH)


# Tools
COMPILER_C_CMD              := xtensa-lx106-elf-gcc
COMPILER_CPP_CMD            := xtensa-lx106-elf-g++
COMPILER_AR_CMD             := xtensa-lx106-elf-ar
COMPILER_C_ELF_CMD          := xtensa-lx106-elf-gcc
COMPILER_ESPTOOL_CMD        := esptool
COMPILER_SIZE_CMD           := xtensa-lx106-elf-size
CMD                         := $(COMPILER_ESPTOOL_CMD)
COMPILER_OBJDUMP_CMD        := xtensa-lx106-elf-objdump
COMPILER_READELF_CMD        := xtensa-lx106-elf-readelf


# Build flags etc:
COMPILER_WARNING_FLAGS          := -w

BUILD_LWIP_FLAGS                := -DLWIP_OPEN_SRC

COMPILER_CPREPROCESSOR_FLAGS    := -D__ets__ -DICACHE_FLASH -U__STRICT_ANSI__ 
COMPILER_CPREPROCESSOR_FLAGS    += -I $(COMPILER_SDK_PATH)/include -I $(COMPILER_SDK_PATH)/lwip/include
COMPILER_CPREPROCESSOR_FLAGS    += -I $(BUILD_PATH)/core

COMPILER_S_FLAGS                := -c -g -x assembler-with-cpp -MMD -mlongcalls

COMPILER_C_FLAGS                := -c $(COMPILER_WARNING_FLAGS) -Os -g -Wpointer-arith
COMPILER_C_FLAGS                += -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib
COMPILER_C_FLAGS                += -mlongcalls -mtext-section-literals -falign-functions=4 -MMD -std=gnu99
COMPILER_C_FLAGS                += -ffunction-sections -fdata-sections

COMPILER_CPP_FLAGS              := -c $(COMPILER_WARNING_FLAGS) -Os -g -mlongcalls -mtext-section-literals 
COMPILER_CPP_FLAGS              += -fno-exceptions -fno-rtti -falign-functions=4 -std=c++11 -MMD -ffunction-sections 
COMPILER_CPP_FLAGS              += -fdata-sections

COMPILER_AR_FLAGS               := cru

COMPILER_C_ELF_FLAGS            := -g $(COMPILER_WARNING_FLAGS) -Os -nostdlib -Wl,--no-check-sections 
COMPILER_C_ELF_FLAGS            += -u call_user_start -Wl,-static -L$(COMPILER_SDK_PATH)/lib -L$(COMPILER_SDK_PATH)/ld
COMPILER_C_ELF_FLAGS            += -T$(BUILD_FLASH_LD) -Wl,--gc-sections -Wl,-wrap,system_restart_local 
COMPILER_C_ELF_FLAGS            += -Wl,-wrap,register_chipv6_phy

BUILD_LWIP_LIB                  := -llwip_gcc

COMPILER_C_ELF_LIBS             := -lm -lgcc -lhal -lphy -lpp -lnet80211 -lwpa -lcrypto -lmain -lwps -laxtls 
COMPILER_C_ELF_LIBS             += -lsmartconfig -lmesh -lwpa2 $(BUILD_LWIP_LIB) -lstdc++


# Recipes
RECIPE_S_O_PATTERN          := $(COMPILER_PATH)$(COMPILER_C_CMD) $(COMPILER_CPREPROCESSOR_FLAGS) $(COMPILER_S_FLAGS)
RECIPE_S_O_PATTERN          += -DF_CPU=$(BUILD_F_CPU) $(BUILD_LWIP_FLAGS) -DARDUINO=$(RUNTIME_IDE_VERSION)
RECIPE_S_O_PATTERN          += -DARDUINO_$(BUILD_BOARD) -DARDUINO_ARCH_$(BUILD_ARCH) -DARDUINO_BOARD=$(BUILD_BOARD)
RECIPE_S_O_PATTERN          += $(INCLUDES)

RECIPE_C_O_PATTERN          := $(COMPILER_PATH)$(COMPILER_C_CMD) $(COMPILER_CPREPROCESSOR_FLAGS) $(COMPILER_C_FLAGS)
RECIPE_C_O_PATTERN          += -DF_CPU=$(BUILD_F_CPU) $(BUILD_LWIP_FLAGS) -DARDUINO=$(RUNTIME_IDE_VERSION)
RECIPE_C_O_PATTERN          += -DARDUINO_$(BUILD_BOARD) -DARDUINO_ARCH_$(BUILD_ARCH) -DARDUINO_BOARD=$(BUILD_BOARD)
RECIPE_C_O_PATTERN          += $(INCLUDES) 

RECIPE_CPP_O_PATTERN        := $(COMPILER_PATH)$(COMPILER_CPP_CMD) $(COMPILER_CPREPROCESSOR_FLAGS) $(COMPILER_CPP_FLAGS)
RECIPE_CPP_O_PATTERN        += -DF_CPU=$(BUILD_F_CPU) $(BUILD_LWIP_FLAGS) -DARDUINO=$(RUNTIME_IDE_VERSION)
RECIPE_CPP_O_PATTERN        += -DARDUINO_$(BUILD_BOARD) -DARDUINO_ARCH_$(BUILD_ARCH) -DARDUINO_BOARD=$(BUILD_BOARD)
RECIPE_CPP_O_PATTERN        += $(INCLUDES)

RECIPE_INO_O_PATTERN        := $(RECIPE_CPP_O_PATTERN)  -x c++ -include $(BUILD_CORE_PATH)Arduino.h

RECIPE_AR_PATTERN           := $(COMPILER_PATH)$(COMPILER_AR_CMD) $(COMPILER_AR_FLAGS) $(BUILD_PATH)/arduino.ar 
RECIPE_AR_PATTERN           += $(CORE_OBJ_FILES)

RECIPE_C_COMBINE_PATTERN    := $(COMPILER_PATH)$(COMPILER_C_ELF_CMD) $(COMPILER_C_ELF_FLAGS) 
RECIPE_C_COMBINE_PATTERN    += -o $(BUILD_PATH)$(BUILD_PROJECT_NAME).elf -Wl,--start-group $(OBJECT_FILES) 
RECIPE_C_COMBINE_PATTERN    += $(BUILD_PATH)arduino.ar 
RECIPE_C_COMBINE_PATTERN    += $(COMPILER_C_ELF_LIBS) -Wl,--end-group  -L$(BUILD_PATH)

RECIPE_OBJCOPY_HEX_PATTERN  := $(RUNTIME_TOOLS_ESPTOOL_PATH)$(COMPILER_ESPTOOL_CMD) 
RECIPE_OBJCOPY_HEX_PATTERN  += -eo $(RUNTIME_PLATFORM_PATH)/bootloaders/eboot/eboot.elf 
RECIPE_OBJCOPY_HEX_PATTERN  += -bo $(BUILD_PATH)$(BUILD_PROJECT_NAME).bin 
RECIPE_OBJCOPY_HEX_PATTERN  += -bm $(BUILD_FLASH_MODE) -bf $(BUILD_FLASH_FREQ) -bz $(BUILD_FLASH_SIZE) 
RECIPE_OBJCOPY_HEX_PATTERN  += -bs .text -bp 4096 -ec -eo $(BUILD_PATH)$(BUILD_PROJECT_NAME).elf 
RECIPE_OBJCOPY_HEX_PATTERN  += -bs .irom0.text -bs .text -bs .data -bs .rodata -bc -ec

RECIPE_SIZE_PATTERN         := $(COMPILER_PATH)$(COMPILER_SIZE_CMD) -A $(BUILD_PATH)$(BUILD_PROJECT_NAME).elf

TOOLS_ESPTOOL_UPLOAD_PATTERN := $(PATH)$(CMD) $(UPLOAD_VERBOSE) -cd $(UPLOAD_RESETMETHOD) -cb $(UPLOAD_SPEED) 
TOOLS_ESPTOOL_UPLOAD_PATTERN += -cp $(SERIAL_PORT) -ca 0x00000 -cf $(BUILD_PATH)$(BUILD_PROJECT_NAME).bin

RECIPE_EXTRA_1_PATTERN      := @$(COMPILER_PATH)$(COMPILER_OBJDUMP_CMD) -D $(BUILD_PATH)$(BUILD_PROJECT_NAME).elf 
RECIPE_EXTRA_1_PATTERN      += > $(BUILD_PATH)$(BUILD_PROJECT_NAME).list

RECIPE_EXTRA_2_PATTERN      := @$(COMPILER_PATH)$(COMPILER_READELF_CMD) -S $(BUILD_PATH)$(BUILD_PROJECT_NAME).elf 
RECIPE_EXTRA_2_PATTERN      += > $(BUILD_PATH)$(BUILD_PROJECT_NAME).section.heads

RECIPE_EXTRA_3_PATTERN      := @$(COMPILER_PATH)$(COMPILER_OBJDUMP_CMD) -D 
RECIPE_EXTRA_3_PATTERN      += $(RUNTIME_PLATFORM_PATH)/bootloaders/eboot/eboot.elf
RECIPE_EXTRA_3_PATTERN      += > $(BUILD_PATH)eboot.list

RECIPE_EXTRA_4_PATTERN      := @$(COMPILER_PATH)$(COMPILER_READELF_CMD) -S 
RECIPE_EXTRA_4_PATTERN      += $(RUNTIME_PLATFORM_PATH)/bootloaders/eboot/eboot.elf
RECIPE_EXTRA_4_PATTERN      += > $(BUILD_PATH)eboot.section.heads


# Rule to build all
all : $(BUILD_PATH)$(BUILD_PROJECT_NAME).bin 

# Rule to convert the elf format to bin format
$(BUILD_PATH)$(BUILD_PROJECT_NAME).bin : $(BUILD_PATH)$(BUILD_PROJECT_NAME).elf
	$(RECIPE_OBJCOPY_HEX_PATTERN)

# Rule to link it together
$(BUILD_PATH)$(BUILD_PROJECT_NAME).elf : $(BUILD_PATH)arduino.ar $(OBJECT_FILES)
	$(RECIPE_C_COMBINE_PATTERN)

# Rule to build the arduino.ar archive file
$(BUILD_PATH)arduino.ar : $(CORE_OBJ_FILES)
	$(RECIPE_AR_PATTERN)

# Rule to compile the ino file:
$(BUILD_PATH)/%.cpp.o : %.ino  
	$(RECIPE_INO_O_PATTERN) $< -o $@

# Rule to compile the C++ files:
$(BUILD_PATH)/%.cpp.o : %.cpp  
	$(RECIPE_CPP_O_PATTERN) $< -o $@

# Rule to compile the C files:
$(BUILD_PATH)/%.c.o : %.c
	$(RECIPE_C_O_PATTERN) $< -o $@

# Rule to assembly the asm files:
$(BUILD_PATH)/%.S.o : %.S
	$(RECIPE_S_O_PATTERN) $< -o $@


# Rule to clean up a build:
clean :
	$(shell rm -f $(BUILD_PATH)*)


# Rule to calculate the size
size :
	$(RECIPE_SIZE_PATTERN)


# Rule to upload a sketch to the target board (using a bootloader preinstalled on the board)
upload :
	$(TOOLS_ESPTOOL_UPLOAD_PATTERN)


# Rule to create list files and files containing the section headers for:
#   - your project including core files etc: <proj name>.list and <proj name>.section.heads
#   - eboot: eboot.list and eboot.section.heads
extra :
	$(RECIPE_EXTRA_1_PATTERN)
	$(RECIPE_EXTRA_2_PATTERN)
	$(RECIPE_EXTRA_3_PATTERN)
	$(RECIPE_EXTRA_4_PATTERN)






