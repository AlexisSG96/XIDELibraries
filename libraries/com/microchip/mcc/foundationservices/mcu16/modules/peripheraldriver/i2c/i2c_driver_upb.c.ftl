/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "mcc.h"
#include "${i2cHeader}"

#ifndef FCY
#define FCY _XTAL_FREQ/2
#endif

//#include <libpic30.h>

void (*${busCollisionISR})(void);
void (*${Masteri2cISR})(void);
void (*${Slavei2cISR})(void);

void ${i2cClose}(void)
{
    ${ENABLEREGISTER}bits.${ENENABLESETTING} = 0;
}

/* Interrupt Control */
void ${enableIRQ}(void)
{
    <#if MASTERINTERRUPT??>
    ${MASTERINTERRUPT.enable} = <#if MASTERINTERRUPTENABLE == "enabled">1<#else>0</#if>;
    </#if>
    <#if SLAVEINTERRUPT??>
    ${SLAVEINTERRUPT.enable} = <#if SLAVEINTERRUPTENABLE == "enabled">1<#else>0</#if>;
    </#if>
    <#if BUSCOLLISIONINTERRUPT??>
    ${BUSCOLLISIONINTERRUPT.enable} = <#if BUSCOLLISIONINTERRUPTENABLE == "enabled">1<#else>0</#if>;
    </#if>
}

bool ${IRQisEnabled}(void)
{
    return <#if (MASTERINTERRUPT??)>${MASTERINTERRUPT.enable}</#if><#if (MASTERINTERRUPT??) && ((SLAVEINTERRUPT??) || (BUSCOLLISIONINTERRUPT??))> || </#if><#if (SLAVEINTERRUPT??)>${SLAVEINTERRUPT.enable}</#if><#if (BUSCOLLISIONINTERRUPT??) && ((SLAVEINTERRUPT??) || (MASTERINTERRUPT??))> || </#if><#if (BUSCOLLISIONINTERRUPT??)>${BUSCOLLISIONINTERRUPT.enable}</#if>;
}

void ${disableIRQ}(void)
{
    <#if MASTERINTERRUPT??>
    ${MASTERINTERRUPT.enable} = 0;
    </#if>
    <#if SLAVEINTERRUPT??>
    ${SLAVEINTERRUPT.enable} = 0;
    </#if>
    <#if BUSCOLLISIONINTERRUPT??>
    ${BUSCOLLISIONINTERRUPT.enable} = 0;
    </#if>
}

void ${clearIRQ}(void)
{
    <#if MASTERINTERRUPT??>
    ${MASTERINTERRUPT.flag} = 0;
    </#if>
    <#if SLAVEINTERRUPT??>
    ${SLAVEINTERRUPT.flag} = 0;
    </#if>
    <#if BUSCOLLISIONINTERRUPT??>
    ${BUSCOLLISIONINTERRUPT.flag} = 0;
    </#if>
}

void ${setIRQ}(void)
{
    <#if MASTERINTERRUPT??>
    ${MASTERINTERRUPT.flag} = 1;
    </#if>
    <#if SLAVEINTERRUPT??>
    ${SLAVEINTERRUPT.flag} = 1;
    </#if>
    <#if BUSCOLLISIONINTERRUPT??>
    ${BUSCOLLISIONINTERRUPT.flag} = 1;
    </#if>
}

void ${waitForEvent}(uint16_t *timeout)
{
    //uint16_t to = (timeout!=NULL)?*timeout:100;
    //to <<= 8;
    if(<#if (MASTERINTERRUPT??)>(${MASTERINTERRUPT.flag} == 0)</#if><#if (MASTERINTERRUPT??) && ((SLAVEINTERRUPT??) || (BUSCOLLISIONINTERRUPT??))> && </#if><#if (SLAVEINTERRUPT??)>(${SLAVEINTERRUPT.flag} == 0)</#if><#if (BUSCOLLISIONINTERRUPT??) && ((SLAVEINTERRUPT??) || (MASTERINTERRUPT??))> && </#if><#if (BUSCOLLISIONINTERRUPT??)>(${BUSCOLLISIONINTERRUPT.flag} == 0)</#if>)
    {
        while(1)// to--)
        {
            if(<#if (MASTERINTERRUPT??)>${MASTERINTERRUPT.flag}</#if><#if (MASTERINTERRUPT??) && ((SLAVEINTERRUPT??) || (BUSCOLLISIONINTERRUPT??))> || </#if><#if (SLAVEINTERRUPT??)>${SLAVEINTERRUPT.flag}</#if><#if (BUSCOLLISIONINTERRUPT??) && ((SLAVEINTERRUPT??) || (MASTERINTERRUPT??))> || </#if><#if (BUSCOLLISIONINTERRUPT??)>${BUSCOLLISIONINTERRUPT.flag}</#if>) break;
            //__delay_us(100);
        }
    }
}

bool ${initMasterHardware}(void)
{
    if(!${ENABLEREGISTER}bits.${ENENABLESETTING})
    {
        // initialize the hardware
        // STAT Setting 
        ${I2CSTAT} = ${I2CSTATSETTING};
        
        // CON Setting
        ${I2CCON} = ${I2CCONSETTING};
        
        // Baud Rate Generator Value: I2CBRG ${BAUDRATE};   
        ${BAUDREGISTER} = ${BAUDSETTING};
        
        return true;
    }
    else
        return false;
}
bool ${initSlaveHardware}(void)
{
    if(!${ENABLEREGISTER}bits.${ENENABLESETTING})
    {
<#if (AHENREGISTER??)>
/* NOTE on AHEN:
 * If multiple slaves are to be emulated, then AHEN must be set.  It must be set
 * because the driver needs to selectively ACK/NACK the address depending on its
 * ability to handle the address.
*/
</#if>

<#if (DHENREGISTER??)>
/* NOTE on DHEN:
 * DHEN must be set so that the data is not automatically NACK'ed if it is not read
 * from the SSPBUF.  This driver will ALWAYS read the SSPBUF so that it can pass
 * the value to the appropriate slave handler.  Because the data is ALWAYS read
 * the data will always be ACK'd if DHEN is cleared.  If the slave does not want
 * the data byte from the master then it will return false and a NACK will be returned.
 */
</#if>

/* NOTE on SEN:
 * SEN will be set enabling clock stretching.  This is because we don't know how
 * long the user will take to process data bytes in their callbacks.  If they are fast,
 * we may not need to stretch the clock.  If they are slow, we need to stretch the clock.
 * If we ALWAYS stretch the clock, we will release the clock when the ISR is complete.
 */

/* NOTE on PCIE:
 * PCIE will be set to enable interrupts on STOP.  This will allow us know when
 * the master is finished
 */
        
/* NOTE on SCIE:
 * SCIE will be set to enable interrupts on START.  This will allow us to detect
 * both a START and a RESTART event and prepare to restart communications.
 */
        <#if (AHENREGISTER??)>
        ${AHENREGISTER}bits.AHEN = 1;
        </#if>
        <#if (DHENREGISTER??)>
        ${DHENREGISTER}bits.DHEN = 1;
        </#if>
        ${STRENREGISTER}bits.STREN = 1;
        
        ${ENABLEREGISTER}bits.${ENENABLESETTING} = 1;
        return true;
    }
    return false;
}

void ${resetBus}(void)
{
    
}

void ${start}(void)
{
    ${SENREGISTER}bits.SEN = 1;
}

void ${restart}(void)
{
    ${RSENREGISTER}bits.RSEN = 1;
}

void ${stop}(void)
{
    ${PENREGISTER}bits.PEN = 1;
}

bool ${isNACK}(void)
{
    return ${ACKSTATREGISTER}bits.ACKSTAT;
}

void ${startRX}(void)
{
    ${RCENREGISTER}bits.RCEN = 1;
}

char ${getRXData}(void)
{
    return ${i2cInstanceName?upper_case}RCV;
}

void ${TXData}(uint8_t d)
{
    ${I2CTRNREGISTER} = d;
}

void ${sendACK}(void)
{
    ${ACKDTREGISTER}bits.ACKDT = 0;
    ${ACKENREGISTER}bits.ACKEN = 1; // start the ACK/NACK
}

void ${sendNACK}(void)
{
    ${ACKDTREGISTER}bits.ACKDT = 1;
    ${ACKENREGISTER}bits.ACKEN = 1; // start the ACK/NACK
}

void ${releaseClock}(void)
{
    ${SCLRELREGISTER}bits.SCLREL = 1;
}

bool ${isBuferFull}(void)
{
    return ${RBFREGISTER}bits.RBF || ${TBFREGISTER}bits.TBF;
}

bool ${isStart}(void)
{
    return ${SREGISTER}bits.S;
}

bool ${isAddress}(void)
{
    return !${D_AREGISTER}bits.D_A;
}

bool ${isStop}(void)
{
    return ${PREGISTER}bits.P;
}

bool ${isData}(void)
{
    return ${D_AREGISTER}bits.D_A;
}

bool ${isRead}(void)
{
    return ${R_WREGISTER}bits.R_W;
}

void ${clearBusCollision}(void)
{
    ${BCLREGISTER}bits.BCL = 0; // clear the bus collision.
}

void ${enableStartIRQ}(void)
{
    ${SCIEREGISTER}bits.SCIE = 1;
}

void ${disableStartIRQ}(void)
{
    ${SCIEREGISTER}bits.SCIE = 0;
}

void ${enableStopIRQ}(void)
{
    ${PCIEREGISTER}bits.PCIE = 1;
}

void ${disableStopIRQ}(void)
{
    ${PCIEREGISTER}bits.PCIE = 0;
}

void ${setBusCollisionISR}(interruptHandler handler){
    ${busCollisionISR} = handler;
}

void ${setMasterI2cISR}(interruptHandler handler){
    ${Masteri2cISR} = handler;
}

void ${setSlaveI2cISR}(interruptHandler handler){
    ${Slavei2cISR} = handler;
}

<#if MASTERINTERRUPT??>
void __attribute__ ((vector(_${i2cInstanceName?upper_case}_MASTER_VECTOR), interrupt(IPL${MASTERINTERRUPTPRIORITY}SOFT))) ${MASTERINTERRUPT.handler_name} ( void )
{
    (*${Masteri2cISR})();
}
</#if>
<#if SLAVEINTERRUPT??>
void __attribute__ ((vector(_${i2cInstanceName?upper_case}_SLAVE_VECTOR), interrupt(IPL${SLAVEINTERRUPTPRIORITY}SOFT))) ${SLAVEINTERRUPT.handler_name} ( void )
{
    (*${Slavei2cISR})();
}
</#if>
<#if BUSCOLLISIONINTERRUPT??>
void __attribute__ ((vector(_${i2cInstanceName?upper_case}_BUS_VECTOR), interrupt(IPL${BUSCOLLISIONINTERRUPTPRIORITY}SOFT))) ${BUSCOLLISIONINTERRUPT.handler_name} ( void )
{
    (*${busCollisionISR})();
}
</#if>