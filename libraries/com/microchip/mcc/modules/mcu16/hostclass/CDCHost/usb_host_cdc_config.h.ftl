/*******************************************************************************
Copyright 2016 Microchip Technology Inc. (www.microchip.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

To request to license the code under the MLA license (www.microchip.com/mla_license), 
please contact mla_licensing@microchip.com
*******************************************************************************/

// Created by the Microchip USBConfig Utility, Version 1.0.4.0, 4/25/2008, 17:05:22

#ifndef _usb_host_cdc_config_h_
#define _usb_host_cdc_config_h_

#if defined(__PIC24F__)
    #include <p24Fxxxx.h>
#elif defined(__18CXX)
    #include <p18cxxx.h>
#elif defined (__dsPIC33EP512MU810__)
    #include <p33Exxxx.h>
#elif defined (__dsPIC33EP256MU506__)
    #include <p33Exxxx.h>
#elif defined (__PIC24EP512GU810__)
    #include <p24Exxxx.h>
#elif defined(__PIC32MX__)
    #include <p32xxxx.h>
    #include "plib.h"
#elif defined(__PIC32MM__)
    #include <p32xxxx.h>
#else
    #error No processor header file.
#endif

#define _USB_CONFIG_VERSION_MAJOR 1
#define _USB_CONFIG_VERSION_MINOR 0
#define _USB_CONFIG_VERSION_DOT   4
#define _USB_CONFIG_VERSION_BUILD 0

// Host CDC Client Driver Configuration

#define USB_MAX_CDC_DEVICES  ${MaxNumCDC}
#define USB_CDC_BAUDRATE_SUPPORTED ${BaudRate}L
#define USB_CDC_PARITY_TYPE ${Parity}
#define USB_CDC_STOP_BITS ${StopBits}
#define USB_CDC_NO_OF_DATA_BITS ${DataBits}
#define USB_ENABLE_TRANSFER_EVENT

#endif

