# ESP8266
### ESP210 – makefile

A makefile to build Arduino projects to a SweetPea ESP210 bord. The makefile will work on other ESP8266 variants as well with some modifications. It is tested and builds on Mac OS X and Linux (Debian); it will, however, not run out of the box on Windows.

The environment used is based on the 2.3.0 version of the [esp8266/Arduino project](https://github.com/esp8266/Arduino) that brings support for the ESP8266 bords to the Arduino IDE. It contain all the software needed to make use of features as WiFi, filesystem etc. The later needs some modification on some core files.

As stated in [Arduino IDE 1.5 3rd party Hardware specification](https://github.com/arduino/Arduino/wiki/Arduino-IDE-1.5-3rd-party-Hardware-specification) there must be three files in the root:

* __platform.txt__ contains definitions for the CPU architecture used (compiler, build process parameters, tools used for upload, etc.)
* __boards.txt__ contains definitions for the boards (board name, parameters for building and uploading sketches, etc.)
* __programmers.txt__ contains definitions for external programmers (typically used to burn bootloaders or sketches on a blank CPU/board)

These three files are especially intresting because they constitute the makefile; they contain all information needed and the files configure the different architectures on Arduino 3rd part bords. They are important if one will use an other version or run on a other ESP8266 board.

### Step-by-step

Install the esp8266/Arduino environment by

	mkdir esp8266
	cd esp8266
    git clone https://github.com/esp8266/Arduino.git

or just follow the instruction given by the provider. Alternatively install it from the Arduino IDE and a json file. The later can be handy because it will provide you some parameters specific for your setup.

Download the binary tools needed as described by the provider or by:

	cd esp8266/tools
	python get.py

Create your Arduino project or just an ordinary C/C++/asm project that use the Arduino hooks – setup() and loop(); if you would like to add other psedo tasks that is possible.  

Download the makefile to your project:

	cd <your project>
    git clone https://github.com/ejanjoh/esp8266.git

Change the following variables in the script to your settings:

* __TOOLS_PATH__ point out the tools directory installed as a part of above.
* __ARDUINO_PATH__ point out the esp8266/Arduino environment installed above.
* __PROJ_PATH__ point out the directory contaning your sketch or other source files.
* __BUILD_PATH__ point out a directory containing all files that will be built.
* __SERIAL_PORT__ point out the port to be used

If you use other versions then described in this short guide some paths needs to be modified. The full paths in the makefile may vary depending on how you install the supported environent, and the makefile needs to be adjusted thereafter.

### Using the makefile

	// build it all 
	make all -f make_esp210.mk
	
	// clean the build
	make clean -f make_esp210.mk
	
	// get the size of the build
	make size -f make_esp210.mk
	
	// upload the code the target board
	make upload -f make_esp210.mk
	
	// create list files and files containing the section headers
	make extra -f make_esp210.mk

### Attached source files

__esp210_blink.ino__ is an Arduino file that will blink the internal led in the ESP210 board.

__esp210_blink.c__ is a C file that will blink the internal led on the ESP210 board.

Just attach one of the sorce files to your _PROJ_PATH_, build and flash your project.

