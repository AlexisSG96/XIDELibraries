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
#ifndef MTOUCH_COMM_H
#define MTOUCH_COMM_H

#include "mtouch_memory_2D.h"

/* 
 * =======================================================================
 * Constants
 * =======================================================================
 */

#define COMMAND_DATA_MCU_TO_PC      0x01
#define COMMAND_DATA_PC_TO_MCU      0x00
#define COMMAND_INFO_MCU_TO_PC      0x81
#define COMMAND_INFO_PC_TO_MCU      0x80

#define UART_FIXED          (5u + 2u)

#define UART_GES_POS        (0u)
#define UART_GES_DATA_POS   (UART_GES_POS + UART_FIXED - 1u)
#define UART_GES_LEN        (6u)
#define UART_GES_END        (UART_GES_POS + UART_GES_LEN + UART_FIXED - 1u)
#define UART_GES_ADDR       0x10
#define UART_GES_ID         0x00

#define UART_DELTA_POS      (UART_GES_END + 1u)
#define UART_DELTA_DATA_POS (UART_DELTA_POS + UART_FIXED - 1u)
#define UART_DELTA_LEN      ((SURFACE_CS_NUM_SEGMENTS_H + SURFACE_CS_NUM_SEGMENTS_V))
#define UART_DELTA_END      (UART_DELTA_POS + UART_DELTA_LEN + UART_FIXED - 1u)
#define UART_DELTA_ADDR     0x8c
#define UART_DELTA_ID       0x05

#define UART_HEADER         0xAD
#define UART_FOOTER         0xDA

#define MIN_COMMAND_BYTES   4u


/* 
 * =======================================================================
 * Communication Global Prototypes
 * =======================================================================
 */
void MTOUCH_Comm_Initialize(void);
void MTOUCH_Comm_Service(void);
void MTOUCH_Comm_buildStreamData(void);

#endif // MTOUCH_COMM_H
/**
 End of File
*/