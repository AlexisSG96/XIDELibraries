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

#include "usb.h"
#include "usb_host_config.h"
<#if (EnableHIDKeyboard == "enabled") | (EnableHIDMouse == "enabled") | (EnableHIDVendor == "enabled") >
#include "usb_host_hid.h"
#include "usb_host_hid_config.h"
</#if>
<#if EnableCDC == "enabled">
#include "usb_host_cdc.h"
#include "usb_host_cdc_config.h"
</#if>

// *****************************************************************************
// Client Driver Function Pointer Table for the USB Embedded Host foundation
// *****************************************************************************

CLIENT_DRIVER_TABLE usbClientDrvTable[] =
{
    <#if EnableCDC == "enabled">
    {
        USBHostCDCInitialize,
        USBHostCDCEventHandler,
        0
    },
    </#if>
    <#if (EnableHIDKeyboard == "enabled") | (EnableHIDMouse == "enabled") | (EnableHIDVendor == "enabled") >
    {
        USBHostHIDInitialize,
        USBHostHIDEventHandler,
        0
    }
    </#if>
};

// *****************************************************************************
// USB Embedded Host Targeted Peripheral List (TPL)
// *****************************************************************************

USB_TPL usbTPL[] =
{
<#if EnableCDC == "enabled">
    { INIT_CL_SC_P( 2ul, 2ul, 2ul ), 0, 0, {TPL_CLASS_DRV} }, 
    { INIT_CL_SC_P( 0x0Aul, 0ul, 0ul ), 0, 0, {TPL_CLASS_DRV} }, 
</#if>
<#if EnableHIDKeyboard == "enabled">
    { INIT_CL_SC_P( 3ul, 1ul, 1ul ), 0, ${HIDDrvTablePosition}, {TPL_CLASS_DRV} }, 
    { INIT_CL_SC_P( 3ul, 0ul, 1ul ), 0, ${HIDDrvTablePosition}, {TPL_CLASS_DRV} }, 
</#if>
<#if EnableHIDMouse == "enabled">
    { INIT_CL_SC_P( 3ul, 1ul, 2ul ), 0, ${HIDDrvTablePosition}, {TPL_CLASS_DRV} }, 
    { INIT_CL_SC_P( 3ul, 0ul, 2ul ), 0, ${HIDDrvTablePosition}, {TPL_CLASS_DRV} }, 
</#if>
<#if EnableHIDVendor == "enabled">
    { INIT_CL_SC_P( 3ul, 0ul, 0ul ), 0, ${HIDDrvTablePosition}, {TPL_CLASS_DRV} }
</#if>
};

