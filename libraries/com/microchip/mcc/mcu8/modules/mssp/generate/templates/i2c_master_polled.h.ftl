/**
  ${moduleNameUpperCase} Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}_master.h

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

#ifndef ${moduleNameUpperCase}_MASTER_H
#define ${moduleNameUpperCase}_MASTER_H

/**
  Section: Included Files
*/

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

typedef enum {
    ${moduleNameUpperCase}_NOERR, // The message was sent.
    ${moduleNameUpperCase}_BUSY,  // Message was not sent, bus was busy.
    ${moduleNameUpperCase}_FAIL   // Message was not sent, bus failure
               // If you are interested in the failure reason,
               // Sit on the event call-backs.
} ${moduleNameLowerCase}_error_t;

typedef enum
{
    ${moduleNameUpperCase}_STOP=1,
    ${moduleNameUpperCase}_RESTART_READ,
    ${moduleNameUpperCase}_RESTART_WRITE,
    ${moduleNameUpperCase}_CONTINUE,
    ${moduleNameUpperCase}_RESET_LINK
} ${moduleNameLowerCase}_operations_t;

typedef uint8_t ${moduleNameLowerCase}_address_t;
typedef ${moduleNameLowerCase}_operations_t (*${moduleNameLowerCase}_callback_t)(void *funPtr);

// common callback responses
${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackReturnStop(void *funPtr);
${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackReturnReset(void *funPtr);
${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackRestartWrite(void *funPtr);
${moduleNameLowerCase}_operations_t ${moduleNameUpperCase}_CallbackRestartRead(void *funPtr);

/**
 * \brief Initialize ${moduleNameUpperCase} interface
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_Initialize(void);

/**
 * \brief Open the ${moduleNameUpperCase} for communication
 *
 * \param[in] address The slave address to use in the transfer
 *
 * \return Initialization status.
 * \retval ${moduleNameUpperCase}_NOERR The ${moduleNameUpperCase} open was successful
 * \retval ${moduleNameUpperCase}_BUSY  The ${moduleNameUpperCase} open failed because the interface is busy
 * \retval ${moduleNameUpperCase}_FAIL  The ${moduleNameUpperCase} open failed with an error
 */
${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_Open(${moduleNameLowerCase}_address_t address);

/**
 * \brief Close the ${moduleNameUpperCase} interface
 *
 * \return Status of close operation.
 * \retval ${moduleNameUpperCase}_NOERR The ${moduleNameUpperCase} open was successful
 * \retval ${moduleNameUpperCase}_BUSY  The ${moduleNameUpperCase} open failed because the interface is busy
 * \retval ${moduleNameUpperCase}_FAIL  The ${moduleNameUpperCase} open failed with an error
 */
${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_Close(void);

/**
 * \brief Start an operation on an opened ${moduleNameUpperCase} interface
 *
 * \param[in] read Set to true for read, false for write
 *
 * \return Status of operation
 * \retval ${moduleNameUpperCase}_NOERR The ${moduleNameUpperCase} open was successful
 * \retval ${moduleNameUpperCase}_BUSY  The ${moduleNameUpperCase} open failed because the interface is busy
 * \retval ${moduleNameUpperCase}_FAIL  The ${moduleNameUpperCase} open failed with an error
 */
${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_MasterOperation(bool read);

/**
 * \brief Identical to ${moduleNameUpperCase}_MasterOperation(false);
 */
${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_MasterWrite(void); // to be depreciated

/**
 * \brief Identical to ${moduleNameUpperCase}_MasterOperation(true);
 */
${moduleNameLowerCase}_error_t ${moduleNameUpperCase}_MasterRead(void); // to be depreciated

/**
 * \brief Set timeout to be used for ${moduleNameUpperCase} operations. Uses the Timeout driver.
 *
 * \param[in] to Timeout in ticks
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SetTimeout(uint8_t timeOut);

/**
 * \brief Sets up the data buffer to use, and number of bytes to transfer
 *
 * \param[in] buffer Pointer to data buffer to use for read or write data
 * \param[in] bufferSize Number of bytes to read or write from slave
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SetBuffer(void *buffer, size_t bufferSize);

// Event Callback functions.

/**
 * \brief Set callback to be called when all specifed data has been transferred.
 *
 * \param[in] cb Pointer to callback function
 * \param[in] ptr  Pointer to the callback function's parameters
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SetDataCompleteCallback(${moduleNameLowerCase}_callback_t cb, void *ptr);

/**
 * \brief Set callback to be called when there has been a bus collision and arbitration was lost.
 *
 * \param[in] cb Pointer to callback function
 * \param[in] ptr  Pointer to the callback function's parameters
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SetWriteCollisionCallback(${moduleNameLowerCase}_callback_t cb, void *ptr);

/**
 * \brief Set callback to be called when the transmitted address was Nack'ed.
 *
 * \param[in] cb Pointer to callback function
 * \param[in] ptr  Pointer to the callback function's parameters
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SetAddressNackCallback(${moduleNameLowerCase}_callback_t cb, void *ptr);

/**
 * \brief Set callback to be called when the transmitted data was Nack'ed.
 *
 * \param[in] cb Pointer to callback function
 * \param[in] ptr  Pointer to the callback function's parameters
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SetDataNackCallback(${moduleNameLowerCase}_callback_t cb, void *ptr);

/**
 * \brief Set callback to be called when there was a bus timeout.
 *
 * \param[in] cb Pointer to callback function
 * \param[in] ptr  Pointer to the callback function's parameters
 *
 * \return Nothing
 */
void ${moduleNameUpperCase}_SetTimeoutCallback(${moduleNameLowerCase}_callback_t cb, void *ptr);

#endif //${moduleNameUpperCase}_MASTER_H