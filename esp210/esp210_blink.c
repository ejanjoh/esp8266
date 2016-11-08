/*******************************************************************************
 *
 *      Autor:      Jan Johansson
 *      Copyright:  Copyright (c) 2016 Jan Johansson (ejanjoh), All rights reserved.
 *      Created:    2016-09-29
 *      Updated:    2016-11-07
 *
 *      Project:    makefile esp210
 *      File name:  esp210_blink.c
 *
 *
 *      Version history mapped on changes in this file:
 *      -----------------------------------------------
 *      ver 1       Created
 *      ver 2       Updated for new project needs
 *
 *
 *      Reference:
 *      
 *      Note:       Set up the esp210 and do a first blink test...
 *
 *      License:    This program is free software; you can redistribute it and/or
 *                  modify it under the terms of the GNU General Public License as
 *                  published by the Free Software Foundation; either version 2 of the 
 *                  License, or (at your option) any later version.
 *
 *                  This program is distributed in the hope that it will be useful,
 *                  but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *                  MERCHANTABILITY or FITNESS FOR A PARTICULAR /PURPOSE.  See the 
 *                  GNU General Public License for more details.
 *
 ******************************************************************************/

#include "Arduino.h"

#define GPIO_LED 12

void setup() {
    pinMode(GPIO_LED, OUTPUT);

    return;
}

void loop() {

    while (1) {
        digitalWrite(GPIO_LED, HIGH);
        delay(100);
        digitalWrite(GPIO_LED, LOW);
        delay(100);
    }

  return;
}




