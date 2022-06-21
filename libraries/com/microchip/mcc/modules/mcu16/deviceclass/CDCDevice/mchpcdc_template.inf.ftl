;---------------------------------------------------------------------------------
; Modified Windows USB CDC Abstract Control Model Serial Driver Setup File
; Copyright (C) 2012 Microchip Technology Inc.

[Version] 
Signature="$Windows NT$" 
Class=Ports
ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318} 
Provider=%MFGNAME% 
;CatalogFile=%MFGFILENAME%.cat
DriverVer=${.now?date?string["MM/dd/yyyy"]},1.0.0.0

[Manufacturer] 
%MFGNAME%=DeviceList,NTamd64


;------------------------------------------------------------------------------
;  Vendor and Product ID Definitions
;------------------------------------------------------------------------------
; When developing your USB device, the VID and PID used in the PC side
; application program and the firmware on the microcontroller must match.
; The VID and PID can be changed in the USB device descriptor and on the below 
; lines in this file.  If you modify this .inf file to customize it for your
; device, please remove all existing Microchip (VID 0x04D8) entries from
; the device lists.
;------------------------------------------------------------------------------
[DeviceList]
%DESCRIPTION%=DriverInstall,USB\VID_${VID_COPY?remove_beginning("0x")?left_pad(4, "0")?upper_case}&PID_${PID_COPY?remove_beginning("0x")?left_pad(4, "0")?upper_case}

[DeviceList.NTamd64] 
%DESCRIPTION%=DriverInstall,USB\VID_${VID_COPY?remove_beginning("0x")?left_pad(4, "0")?upper_case}&PID_${PID_COPY?remove_beginning("0x")?left_pad(4, "0")?upper_case}


;------------------------------------------------------------------------------
;  Windows 32bit OSes Section
;------------------------------------------------------------------------------
[DriverInstall.nt] 
include=mdmcpq.inf
CopyFiles=FakeModemCopyFileSection 
AddReg=DriverInstall.nt.AddReg 

[DriverInstall.nt.AddReg] 
HKR,,DevLoader,,*ntkern 
HKR,,NTMPDriver,,%DRIVERFILENAME%.sys 
HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider" 

[DriverInstall.NT.Services]
include=mdmcpq.inf 
AddService=usbser, 0x00000002, LowerFilter_Service_Inst 


;------------------------------------------------------------------------------
;  Windows 64bit OSes Section
;------------------------------------------------------------------------------
[DriverInstall.NTamd64]
include=mdmcpq.inf
CopyFiles=FakeModemCopyFileSection
AddReg=DriverInstall.NTamd64.AddReg 

[DriverInstall.NTamd64.AddReg] 
HKR,,DevLoader,,*ntkern 
HKR,,NTMPDriver,,%DRIVERFILENAME%.sys 
HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider" 

[DriverInstall.NTamd64.Services] 
include=mdmcpq.inf 
AddService=usbser, 0x00000002, LowerFilter_Service_Inst 


;------------------------------------------------------------------------------
;  Common Sections
;------------------------------------------------------------------------------
[DestinationDirs] 
DefaultDestDir=12 

[SourceDisksNames]

[SourceDisksFiles]

[FakeModemCopyFileSection]

[LowerFilter_Service_Inst]
DisplayName= %SERVICE%
ServiceType= 1
StartType  = 3
ErrorControl = 0
ServiceBinary = %12%\usbser.sys


;------------------------------------------------------------------------------
;  String Definitions
;------------------------------------------------------------------------------
; These strings can be modified to customize your device
;------------------------------------------------------------------------------
[Strings]
MFGFILENAME="${MANSTR_COPY}"
DRIVERFILENAME ="usbser"
MFGNAME="${MANSTR_COPY}"   ;This name shows up in the device manager properties for the device
DESCRIPTION="${PRODSTR_COPY}"          ;This is the "friendly name" that shows up in the device manager
SERVICE="USB to Serial Driver"

