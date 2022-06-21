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

<#if SrcRegion == "GPR">
uint8_t ${SrcVarName}[${SrcVarSize}];
</#if>
<#if DstRegion == "GPR">
uint8_t ${DstVarName}[${DstVarSize}];
</#if>

/**
 * @brief Initializes the ${moduleNameUpperCase} module
 *        This routine must be called before any other ${moduleNameUpperCase} routine
 * @return None.
 * @param None.
 */
void ${moduleNameUpperCase}_Initialize(void);

/**
 * @brief Sets the source region as per user selection
 * @return None.
 * @param [in] Desired source region
 */
void ${moduleNameUpperCase}_SelectSourceRegion(uint8_t region);

/**
 * @brief Sets the Source Address for the DMA packet
 * @return None.
 * @param [in] Desired Source Address
 */
void ${moduleNameUpperCase}_SetSourceAddress(uint24_t address);

/**
 * @brief Sets the destination address for the DMA packet
 * @return None.
 * @param [in] Desired Destination Address
 */
void ${moduleNameUpperCase}_SetDestinationAddress(uint16_t address);

/**
 * @brief Sets the size of the Source array
 * @return None.
 * @param [in] Size of Source Array
 */
void ${moduleNameUpperCase}_SetSourceSize(uint16_t size);

/**
 * @brief Sets the size of the destination array
 * @return None.
 * @param [in] Size of Destination array
 */
void ${moduleNameUpperCase}_SetDestinationSize(uint16_t size);

/**
 * @brief Returns the current location from which the DMA has read
 * @return Current Source pointer
 * @param None
 */
uint24_t ${moduleNameUpperCase}_GetSourcePointer(void);

/**
 * @brief Returns the current location where the DMA last wrote
 * @return Current Destination pointer
 * @param None
 */
uint16_t ${moduleNameUpperCase}_GetDestinationPointer(void);

/**
 * @brief Sets the Start Trigger for DMA, doesn't start the transfer
 * @return None.
 * @param [in] Start Trigger Source
 */
void ${moduleNameUpperCase}_SetStartTrigger(uint8_t sirq);

/**
 * @brief Sets the Abort Trigger for DMA, doesn't abort the transfer
 * @return None.
 * @param [in] Abort Trigger Source
 */
void ${moduleNameUpperCase}_SetAbortTrigger(uint8_t airq);

/**
 * @brief Starts the DMA Transfer by setting GO bit
 * @return None.
 * @param None.
 */
void ${moduleNameUpperCase}_StartTransfer(void);

/**
 * @brief Starts the DMA transfer by enabling the trigger
 * @return None.
 * @param None.
 */
void ${moduleNameUpperCase}_StartTransferWithTrigger(void);	

/**
 * @brief Stops all the possible triggers and also clears the GO bit
 * @return None.
 * @param None.
 */
void ${moduleNameUpperCase}_StopTransfer(void);

/**
 * @brief Unlocks Arbiter - changes priority - locks Arbiter
 * @return None.
 * @param [in] Priority of DMA
 */
void ${moduleNameUpperCase}_SetDMAPriority(uint8_t priority);

<#if DMASCNTI_ENABLE.value == "enabled">
/**
 * @brief This routine is used to set the callback for the SCNTI Interrupt.
 * @return None
 * @param Callback Function to be called
 */
void ${moduleNameUpperCase}_SetSCNTIInterruptHandler(void (* InterruptHandler)(void));
<#if isVectoredInterruptEnabled>
<#else>
/**
 * @brief Interrupt handler for ${moduleNameUpperCase} Source Count interrupt
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_DMASCNTI_ISR(void);
</#if>
</#if>

<#if DMADCNTI_ENABLE.value == "enabled">
/**
 * @brief This routine is used to set the callback for the DCNTI Interrupt.
 * @return None
 * @param Callback Function to be called
 */
void ${moduleNameUpperCase}_SetDCNTIInterruptHandler(void (* InterruptHandler)(void));
<#if isVectoredInterruptEnabled>
<#else>
/**
 * @brief Interrupt handler for ${moduleNameUpperCase} Destination Count interrupt
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_DMADCNTI_ISR(void);
</#if>
</#if>

<#if DMAAI_ENABLE.value == "enabled">
/**
 * @brief This routine is used to set the callback for the AI Interrupt.
 * @return None
 * @param Callback Function to be called
 */
void ${moduleNameUpperCase}_SetAIInterruptHandler(void (* InterruptHandler)(void));
<#if isVectoredInterruptEnabled>
<#else>
/**
 * @brief Interrupt handler for ${moduleNameUpperCase} Abort Trigger interrupt 
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_DMAAI_ISR(void);
</#if>
</#if>

<#if DMAORI_ENABLE.value == "enabled">
/**
 * @brief This routine is used to set the callback for the ORI Interrupt.
 * @return None
 * @param Callback Function to be called
 */
void ${moduleNameUpperCase}_SetORIInterruptHandler(void (* InterruptHandler)(void));
<#if isVectoredInterruptEnabled>
<#else>
/**
 * @brief Interrupt handler for ${moduleNameUpperCase} Overrun interrupt 
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_DMAORI_ISR(void);
</#if>
</#if>
<#if DMASCNTI_ENABLE.value == "enabled" || DMADCNTI_ENABLE.value == "enabled" || DMAAI_ENABLE.value == "enabled" || DMAORI_ENABLE.value == "enabled">
/**
 * @brief This is the default Interrupt Handler function
 * @return None
 * @param None
 */
void ${moduleNameUpperCase}_DefaultInterruptHandler(void);
</#if>
#endif //${moduleNameUpperCase}_H
