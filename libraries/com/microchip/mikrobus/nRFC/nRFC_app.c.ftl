/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "nRFC.h"
#include "../${SPIFunctions["spiHeader"]}"
#include "../${SPIFunctions["spiTypesHeader"]}"
#include "../${pinHeader}"
#ifdef __XC
#include <xc.h>
#endif

#define SPI_CONFIGURATION ${spi_configuration}

#define MAX_PAYLOAD_SIZE 32

<#if nRFC_ModeKey == "Receive">
uint8_t Rx_Buffer[MAX_PAYLOAD_SIZE];
uint8_t Rx_Buffer_Source;
uint8_t Rx_Buffer_Size;
</#if>

uint8_t ADDR_P0[5] = {0x${nRFC_addr_p0_1_key}, 0x${nRFC_addr_p0_2_key}, 0x${nRFC_addr_p0_3_key}, 0x${nRFC_addr_p0_4_key}, 0x${nRFC_addr_p0_5_key}};
<#if nRFC_ModeKey == "Receive">
uint8_t ADDR_P1[5] = {0x${nRFC_addr_p1_1_key}, 0x${nRFC_addr_p1_2_key}, 0x${nRFC_addr_p1_3_key}, 0x${nRFC_addr_p1_4_key}, 0x${nRFC_addr_p1_5_key}};
uint8_t ADDR_P2 = 0x${nRFC_addr_p2_key};
uint8_t ADDR_P3 = 0x${nRFC_addr_p3_key};
uint8_t ADDR_P4 = 0x${nRFC_addr_p4_key};
uint8_t ADDR_P5 = 0x${nRFC_addr_p5_key};
</#if>

// Commands
#define FLUSH_TX 0b11100001
#define FLUSH_RX 0b11100010
#define REUSE_TX_PL 0b11100111
#define W_ACK_PAYLOAD_MASK 0b10101000

// Registers
#define CONFIG 0x00
#define EN_AA 0x01
#define EN_RXADDR 0x02
#define SETUP_AW 0x03
#define SETUP_RETR 0x04
#define RF_CH 0x05
#define RF_SETUP 0x06
#define NRF_STATUS 0x07
#define OBSERVE_TX 0x08
#define RPD 0x09
#define RX_ADDR_P0 0x0A
#define RX_ADDR_P1 0x0B
#define RX_ADDR_P2 0x0C
#define RX_ADDR_P3 0x0D
#define RX_ADDR_P4 0x0E
#define RX_ADDR_P5 0x0F
#define TX_ADDR 0x10
#define RX_PW_P0 0x11
#define RX_PW_P1 0x12
#define RX_PW_P2 0x13
#define RX_PW_P3 0x14
#define RX_PW_P4 0x15
#define RX_PW_P5 0x16
#define FIFO_STATUS 0x17
#define DYNPD 0x1C
#define FEATURE 0x1D

// Status register masks
#define GEN_STAT_MASK 0b01111111
#define INTERRUPT_MASK 0b01110001

#define R_REGISTER_MASK 0b00000000
#define W_REGISTER_MASK 0b00100000
#define R_RX_PAYLOAD 0b01100001
#define W_TX_PAYLOAD 0b10100000
#define R_RX_PL_WID 0b01100000
#define NO_OPERATION 0b11111111


// SPI write handler

void Spi_Write_Wrapper(uint8_t *block, uint8_t size) {
    ${SPIFunctions["spiOpen"]}(SPI_CONFIGURATION);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    ${SPIFunctions["writeBlock"]}(block, size);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
}


// Send command 'cmd'

void Send_Command(uint8_t cmd) {
    ${SPIFunctions["spiOpen"]}(SPI_CONFIGURATION);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    uint8_t block[1];
    block[0] = cmd;
    ${SPIFunctions["writeBlock"]}(block, 1);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
}


// Read the contents of register 'reg'

uint8_t Byte_From_Register(uint8_t reg) {
    ${SPIFunctions["spiOpen"]}(SPI_CONFIGURATION);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;

    uint8_t block[1];
    block[0] = reg | R_REGISTER_MASK;
    ${SPIFunctions["writeBlock"]}(block, 1);

    uint8_t returnVal =  ${SPIFunctions["exchangeByte"]}(0);

    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
    return returnVal;
}


// Send byte 'payload' to register 'reg'

void Byte_To_Register(uint8_t reg, uint8_t payload) {
    uint8_t block[2];
    block[0] = reg | W_REGISTER_MASK;
    block[1] = payload;
    Spi_Write_Wrapper(block, 2);
}

<#if nRFC_ModeKey == "Receive">
// Read the payload length

uint8_t Get_Payload_Length() {
    ${SPIFunctions["spiOpen"]}(SPI_CONFIGURATION);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;

    uint8_t block[1];
    block[0] = R_RX_PL_WID;
    ${SPIFunctions["writeBlock"]}(block, 1);

    block[0] = ${SPIFunctions["exchangeByte"]}(0);

    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
    return block[0];
}
</#if>


// Read the status register

uint8_t Read_Status() {
    ${SPIFunctions["spiOpen"]}(SPI_CONFIGURATION);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    uint8_t stat = ${SPIFunctions["exchangeByte"]}(NO_OPERATION);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
    return stat;
}


// Clear interrupt with mask 'mask' in status register

void Clear_Interrupt(uint8_t mask) {
    Byte_To_Register(NRF_STATUS, mask);
}


<#if nRFC_ModeKey == "Transmit">
// Transmit payload 'payload' of size 'size'

void Upload_Tx_Payload(uint8_t *payload, uint8_t size) {
    uint8_t block[33];
    block[0] = W_TX_PAYLOAD;
    uint8_t i;
    for (i = 0; i < size; i++) {
        block[i + 1] = payload[i];
    }
    Spi_Write_Wrapper(block, size + 1);
}
</#if>

<#if nRFC_ModeKey == "Receive">
// Read the payload to Rx_Buffer, return size of payload

uint8_t Download_Rx_Payload() {
    uint8_t block[1];
    // Make sure there's actually a payload
    uint8_t stat = Read_Status();
    if (!(stat & RX_DR_MASK)) {
        return 0;
    }

    // What channel is the payload from
    Rx_Buffer_Source = (stat & RX_P_NO_MASK) >> 1;

    // Get the length of the payload in the channel
    Rx_Buffer_Size = Get_Payload_Length();

    // Flush corrupt payloads larger than max size of 32 bytes   
    if (Rx_Buffer_Size > MAX_PAYLOAD_SIZE) {
        Send_Command(FLUSH_RX);
        return 0;
    }

    // Read the payload
    block[0] = R_RX_PAYLOAD;
    ${SPIFunctions["spiOpen"]}(SPI_CONFIGURATION);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    ${SPIFunctions["writeBlock"]}(block, 1);
    ${SPIFunctions["readBlock"]}(Rx_Buffer, Rx_Buffer_Size);
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();

    // If the FIFO is empty, clear the RX flag
    stat = Read_Status();
    if ((stat & RX_P_NO_MASK) == RX_P_NO_MASK) {
        Byte_To_Register(NRF_STATUS, RX_DR_MASK);
    }

    return Rx_Buffer_Size;
}
</#if>
<#if nRFC_ModeKey == "Transmit">
// Clear the MAX_RT flag so it can retry transmission

void Retry_Transmit() {
    Clear_Interrupt(MAX_RT_MASK);

}
</#if>

// Set a five byte address

void Set_Five_Byte_Address(uint8_t reg, uint8_t *addr_header) {
    uint8_t block[6];
    block[0] = reg | W_REGISTER_MASK;
    block[1] = addr_header[0];
    block[2] = addr_header[1];
    block[3] = addr_header[2];
    block[4] = addr_header[3];
    block[5] = addr_header[4];
    Spi_Write_Wrapper(block, 6);
}

<#if nRFC_ModeKey == "Transmit">

void Setup_Transmitter() {
    // Power on, TX
    Byte_To_Register(CONFIG, 0b00001010);

    // Enable dynamic payload size on all channels
    Byte_To_Register(DYNPD, 0b00111111);
    Byte_To_Register(FEATURE, 0b00000100);

    // Set transmitter address
    Set_Five_Byte_Address(RX_ADDR_P0, ADDR_P0);
    Set_Five_Byte_Address(TX_ADDR, ADDR_P0);
}
</#if>


<#if nRFC_ModeKey == "Receive">
void Setup_Receiver() {
    // Power on, RX
    Byte_To_Register(CONFIG, 0b00001011);

    // Enable dynamic payload size on all channels
    Byte_To_Register(DYNPD, 0b00111111);
    Byte_To_Register(FEATURE, 0b00000100);

    // Set up addresses
    Set_Five_Byte_Address(RX_ADDR_P0, ADDR_P0);
    Set_Five_Byte_Address(RX_ADDR_P1, ADDR_P1);
    Byte_To_Register(RX_ADDR_P2, ADDR_P2);
    Byte_To_Register(RX_ADDR_P3, ADDR_P3);
    Byte_To_Register(RX_ADDR_P4, ADDR_P4);
    Byte_To_Register(RX_ADDR_P5, ADDR_P5);
    nRFC_PowerUp_LAT = 1;
}
</#if>

