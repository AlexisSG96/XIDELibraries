/*
    MICROCHIP SOFTWARE NOTICE AND DISCLAIMER:

    You may use this software, and any derivatives created by any person or
    entity by or on your behalf, exclusively with Microchip's products.
    Microchip and its subsidiaries ("Microchip"), and its licensors, retain all
    ownership and intellectual property rights in the accompanying software and
    in all derivatives hereto.

    This software and any accompanying information is for suggestion only. It
    does not modify Microchip's standard warranty for its products.  You agree
    that you are solely responsible for testing the software and determining
    its suitability.  Microchip has no obligation to modify, test, certify, or
    support the software.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".  NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE APPLY TO THIS SOFTWARE, ITS INTERACTION WITH MICROCHIP'S
    PRODUCTS, COMBINATION WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT, WILL MICROCHIP BE LIABLE, WHETHER IN CONTRACT, WARRANTY, TORT
    (INCLUDING NEGLIGENCE OR BREACH OF STATUTORY DUTY), STRICT LIABILITY,
    INDEMNITY, CONTRIBUTION, OR OTHERWISE, FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    EXEMPLARY, INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, FOR COST OR EXPENSE OF
    ANY KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWSOEVER CAUSED, EVEN IF
    MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE
    FORESEEABLE.  TO THE FULLEST EXTENT ALLOWABLE BY LAW, MICROCHIP'S TOTAL
    LIABILITY ON ALL CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED
    THE AMOUNT OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR
    THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF
    THESE TERMS.
 */

#include "mtouch_comm.h"

#if (MTOUCH_DEBUG_COMM_ENABLE == 1u)
/* 
 * =======================================================================
 * Local Functions
 * =======================================================================
 */
static void Comm_ProcessInfo_PCtoMCU(uint8_t len, uint8_t id, uint8_t addr);
static void Comm_ProcessData_PCtoMCU(uint8_t len, uint8_t id, uint8_t addr);
static void Comm_ProcessInfo_MCUtoPC(uint8_t len, uint8_t id, uint8_t addr);
static void Comm_ProcessData_MCUtoPC(uint8_t len, uint8_t id, uint8_t addr);
static void Comm_SendHeader(uint8_t len, uint8_t id, uint8_t addr);
static uint8_t Comm_receivedBtyesNumber_get(void);
static void Comm_SendBulkData(void);
typedef void(*commandFunction_t)(uint8_t len, uint8_t trans_id, uint8_t addr);

/* 
 * =======================================================================
 * Local Variables
 * =======================================================================
 */
typedef struct
{
    uint8_t command_id;
    commandFunction_t execute;
} uartCommand_t;

const uartCommand_t commands[] = {
    {COMMAND_INFO_PC_TO_MCU, Comm_ProcessInfo_PCtoMCU},
    {COMMAND_DATA_PC_TO_MCU, Comm_ProcessData_PCtoMCU},
    {COMMAND_INFO_MCU_TO_PC, Comm_ProcessInfo_MCUtoPC},
    {COMMAND_DATA_MCU_TO_PC, Comm_ProcessData_MCUtoPC}

};


void MTOUCH_Comm_Initialize(void)
{
}

void MTOUCH_Comm_Service(void)
{
    uint8_t command_id, trans_id, addr, len, i;

    MTOUCH_Memory_Update();

    if (Comm_receivedBtyesNumber_get() > MIN_COMMAND_BYTES)
    {
        if (${mtouch.surfaceUtility.EUSART_name}_Read() == UART_HEADER)
        {
            trans_id = ${mtouch.surfaceUtility.EUSART_name}_Read();
            command_id = ${mtouch.surfaceUtility.EUSART_name}_Read();
            addr = ${mtouch.surfaceUtility.EUSART_name}_Read();
            len = ${mtouch.surfaceUtility.EUSART_name}_Read();

            for (i = 0; i < 4; i++)
            {
                if (command_id == commands[i].command_id)
                {
                    commands[i].execute(len, trans_id, addr);
                    break;
                }
            }
        }
    }

    /* Transmit the touch info to the host */
    Comm_SendBulkData();

<#if mtouch.gesture.enabled??>
    MTOUCH_Gesture_clearGesture();
</#if>

}

static void Comm_ProcessInfo_PCtoMCU(uint8_t len, uint8_t id, uint8_t addr)
{

}

static void Comm_ProcessData_PCtoMCU(uint8_t len, uint8_t id, uint8_t addr)
{
    MTOUCH_Memory_Write(addr, len);
    Comm_SendHeader(1, id, addr);
    ${mtouch.surfaceUtility.EUSART_name}_Write(len);
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_FOOTER);
}

static void Comm_ProcessInfo_MCUtoPC(uint8_t len, uint8_t id, uint8_t addr)
{
    Comm_SendHeader(len, id, addr);
    for (uint8_t cnt = 0u; cnt < len; cnt++)
    {
        ${mtouch.surfaceUtility.EUSART_name}_Write(MTOUCH_Memory_Read((uint8_t)(addr + cnt)));
    }
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_FOOTER);
}

static void Comm_ProcessData_MCUtoPC(uint8_t len, uint8_t id, uint8_t addr)
{
    Comm_SendHeader(len, id, addr);
    if (addr != 0u)
    {
        for (uint8_t cnt = 0u; cnt < len; cnt++)
        {
            ${mtouch.surfaceUtility.EUSART_name}_Write(MTOUCH_Memory_Read((uint8_t)(addr + cnt)));
        }
    }
    else
    {
        ${mtouch.surfaceUtility.EUSART_name}_Write(0x00);
        ${mtouch.surfaceUtility.EUSART_name}_Write(0x00);
        ${mtouch.surfaceUtility.EUSART_name}_Write(0x00);
        ${mtouch.surfaceUtility.EUSART_name}_Write(0x50); // FIRMWARE INFORMATION
    }
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_FOOTER);
}

static void Comm_SendBulkData(void)
{
    uint8_t cnt;

    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_HEADER);
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_GES_LEN - 1u + UART_FIXED - 2u);
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_GES_ID);
    ${mtouch.surfaceUtility.EUSART_name}_Write(0x01);
    ${mtouch.surfaceUtility.EUSART_name}_Write(0x00);
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_GES_ADDR);
    for (cnt = 0u; cnt < UART_GES_LEN; cnt++)
    {
        ${mtouch.surfaceUtility.EUSART_name}_Write(MTOUCH_Memory_Read((uint8_t)(TOUCHRAM_ADDR + cnt)));
    }
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_FOOTER);


    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_HEADER);
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_DELTA_LEN - 1u + UART_FIXED - 2u);
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_DELTA_ID);
    ${mtouch.surfaceUtility.EUSART_name}_Write(0x01);
    ${mtouch.surfaceUtility.EUSART_name}_Write(0x00);
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_DELTA_ADDR);
    for (cnt = 0u; cnt < UART_DELTA_LEN; cnt++)
    {
        ${mtouch.surfaceUtility.EUSART_name}_Write(MTOUCH_Memory_Read((uint8_t)(SVRAM_ADDR + cnt)));
    }

    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_FOOTER);
}

static uint8_t Comm_receivedBtyesNumber_get(void)
{
    return ${mtouch.surfaceUtility.EUSART_name_lowerCase}RxCount;
}

static void Comm_SendHeader(uint8_t len, uint8_t id, uint8_t addr)
{
    ${mtouch.surfaceUtility.EUSART_name}_Write(UART_HEADER);
    ${mtouch.surfaceUtility.EUSART_name}_Write(len + 4u);
    ${mtouch.surfaceUtility.EUSART_name}_Write(id);
    ${mtouch.surfaceUtility.EUSART_name}_Write(0x01); // fixed
    ${mtouch.surfaceUtility.EUSART_name}_Write(0x00); // fixed
    ${mtouch.surfaceUtility.EUSART_name}_Write(addr);
}

#endif
