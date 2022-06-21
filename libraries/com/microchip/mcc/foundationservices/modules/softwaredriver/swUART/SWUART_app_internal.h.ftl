/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef SWUART_INTERNAL_H
#define	SWUART_INTERNAL_H

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

// Enumeration of serial states
typedef enum{
    SERIAL_SEND_START_BIT,
    SERIAL_SEND_BYTE,
    SERIAL_SEND_STOP_BIT,
    SERIAL_SEND_BREAK,
    SERIAL_RCV_START_BIT,
    SERIAL_RCV_STOP_BIT,
    SERIAL_RCV_BYTE,
    SERIAL_RCV_BREAK,
<#if (enableAutobaud=="enabled")>
    SERIAL_RCV_SYNC_CHAR,
</#if>
    SERIAL_IDLE
}serial_state_t;

<#if (enableAutobaud=="enabled")>
// Enumeration of serial receive states
typedef enum{
    RCV_UART_DATA,
    RCV_SYNC_CHAR
}serial_rcv_state_t;
</#if>

// Declaration of serial flags
typedef union{
    struct{
        unsigned SW_TRMT    : 1;
        unsigned SW_OERR    : 1;
        unsigned SW_FERR    : 1;
        unsigned SW_SENDB   : 1;
        unsigned SW_ABDEN   : 1;
        unsigned rsvd       : 3;
    }; 
    uint8_t SERIAL_FLAGS;    
}serial_flag_t;

serial_flag_t serialFlag;

// Defines for serial engine
#define SW_TXIE                     ${TMRIE}
#define SW_RCIE                     ${enableInterruptOnChange}
#define SW_CREN                     ${RxPin_IOCN}
#define SW_TX_LAT                   ${TxPin_setOutputLevel}
#define SW_RX_PORT                  ${RxPin_getInputValue}
#define IOCN_ENABLE()               do{${RxPin_IOCN} = 1;}while(0)
#define IOCN_DISABLE()              do{${RxPin_IOCN} = 0;}while(0)
<#if (enableAutobaud=="enabled")>
#define IOCP_ENABLE()               do{${RxPin_IOCP} = 1;}while(0)
#define IOCP_DISABLE()              do{${RxPin_IOCP} = 0;}while(0)
</#if>
#define TIMER_INTERRUPT_FLAG        ${TMRIF}
#define TIMER_INTERRUPT_ENABLE()    do{${TMRIE} = 1;}while(0)
#define TIMER_INTERRUPT_DISABLE()   do{${TMRIE} = 0;}while(0)
#define SERIAL_RX_MASK              0x80
#define SERIAL_TX_MASK              0x01
#define MSB_MASK                    0x7F
#define PRESCALE_FACTOR             OPTION_REGbits.PS + 1
#define MAX_RELOAD                  0xFF
#define MIN_RELOAD                  0x00
#define ${moduleNameUpperCase}_${RxPin_IOCN}_SetInterruptHandler  ${RxPin_IOCF}_SetInterruptHandler
<#if (enableAutobaud=="enabled")>  
#define ${moduleNameUpperCase}_${RxPin_IOCP}_SetInterruptHandler  ${RxPin_IOCF}_SetInterruptHandler

// Timer0 Prescale Definitions
#define PRESCALE_EN                 1
#define PRESCALE_DIS                0
#define PRESCALE_2                  0b000
#define PRESCALE_4                  0b001
#define PRESCALE_8                  0b010
#define PRESCALE_16                 0b011
#define PRESCALE_32                 0b100
#define PRESCALE_64                 0b101
#define PRESCALE_128                0b110
#define PRESCALE_256                0b111
</#if>

// Receive Function Prototypes
void ${moduleNameUpperCase}_EnableRx (void);
void ${moduleNameUpperCase}_CheckRx (void);
void ${moduleNameUpperCase}_RxOverrunControl (void);

// Interrupt-on-Change Handling Function Prototypes
void ${moduleNameUpperCase}_IOCNHandler (void);
void ${moduleNameUpperCase}_SetIOCNHandler (void);
<#if (enableAutobaud=="enabled")>
void ${moduleNameUpperCase}_IOCPHandler (void);
void ${moduleNameUpperCase}_SetIOCPHandler (void);
</#if>

// Timing Function Prototypes
void ${moduleNameUpperCase}_SetTimerInterruptHandler (void);
void ${moduleNameUpperCase}_TimerInterruptHandler(void);
void ${moduleNameUpperCase}_SetTimerReload (uint8_t reload);
uint8_t ${moduleNameUpperCase}_CalcOneBitReload (void);
uint8_t ${moduleNameUpperCase}_CalcHalfBitReload (void);
<#if (enableAutobaud=="enabled")>
void ${moduleNameUpperCase}_SetTimerPrescaler (uint8_t prescaleEnable, uint8_t prescaleVal);
</#if>

<#if (enableAutobaud=="enabled")>
// Autobaud Function Prototypes
void ${moduleNameUpperCase}_SetAutoBaud (void);
void ${moduleNameUpperCase}_CalcBaudRate(uint8_t timerCapture);
</#if>

// Break Transmission Function Prototype
void ${moduleNameUpperCase}_SendBreak (void);

#endif	/* SWUART_INTERNAL_H */
