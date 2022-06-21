/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}_slave.h

  @Summary
    This is the generated header file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides APIs for driver for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.0.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#ifndef ${moduleNameUpperCase}_SLAVE_H
#define ${moduleNameUpperCase}_SLAVE_H

#include <stdbool.h>
#include <stdint.h>

typedef void (*${moduleNameLowerCase}InterruptHandler)(void);
/**
 * \brief Initialize ${moduleNameUpperCase} interface
 * If module is configured to disabled state, the clock to the ${moduleNameUpperCase} is disabled
 * if this is supported by the device's clock system.
 *
 * \return None
 */
void ${moduleNameUpperCase}_Initialize(void);

/**
 * \brief Open the ${moduleNameUpperCase} for communication. Enables the module if disabled.
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_Open(void);

/**
 * \brief Close the ${moduleNameUpperCase} for communication. Disables the module if enabled.
 * Disables address recognition.
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_Close(void);

/**
 * \brief Read data from ${moduleNameUpperCase} communication. 
 *
 * \return Read Data
 */
uint8_t ${moduleNameUpperCase}_Read(void);

/**
 * \brief Write data over the communication. 
 *
 * \return None
 */
void ${moduleNameUpperCase}_Write(uint8_t data);

/**
 * \brief Check for Master Read/Write Request
 *
 * \return bool
 * 1 - Master Read Request
 * 0 - Master Write Request
 */
bool ${moduleNameUpperCase}_IsRead(void);

/**
 * \brief Enable the communication by initialization of hardware 
 *
 * \return None
 */
void ${moduleNameUpperCase}_Enable(void);

/**
 * \brief Send the Ack Signal to Master 
 *
 * \return None
 */
void ${moduleNameUpperCase}_SendAck(void);

/**
 * \brief Send the Nack Signal to Master 
 *
 * \return None
 */
void ${moduleNameUpperCase}_SendNack(void);

/**
 * \brief The function called by the ${moduleNameUpperCase} Irq handler.
 * Can be called in a polling loop in a polled driver.
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SlaveSetIsrHandler(${moduleNameLowerCase}InterruptHandler handler);
void ${moduleNameUpperCase}_SlaveSetAddrIntHandler(${moduleNameLowerCase}InterruptHandler handler);
void ${moduleNameUpperCase}_SlaveSetReadIntHandler(${moduleNameLowerCase}InterruptHandler handler);
void ${moduleNameUpperCase}_SlaveSetWriteIntHandler(${moduleNameLowerCase}InterruptHandler handler);
void ${moduleNameUpperCase}_SlaveSetBusColIntHandler(${moduleNameLowerCase}InterruptHandler handler);
void ${moduleNameUpperCase}_SlaveSetWrColIntHandler(${moduleNameLowerCase}InterruptHandler handler);

void (*${moduleInstance}_InterruptHandler)(void);
void (*${moduleNameUpperCase}_SlaveRdInterruptHandler)(void);
void (*${moduleNameUpperCase}_SlaveWrInterruptHandler)(void);
void (*${moduleNameUpperCase}_SlaveAddrInterruptHandler)(void);
void (*${moduleNameUpperCase}_SlaveBusColInterruptHandler)(void);
void (*${moduleNameUpperCase}_SlaveWrColInterruptHandler)(void);


#endif /* ${moduleNameUpperCase}_SLAVE_H */