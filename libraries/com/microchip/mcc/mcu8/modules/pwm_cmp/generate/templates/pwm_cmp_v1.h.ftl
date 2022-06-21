/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.0
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_H
#define ${moduleNameUpperCase}_H

/**
  Section: Included Files
*/

#include <stdint.h>
#include <stdbool.h>

/**
 * @brief Initializes the ${moduleNameUpperCase} module
 *        This routine must be called before any other ${moduleNameUpperCase} routine
 * @return None.
 * @param None.
 */
void ${moduleNameUpperCase}_Initialize(void);

/**
 * @brief Enables the ${moduleNameUpperCase} module
 * @return None.
 * @param None.
 */
void ${moduleNameUpperCase}_Enable();

/**
 * @brief Disables the ${moduleNameUpperCase} module
 *        In case if one wants to re-initialize ${moduleNameUpperCase}, this function
 *        must be called before ${moduleNameUpperCase}_Initialize()
 * @return None.
 * @param None.
 */
void ${moduleNameUpperCase}_Disable();

/**
 * @brief This routine configures the total ${moduleNameUpperCase} period. 
 *        ${moduleNameUpperCase}_LoadBufferRegisters() must be called after this API
 * @return None.
 * @param [in] Desired 16-bit ${moduleNameUpperCase} period
 * @example void main(void)
 *          {
 *              SYSTEM_Initialize();
 *              
 *              // Change the PWM period
 *              ${moduleNameUpperCase}_WritePeriodRegister(0x00FF);
 *              ${moduleNameUpperCase}_LoadBufferRegisters();
 *
 *          }
 */
void ${moduleNameUpperCase}_WritePeriodRegister(uint16_t periodCount);

/**
 * @brief This routine configures the active period or duty cycle of
 *        slice-1, parameter 1 output. ${moduleNameUpperCase}_LoadBufferRegisters() must
 *        be called after this API
 * @return None.
 * @param [in] ${pwmUpperCase}S1P1 register value
 * @example void main(void)
 *          {
 *              SYSTEM_Initialize();
 *
 *              // Change the slice-1, parameter-1 output duty cycle
 *              ${moduleNameUpperCase}_SetSlice1Output1DutyCycleRegister(0x55);  //33% duty cycle
 *              ${moduleNameUpperCase}_LoadBufferRegisters();
 *
 *          }
 */
void ${moduleNameUpperCase}_SetSlice1Output1DutyCycleRegister(uint16_t value);

/**
 * @brief This routine configures the active period or duty cycle of
 *        slice-1, parameter 2 output. ${moduleNameUpperCase}_LoadBufferRegisters() must
 *        be called after this API
 * @param [in] ${pwmUpperCase}S1P2 register value
 * @example void main(void)
 *          {
 *              SYSTEM_Initialize();
 *
 *              // Change the slice-1, parameter-2 output duty cycle
 *              ${moduleNameUpperCase}_SetSlice1Output2DutyCycleRegister(0xAA);   //66% duty cycle
 *              ${moduleNameUpperCase}_LoadBufferRegisters();
 *
 *          }
 */
void ${moduleNameUpperCase}_SetSlice1Output2DutyCycleRegister(uint16_t value);

/**
 * @brief This routine is used to load period or duty cycle registers on the next period event
 *        This API must be called after changing PR/P1/P2 registers
 * @return None
 * @param None
 * @example void main(void)
 *          {
 *              SYSTEM_Initialize();
 *
 *              // Change the slice-1, parameter-2 output duty cycle
 *              ${moduleNameUpperCase}_SetSlice1Output2DutyCycleRegister(0xAA);   //66% duty cycle
 *              ${moduleNameUpperCase}_LoadBufferRegisters();
 *
 *          }
 */
void ${moduleNameUpperCase}_LoadBufferRegisters(void);

<#if !isVectoredInterrupt>
/**
 * @brief Interrupt handler for ${moduleNameUpperCase} outputs
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_PWMI_ISR(void);

/**
 * @brief Interrupt handler for ${moduleNameUpperCase} period
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_PWMPI_ISR(void);
</#if>

/**
 * @brief Setter for slice 1, parameter 1 out interrupt handler
 * @return None
 * @param None
 * @example 
 *          void Slice1Output1_CustomInterruptHandler(void)
 *          {
 *              //Custom interrupt handler code
 *          }
 *
 *          void main(void)
 *          {
 *              SYSTEM_Initialize();
 *              
 *              //Use custom handler for Slice1Output1 interrupt
 *              ${moduleNameUpperCase}_Slice1Output1_SetInterruptHandler(Slice1Output1_CustomInterruptHandler);
 *          }
 */
void ${moduleNameUpperCase}_Slice1Output1_SetInterruptHandler(void (* InterruptHandler)(void));

/**
 * @brief Setter for slice 1, parameter 2 out interrupt handler
 * @return None
 * @param None
 * @example 
 *          void Slice1Output2_CustomInterruptHandler(void)
 *          {
 *              //Custom interrupt handler code
 *          }
 *
 *          void main(void)
 *          {
 *              SYSTEM_Initialize();
 *              
 *              //Use custom handler for Slice1Output2 interrupt
 *              ${moduleNameUpperCase}_Slice1Output2_SetInterruptHandler(Slice1Output2_CustomInterruptHandler);
 *          }
 */
void ${moduleNameUpperCase}_Slice1Output2_SetInterruptHandler(void (* InterruptHandler)(void));

/**
 * @brief Setter for ${moduleNameUpperCase} period interrupt handler
 * @return None
 * @param None
 * @example 
 *          void Period_CustomInterruptHandler(void)
 *          {
 *              //Custom interrupt handler code
 *          }
 *
 *          void main(void)
 *          {
 *              SYSTEM_Initialize();
 *              
 *              //Use custom handler for period interrupt
 *              ${moduleNameUpperCase}_Period_SetInterruptHandler(Period_CustomInterruptHandler);
 *          }
 */
void ${moduleNameUpperCase}_Period_SetInterruptHandler(void (* InterruptHandler)(void));

#endif //${moduleNameUpperCase}_H
