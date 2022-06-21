/**
  @Generated ${productName} Source File

  @Company:
    Microchip Technology Inc.

  @File Name:
    mcc.c

  @Summary:
    This is the device_config.c file generated using ${productName}

  @Description:
    This header file provides implementations for driver APIs for all modules selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.00
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

// Configuration bits: selected in the GUI
<#list configurationRegisters as configBit>
<#-- MCCV3XX-2231: This special code supports the errors v1.35 compiler header files. -->
<#-- Specifically, the config bit "ZCD" is named "ZCDDIS" for 3 devices in the 16(L)F188xx family -->
<#if configBit.type == "configbit">
<#if configBit.name == "ZCD" && (selectedDevice == "PIC16F18875" || selectedDevice == "PIC16LF18875" || selectedDevice == "PIC16LF18855")>
#if (__XC8_VERSION < 1360)
#pragma config ZCDDIS = ${configBit.selectedOptionName}    // ${configBit.description}->${configBit.selectedOptionDescription}
#else // __XC8_VERSION
#pragma config ${configBit.name} = ${configBit.selectedOptionName}    // ${configBit.description}->${configBit.selectedOptionDescription}
#endif // __XC8_VERSION
<#else>
#pragma config ${configBit.name} = ${configBit.selectedOptionName}    // ${configBit.description}->${configBit.selectedOptionDescription}
</#if>    
<#else>

// ${configBit.name}
</#if>
</#list> 
