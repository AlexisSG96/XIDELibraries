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
<#list WWDTmacros as macroDef>
#define ${macroDef.name}  ${macroDef.value}
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

<#if isWWDTEnabled>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Initializes the WWDT to the default states configured in the
 *                  MCC GUI
 * @Example
    WWDT_Initialize();
 */
void WWDT_Initialize(void);


/**
 * @Param
    none
 * @Returns
    none
 * @Description
   Enable the WWDT by setting the SEN bit.
 * @Example
    WWDT_SoftEnable();
 */
void WWDT_SoftEnable(void);

/**
 * @Param
    none
 * @Returns
    none
 * @Description
   Disable the WWDT by clearing the SEN bit.
 * @Example
    WWDT_SoftDisable();
 */
void WWDT_SoftDisable(void);

/**
 * @Param
    none
 * @Returns
    none
 * @Description
   Disable the interrupt, arm the WWDT by reading back the WDTCON0 register
 * clear the WWDT and enable the interrupt.
 * @Example
    WWDT_TimerClear();
 */
void WWDT_TimerClear(void);

/**
 * @Param
    none
 * @Returns
   High --> WWDT reset has not occurred. 
 * Low  --> WWDT reset has  occurred.
 * @Description
    Returns the status of whether the WWDT reset has occurred or not.
 * @Example
    if(WWDT_TimeOutStatusGet())
 */
bool WWDT_TimeOutStatusGet(void);

/**
 * @Param
    none
 * @Returns
   High --> WWDT window violation reset has not occurred. 
 * Low  --> WWDT window violation reset has  occurred.
 * @Description
    Returns the status of, whether the WWDT window violation 
 *  reset has occurred or not.
 * @Example
    if(WWDT_WindowViolationStatusGet())
 */
bool WWDT_WindowViolationStatusGet(void);
      
</#if>
<#if DMAavailable>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Initializes the System Arbiter for DMA to the default priority.
 * @Example
    SystemArbiter_DMA_Initialize();
 */
void SystemArbiter_Initialize(void);
</#if>

#endif	/* MCC_H */
/**
 End of File
*/