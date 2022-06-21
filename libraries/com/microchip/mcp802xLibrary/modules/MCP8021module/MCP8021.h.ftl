<#if  deviceName?contains("dsPIC33C")>
    <#assign compiler = "XC16">
    <#assign uart_fractional_BRG = true>
</#if>
<#if  deviceName?contains("dsPIC33E")>
    <#assign compiler = "XC16">
    <#assign uart_fractional_BRG = false>
</#if>
<#if  deviceName?contains("PIC1")>
    <#assign compiler = "XC8">
    <#assign uart_fractional_BRG = false>
</#if>

/*******************************************************************************
(c) 2020 Microchip Technology Inc. and its subsidiaries

Subject to your compliance with these terms, you may use Microchip software and 
any derivatives exclusively with Microchip products. You're responsible for 
complying with 3rd party license terms applicable to your use of 3rd party 
software (including open source software) that may accompany Microchip software. 
SOFTWARE IS "AS IS." NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, 
APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED WARRANTIES OF NON-INFRINGEMENT, 
MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT WILL MICROCHIP 
BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, INCIDENTAL OR CONSEQUENTIAL LOSS, 
DAMAGE, COST OR EXPENSE OF ANY KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER 
CAUSED, EVEN IF MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE 
FORESEEABLE. TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY 
ON ALL CLAIMS RELATED TO THE SOFTWARE WILL NOT EXCEED AMOUNT OF FEES, IF ANY, 
YOU PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
 ******************************************************************************/

// This is a guard condition so that contents of this file are not included
// more than once.  
#ifndef ${mcpName}_H
#define	${mcpName}_H

#include <stdint.h> 

<#if  uart_fractional_BRG == true>
#define DE2BRG_TYP ((uint16_t)(CLOCK_PeripheralFrequencyGet()/9600UL))
<#else>
#define DE2BRG_TYP ((uint16_t)((CLOCK_PeripheralFrequencyGet()/(9600UL*4UL))))
</#if>
#define DE2BRG_MAX  ((uint16_t)((float)DE2BRG_TYP * 1.05))
#define DE2BRG_MIN  ((uint16_t)((float)DE2BRG_TYP * 0.95))
#define DE2BRG_BREAK (uint16_t)(((1.29 + 2)/2000) * (9600UL/9)*DE2BRG_TYP)

/* 
 * define commands for Host to ${mcpName} 
 */

typedef enum {
    SET_CFG_0 = 0x81,
    GET_CFG_0,
    SET_CFG_1,
    GET_CFG_1,
    GET_STATUS_0,
    GET_STATUS_1,
    SET_CFG_2,
    GET_CFG_2,
    RUN_AUTOBAUD = 0x3C,
    GET_REVID = 0x90

} _eDE2CMD;

/*
 * possible error codes responded back 
 */
typedef enum {
    DE2_OK = 0,
    DE2_TRMT_MISMATCH,
    DE2_GENERAL_RCV_NOK,
    DE2_RCV_FRAMESIZE_MISMATCH
} _eDE2Error;

/* ********************************************************************	*/
/* register bit definition of ${mcpName}																		*/
/* ********************************************************************	*/
<#if mcpName=="MCP8025" || mcpName=="MCP8026">
 typedef union {
    uint8_t b;

    struct {
        uint8_t TEMPWARN : 1;
        uint8_t OVERTEMP : 1;
        uint8_t INUV : 1;
uint8_t:
        1;
        uint8_t INOV : 1;
        uint8_t BUCKOC : 1;
        uint8_t BUCKUV : 1;
        uint8_t BOR : 1; /* bit7  */
    };
} _uSTATUS0;

typedef union {
    uint8_t b;

    struct {
        uint8_t LDO_5V : 1;
        uint8_t LDO_12V : 1;
        uint8_t FETUVLO : 1;
        uint8_t FETOC : 1;
        uint8_t BOR_RST : 1;
uint8_t:
        3; /* bit7 */
    };
} _uSTATUS1;

typedef union {
    uint8_t b;

    struct {
        uint8_t FETOCLIM : 2;
        uint8_t FETOCD_DIS : 1;
        uint8_t UVLO_DIS : 1;
        uint8_t STARSIM_EN : 1;
uint8_t:
        1;
        uint8_t DISPULLUP : 1;
uint8_t:
        1; /* bit7 */
    };
} _uCFG0;

typedef union {
    uint8_t b;

    struct {
        uint8_t CurLimDAC;
    };
} _uCFG1;

typedef union {
    uint8_t b;

    struct {
        uint8_t BlankTime : 2;
uint8_t:
        6;
    };
} _uCFG2;
<#elseif mcpName=="MCP8021" || mcpName=="MCP8022">
typedef union {
    uint8_t b;

    struct {
        uint8_t FAULT : 1; /*bit0 */
        uint8_t OTPW : 1;
        uint8_t OTPF : 1;
        uint8_t UVLOF : 1;
        uint8_t OVLOF : 1;
        uint8_t DHTDN : 3;
    };
} _uSTATUS0;

typedef union {
    uint8_t b;

    struct {
        uint8_t VREGUVF : 1; /*bit0 */
uint8_t:
        1;
        uint8_t XUVLOF : 1;
        uint8_t XOCPF : 1;
uint8_t:
        4; /* bit7 */
    };
} _uSTATUS1;

typedef union {
    uint8_t b;

    struct {
        uint8_t EXTO : 2; /*bit0*/
        uint8_t EXTSC : 1;
        uint8_t EXTUVLO : 1;
uint8_t:
        1;
        uint8_t SLEEP : 1;
        uint8_t OPAMP : 1;
uint8_t:
        1; /* bit7 */
    };
} _uCFG0;

typedef union {
    uint8_t b;

    struct {
uint8_t:
        8;
    };
} _uCFG1;

typedef union {
    uint8_t b;

    struct {
        uint8_t DRVBL : 2;
        uint8_t DRVDT : 3;
uint8_t:
        3;
    };
} _uCFG2;
</#if>
/* ********************************************************************	*/

void ${mcpName}_Initialize(void);
void ${mcpName}RxHandler(void);
uint8_t ${mcpName}SendCmd(uint8_t cmd);
inline uint8_t ${mcpName}CommunicationIdle(void);
inline void SetRegister${mcpName}(uint8_t reg, uint8_t value);
inline uint8_t GetRegister${mcpName}(uint8_t reg);

#endif