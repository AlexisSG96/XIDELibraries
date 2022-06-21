/**
  @Generated ${productName} Header File

  @Company:
    Microchip Technology Inc.

  @File Name:
    mcc.h

  @Summary:
    This is the mcc.h file generated using ${productName}

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

#ifndef MCC_H
#define	MCC_H
#include <xc.h>
#include "device_config.h"
#include "pin_manager.h"
#include <stdint.h>
#include <stdbool.h>
#include <conio.h>
<#if useInterruptManager>
#include "interrupt_manager.h"
</#if>
<#list includeModules as moduleHeader>
#include "${moduleHeader}"
</#list>

<#if isWWDTEnabled>
<#list WWDTconfigurationRegisters as configBit>
#define ${configBit.name}      ${configBit.value}
</#list>
</#if>


/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Initializes the device to the default states configured in the
 *                  MCC GUI
 * @Example
    SYSTEM_Initialize(void);
 */
void SYSTEM_Initialize(void);

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Initializes the oscillator to the default states configured in the
 *                  MCC GUI
 * @Example
    OSCILLATOR_Initialize(void);
 */
void OSCILLATOR_Initialize(void);
<#if includeWDTInitialiser>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Initializes the WDT module to the default states configured in the
 *                  MCC GUI
 * @Example
    WDT_Initialize(void);
 */
void WDT_Initialize(void);
</#if>
<#if PMDavailable>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Initializes the PMD module to the default states configured in the
 *                  MCC GUI
 * @Example
    PMD_Initialize(void);
 */
void PMD_Initialize(void);
</#if>

#endif	/* MCC_H */
/**
 End of File
*/