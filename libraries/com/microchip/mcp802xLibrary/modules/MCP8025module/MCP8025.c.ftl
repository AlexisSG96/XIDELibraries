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
<#assign uartNumber = selUart?replace("UART", "")>
<#if compiler == "XC8">
            <#assign UARTTXEN = "TXSTAbits.TXEN = 1">
            <#assign UARTTXDIS = "TXSTAbits.TXEN = 0">
            <#assign UARTTXREG = "TXREG">
            <#assign UARTRXREG = "RCREG">
            <#assign UARTSTAT = "RCSTA">
            <#assign UARTRXIDL = "BAUDCONbits.RCIDL">
            <#assign UARTMODE = "TXSTA">
            <#assign EnableDE2Int = "RCIE = 1">
            <#assign DisableDE2Int = "RCIE = 0">
<#elseif compiler == "XC16">
    <#if deviceName?contains("dsPIC33E")>
            <#assign UARTTXEN = "U"+uartNumber+"STAbits.UTXEN = 1">
            <#assign UARTTXDIS = "U"+uartNumber+"STAbits.UTXEN = 0">
            <#assign UARTTXREG = "U"+uartNumber+"TXREG">
            <#assign UARTRXREG = "U"+uartNumber+"RXREG">
            <#assign UARTSTAT = "U"+uartNumber+"STA">
            <#assign UARTBRG = "U"+uartNumber+"BRG">
            <#assign UARTRXIDL = "U"+uartNumber+"STAbits.RIDLE">
            <#assign UARTMODE = "U"+uartNumber+"MODE">
            <#assign BRGH = "U"+uartNumber+"MODEbits.BRGH">
            <#assign SENDBREAK = "U"+uartNumber+"STAbits.UTXBRK">
	<#elseif deviceName?contains("dsPIC33C")>
            <#assign UARTTXEN = "U"+uartNumber+"MODEbits.UTXEN = 1">
            <#assign UARTTXDIS = "U"+uartNumber+"MODEbits.UTXEN = 0">
            <#assign UARTTXREG = "U"+uartNumber+"TXREG">
            <#assign UARTRXREG = "U"+uartNumber+"RXREG">
            <#assign UARTSTAT = "U"+uartNumber+"STA">
            <#assign UARTBRG = "U"+uartNumber+"BRG">
            <#assign UARTMODE = "U"+uartNumber+"MODE">
            <#assign UARTMODEH = "U"+uartNumber+"MODEH">
            <#assign BRGH = "U"+uartNumber+"MODEbits.BRGH">
            <#assign SENDBREAK = "U"+uartNumber+"MODEbits.UTXBRK">
	</#if>
	<#assign EnableDE2Int = "_U"+uartNumber+"RXIE = 1">
	<#assign DisableDE2Int = "_U"+uartNumber+"RXIE = 0">	
</#if>
<#if mcpName=="MCP8021" || mcpName=="MCP8022">
    <#assign MCP_AUTOBAUD_AVAILABLE = "true">
    <#assign CFG_1_UNUSED = "true">
<#elseif mcpName=="MCP8025" || mcpName=="MCP8026">
    <#assign MCP_AUTOBAUD_AVAILABLE = "false">
    <#assign CFG_1_UNUSED = "false">
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

#include "system.h"
<#assign mcpNameLowerCase = mcpName?replace("MCP", "mcp")>
#include "${mcpNameLowerCase}.h"
#include "clock.h"
#include "pin_manager.h"

/* ********************************************************************	*/
/* ********************************************************************	*/


/* communication buffer for receive and transmission */
static uint8_t DE2RxBuf[4];
static uint8_t DE2TxBuf[2];
<#if MCP_AUTOBAUD_AVAILABLE == "true">
static uint16_t LastKnownBrg;
</#if>
static union
{
    uint8_t b;

    struct
    {
        uint8_t Request : 1;
        uint8_t Response : 1;
        uint8_t TxPending : 1;
        uint8_t GotAck : 1;
        uint8_t SendCmd : 1;
        uint8_t Error : 2;
        uint8_t AutoBaud : 1;
    };
} DE2flags; /* DE2 communication flags */

uint8_t TxReqCnt;
uint8_t TxCnt;
uint8_t RxCnt;
<#if MCP_AUTOBAUD_AVAILABLE == "true">
volatile uint16_t AutoBaudActive;
</#if>

/*
 * this is the footprint of ${mcpName} register set
 * to make comparison about expected and received value
 * there are two sets of registers. One for Set and one for Get
 * This prevents from overwriting when updating the register on device
 * or reading values from device.
 * Only STATUS and RevID ( if available ) are read only
 */

volatile union
{
    uint8_t b[9];

    struct
    {
        uint8_t RevId;
        _uCFG0 SetCFG0;
        _uCFG0 GetCFG0;
        _uCFG1 SetCFG1;
        _uCFG1 GetCFG1;
        _uSTATUS0 STATUS0;
        _uSTATUS1 STATUS1;
        _uCFG2 SetCFG2;
        _uCFG2 GetCFG2;
    };
} ${mcpName};

/* ********************************************************************	*/

/* ********************************************************************	*/

void ${mcpName}_Initialize(void)
{
    /* setup the buffers according the ${mcpName} register expectation */
    <#if enableMosfetShortDetect == "enabled">
    /* external MOSFET overcurrent = ${overCurrentLimit}
    <#else>
    /* external MOSFET Short Circuit Detection is disabled
    </#if>
     * Undervoltage Lockout is ${enableMosfetUvlo} 
     * ${enableNeutral} internal neutral simulator
     * System enters ${ceZeroMode} when CE = 0
     * ${enablePU30k} disconnect of 30k Pull Up when CE = 0
     */
    SetRegister${mcpName}(SET_CFG_0, 0x${regCFG0});
    <#if mcpName=="MCP8025" || mcpName=="MCP8026">
    /* DAC Current Reference Value = ${dacRef} V */
    SetRegister${mcpName}(SET_CFG_1, 0x${regCFG1});
    </#if>
    /* blanking time = ${driverBlankingTime}
     * dead-time = ${driverDeadTime}
     */
    SetRegister${mcpName}(SET_CFG_2, 0x${regCFG2});
     
    ${mcpName}_CE_SetLow(); /* disable MCP prior init is done */

    RxCnt = 0;
    DE2flags.b = 0;

    TxCnt = 0;
    TxReqCnt = 0;
}

/* ********************************************************************	*/

/* ********************************************************************	*/

void ${mcpName}TxHandler(void)
{
    if (0 == DE2flags.TxPending)
    {
        /*
         * all expected bytes sent ? 
         * If so then we need to wait for the response
         */
        if (TxCnt >= TxReqCnt)
        {
            DE2flags.Request = 1;
            DE2flags.SendCmd = 0;
            TxReqCnt = 0;
            ${UARTTXDIS};
        }
        else
        {
            /* flag the actual transmission as CMD frame */
            DE2flags.SendCmd = 1;
            ${UARTTXEN}; /* make sure XMT channel is active */
            ${UARTTXREG} = DE2TxBuf[TxCnt]; /* send data */
        }
    }
}

/* ********************************************************************	*/
/* 
 * Callback function to notify upper layer in case of unsolicited message
 * parameter : 
 *          1 status_0 came through
 *          2 status_1 came through
 */

/* ********************************************************************	*/

uint8_t __attribute__((weak)) Status_Notification(_eDE2CMD  idx)
{

}

/* ********************************************************************	*/

/* ********************************************************************	*/
void ${mcpName}RxHandler(void)
{
    uint16_t tmpSTA;
    uint8_t tmpRXREG;
    <#if MCP_AUTOBAUD_AVAILABLE == "true">
    uint16_t tmpBRG;
    </#if>
    uint8_t cmd;

    /* 
     * get data and reset potential failure 
     * status during reception  
     */

    tmpSTA = ${UARTSTAT} & 0x000E;
    tmpRXREG = ${UARTRXREG};
    /* check if errors occurred during receipt */

    if (0 != tmpSTA)
    {
        {
            DE2flags.b &= 0x80;
            DE2flags.Error = (_eDE2Error) DE2_GENERAL_RCV_NOK;
        }
    }
    else
    {   <#if MCP_AUTOBAUD_AVAILABLE == "true">
        if ((0 == ${UARTRXREG}) && /* received a zero frame */
                (0 == AutoBaudActive) &&
                (1 == DE2flags.AutoBaud)) /* autobaud had been requested */
        {
            ${UARTTXDIS};
            AutoBaudActive = 1;
            ${UARTMODE} |= 0x0020; /* enable Autobaud */
        }
        else
            if ((1 == DE2flags.AutoBaud) && (0 != AutoBaudActive)) /* autobaud had been requested */
        {
            DE2flags.AutoBaud = 0; /* reset the marker */
            tmpBRG = ${UARTBRG};

            ${UARTMODE} &= 0x7FFF; /* reset UART - Required to abort sync */
            if ((tmpBRG > DE2BRG_MAX) && (tmpBRG < DE2BRG_MIN))
            {
                ${UARTBRG} = LastKnownBrg;
            }
            ${UARTMODE} |= 0x8000; /* re-enable UART */
            AutoBaudActive = 0;
        }
        else
        </#if>
        {
            /* expected back receive from transmission while command had been sent */
            if ((0 == DE2flags.TxPending) && (1 == DE2flags.SendCmd))
            {
                /* check if received byte is identical with sent one */
                if ((tmpRXREG == DE2TxBuf[TxCnt]) && (TxCnt < 2))
                {
                    TxCnt++;
                    ${mcpName}TxHandler();
                }
                else
                {
                    /* abort schedule as data had been corrupted */
                    DE2flags.b &= 0x80;
                    DE2flags.Error = (_eDE2Error) DE2_TRMT_MISMATCH;
                }
                RxCnt = 0;
            }
            else
            {
                if (RxCnt < 2) /* only 2 bytes expected for reception */
                {
                    if (0 == RxCnt) /* first byte is the CMD from MCP */
                    {
                        if ((tmpRXREG & 0xF) < 9) /* check CMD range */
                        {
                            /* check if data could used as CMD is ACK or unsolicited */

                            if (0 != (tmpRXREG & 0xC0))
                            {
                                DE2RxBuf[RxCnt] = tmpRXREG & 0xF; /* get the index */
                                RxCnt++;
                                if (0 != (tmpRXREG & 0x40))
                                {
                                    DE2flags.GotAck = 1;
                                }
                                else
                                {
                                    DE2flags.GotAck = 0;
                                }
                            }
                            else
                            {
                                /* discard the received data */
                                DE2flags.b &= 0x80;
                                DE2flags.Error = (_eDE2Error) DE2_GENERAL_RCV_NOK;
                            }
                        }
                    }
                    else
                    {
                        /* 
                         * reload the received command temporarily to prevent overwriting the SET config registers 
                         * from response. These responses are stored in the assocated GET registers to make 
                         * verify possible
                         */
                        cmd = DE2RxBuf[0] & 0xF;

                        if (((SET_CFG_0 & 0xF) == cmd) || \
                            <#if CFG_1_UNUSED == "false">
                                ((SET_CFG_1 & 0xF) == cmd) || \
                            </#if>
                                ((SET_CFG_2 & 0xF) == cmd))
                        {
                            cmd = (uint8_t) (cmd + 1);
                        }
                        else
                        {
                        }
                        /* copy received value into dedicated buffer */
                        ${mcpName}.b[cmd] = (uint8_t) tmpRXREG;
                        /* reset all com flags except ACK  */
                        DE2flags.b &= 0x88;
                        
                        /*
                         * check if received command is STATUS_0 or STATUS_1 
                         */

                        if (0x80 == (DE2RxBuf[0] & 0x80)) //If unsolicited message arrives notify upper layer
                        {
                            Status_Notification((_eDE2CMD) DE2RxBuf[0]);
                        }
                    }
                }
                else
                {
                    RxCnt = 0;
                    DE2flags.b &= 0x80;
                    DE2flags.Error = (_eDE2Error) DE2_RCV_FRAMESIZE_MISMATCH;
                }
            }
        }
    }
}

/* ********************************************************************	*/

/* ********************************************************************	*/

uint8_t ${mcpName}CheckACKResponse(void)
{
    uint8_t temp;

    temp = 0;

    if (0 != DE2flags.GotAck)
    {
        temp = 1;
        DE2flags.GotAck = 0;
    }
    return temp;
}

/* ********************************************************************	*/

/* ********************************************************************	*/

uint8_t ${mcpName}SendCmd(uint8_t cmd)
{
    uint8_t retval;

    retval = 0;

    DE2flags.b &= 0x80; /* reset all flags */
<#if MCP_AUTOBAUD_AVAILABLE == "true">        
    /* check if autobaud is still active */
    if (DE2flags.AutoBaud)
    {
        DE2flags.AutoBaud = 0;
        ${UARTMODE} &= 0xFFDF; /* clear autobaud mode */
        ${UARTBRG} = LastKnownBrg;
    }
</#if>
    if ((cmd & 0xF) < 9)
    {
        DE2TxBuf[0] = cmd;
        TxCnt = 0;
        RxCnt = 0;

        /* check if 2 bytes need to be transfered, this is relevant for SET commands 	*/

        if ((SET_CFG_0 == cmd) || <#if CFG_1_UNUSED == "false">(SET_CFG_1 == cmd) || </#if>(SET_CFG_2 == cmd))
        {
            /* copy data from local register map into transmission buffer */

            DE2TxBuf[1] = ${mcpName}.b[cmd & 0xF];
            TxReqCnt = 2; /* two bytes need to be transmitted */
            DE2flags.Request = 0; /* so no response request at this time */
        }
        else
        {
            DE2flags.Request = 1;
            TxReqCnt = 1;
        }

        /* check if DE2 line is idle before start transmission */
        /* start if bus is idle otherwise sign up to start after last reception */
        <#if deviceName?contains("dsPIC33C")>
        ${mcpName}TxHandler();
        <#else>
        if (${UARTRXIDL})
        {
            ${mcpName}TxHandler();
        }
        else
        {
            DE2flags.TxPending = 1;
        }
        </#if>

        retval = (uint16_t) DE2flags.TxPending;
    }
    else
    {
<#if MCP_AUTOBAUD_AVAILABLE == "true">    
        /* check if autobaud had been requested */
        if (RUN_AUTOBAUD == cmd)
        {

            DE2TxBuf[0] = cmd;
            DE2flags.AutoBaud = 1;
            /* 
             * set the BREAK bit and send a 0 causing 13TBIT
             * dominant frame. The autoBREAK feature is not used as with 
             * interrupt this would cause blocking inside the ISR for 3bit times
             * so the bit rate is changed to meet the 1.29 .. 2 ms window
             * based on nominal bit rate
             */
            LastKnownBrg = ${UARTBRG}; /* save the last working BRG value */
            ${UARTMODE} &= 0x7FFF; /* reset UART - Required to abort sync */
            
            /* 
             * nominal_bit rate * 1.75 -> center of SYNCH to meet 1.29 .. 2 ms low time 
             * calculation for center = 
             * (ABAUDDET_min+ABUADDET_max)/2 * DE2BRG_TYP/9
             * 
             */
            
            ${UARTBRG} = (uint16_t)DE2BRG_BREAK;
            ${UARTMODE} |= 0x8000; /* enable UART */
            ${UARTTXEN};
            ${UARTTXREG} = 0;
        }
        else
        {
            retval = -1;
        }
<#else >
        retval = -1;
</#if>
    }

    return retval;
}

/* ********************************************************************	*/

/* ********************************************************************	*/

inline void SetRegister${mcpName}(uint8_t reg, uint8_t value)
{
    uint8_t temp;

    temp = reg & 0xF; /* extract the index out of CMD */
    if (temp < 9) /* CFG_2 is last command with highest index of 8 */
    {
        ${mcpName}.b[temp] = value;
    }
}

/* ********************************************************************	*/

/* ********************************************************************	*/

inline uint8_t GetRegister${mcpName}(uint8_t reg)
{
    return ${mcpName}.b[reg & 0xF];
}
/* ********************************************************************	*/

/* ********************************************************************	*/

inline uint8_t ${mcpName}CommunicationIdle(void)
{
    /* ignore the autobaud active flag , handled through SendCmd() */
    return (uint8_t) (DE2flags.b & 0x15);
}

/* ********************************************************************	*/

/* ********************************************************************	*/

void UART${uartNumber}_Receive_CallBack(void)
{
    ${mcpName}RxHandler(); /* check byte received */
}

/* ********************************************************************	*/

/* ********************************************************************	*/