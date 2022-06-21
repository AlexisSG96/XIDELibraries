/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "mcc.h"
#include "device_config.h"
#include "${pinHeader}"
#include "DRIVER_MRF24J40MA.h"
#include "DRIVER_BEEClick.h"
#include "${SPIFunctions["spiHeader"]}"

/**
 * @brief Initializes the BEE Click module and its interfaces to the host MCU
 * @return None.
 * @param None.
 */
void BEE_Init(void)
{
	MRF24J40MA_Init();
}

/**
 * @brief Writes data to be transmitted into the RF chip's TX FIFO
 * @return None
 * @param [in]Pointer to the buffer which contains data to be transmitted
 */
void BEE_Write(uint8_t *txPayload, uint8_t payloadLen)
{
	MRF24J40MA_WriteTxNormalFIFO(txPayload, payloadLen);
}

/**
 * @brief Reads data received in the RF chip's RX FIFO
 * @return Status of the receive operation.
 *        true: Expected length of data is received
 *        false: Expected length of data is not received
 * @param [out]Pointer to the buffer in which received payload contents will be copied
 */
bool BEE_Read(uint8_t *rxData, uint8_t payloadLen)
{
	//Clear the interrupt bit by reading INTSTAT reg
	MRF24J40MA_ReadShortRegister(INTSTAT);
	
	return (MRF24J40MA_ReadRxFIFO(rxData, payloadLen));
}