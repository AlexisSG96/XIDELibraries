/**
  Generated Interrupt Manager Source File

  @Company:
    Microchip Technology Inc.

  @File Name:
    interrupt_manager.h

  @Summary:
    This is the Interrupt Manager file generated using ${productName}

  @Description:
    This header file provides implementations for global interrupt handling.
    For individual peripheral handlers please see the peripheral driver for
    all modules selected in the GUI.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  2.12
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB 	          :  ${tool}
*/

${disclaimer}

#ifndef INTERRUPT_MANAGER_H
#define INTERRUPT_MANAGER_H

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This macro will enable high priority global interrupts.
 * @Example
    INTERRUPT_GlobalInterruptHighEnable();
 */
#define INTERRUPT_GlobalInterruptHighEnable() (${INTCON}bits.GIEH = 1)

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This macro will disable high priority global interrupts.
 * @Example
    INTERRUPT_GlobalInterruptHighDisable();
 */
#define INTERRUPT_GlobalInterruptHighDisable() (${INTCON}bits.GIEH = 0)

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This macro will enable low priority global interrupts.
 * @Example
    INTERRUPT_GlobalInterruptLowEnable();
 */
#define INTERRUPT_GlobalInterruptLowEnable() (${INTCON}bits.GIEL = 1)

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This macro will disable low priority global interrupts.
 * @Example
    INTERRUPT_GlobalInterruptLowDisable();
 */
#define INTERRUPT_GlobalInterruptLowDisable() (${INTCON}bits.GIEL = 0)
<#if pieAvailable>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This macro will enable peripheral interrupts.
 * @Example
    INTERRUPT_PeripheralInterruptEnable();
 */
#define INTERRUPT_PeripheralInterruptEnable() (${INTCON}bits.PEIE = 1)

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    This macro will disable peripheral interrupts.
 * @Example
    INTERRUPT_PeripheralInterruptDisable();
 */
#define INTERRUPT_PeripheralInterruptDisable() (${INTCON}bits.PEIE = 0)
</#if>
/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Initializes PIC18 peripheral interrupt priorities; enables/disables priority vectors
 * @Example
    INTERRUPT_Initialize();
 */
void INTERRUPT_Initialize (void);

#endif  // INTERRUPT_MANAGER_H
/**
 End of File
*/
