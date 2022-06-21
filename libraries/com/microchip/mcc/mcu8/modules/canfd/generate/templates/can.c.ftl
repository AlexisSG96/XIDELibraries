/**
  ${moduleNameUpperCase} Generated Driver File

  @Company
    Microchip Technology Inc.

  @File Name
    ${moduleNameLowerCase}.c

  @Summary
    This is the generated driver implementation file for the ${moduleNameUpperCase} driver using ${productName}

  @Description
    This header file provides implementations for driver APIs for ${moduleNameUpperCase}.
    Generation Information :
        Product Revision  :  ${productName} - ${productVersion}
        Device            :  ${selectedDevice}
        Driver Version    :  1.1.1
    The generated drivers are tested against the following:
        Compiler          :  ${compiler} or later
        MPLAB             :  ${tool}
*/

${disclaimer}

#include <xc.h>
#include <stdint.h>
#include <string.h>
#include "${moduleNameLowerCase}.h"

<#if rxFifoList?has_content>
#define RX_FIFO_MSG_DATA                (${maxRxPayloadSize}U)
#define NUM_OF_RX_FIFO                  (${rxFifoList?size}U)
</#if>

#define SID_LOW_WIDTH                   (8U)
#define SID_HIGH_MASK                   (0x07U)
#define EID_LOW_WIDTH                   (5U)
#define EID_LOW_POSN                    (3U)
#define EID_LOW_MASK                    (0xF8U)
#define EID_MID_WIDTH                   (8U)
#define EID_HIGH_WIDTH                  (5U)
#define EID_HIGH_MASK                   (0x1FU)
#define IDE_POSN                        (4U)
#define RTR_POSN                        (5U)
#define BRS_POSN                        (6U)
#define FDF_POSN                        (7U)

#define DLCToPayloadBytes(x)            (DLC_BYTES[(x)])
#define PLSIZEToPayloadBytes(x)         (DLCToPayloadBytes(8u + (x)))

struct CAN_FIFOREG
{
    uint8_t CONL;
    uint8_t CONH;
    uint8_t CONU;
    uint8_t CONT;
    uint8_t STAL;
    uint8_t STAH;
    uint8_t STAU;
    uint8_t STAT;
    uint32_t UA;
};

<#if rxFifoList?has_content>
typedef enum
{
    CAN_RX_MSG_NOT_AVAILABLE = 0U,
    CAN_RX_MSG_AVAILABLE = 1U,
    CAN_RX_MSG_OVERFLOW = 8U
} CAN_RX_FIFO_STATUS;

<#if CANRXI_ENABLE.value == "disabled">
typedef enum
{
    <#list rxFifoList as fifo>
    ${fifo.name} = ${fifo.fifoNum}<#if fifo?has_next>,</#if>
    </#list>
} ${moduleNameUpperCase}_RX_FIFO_CHANNELS;
</#if>

struct ${moduleNameUpperCase}_RX_FIFO
{
    ${moduleNameUpperCase}_RX_FIFO_CHANNELS channel;
    volatile uint8_t fifoHead;
};

//CAN RX FIFO Message object data field 
static<#if CANRXI_ENABLE.value == "enabled"> volatile</#if> uint8_t rxMsgData[RX_FIFO_MSG_DATA];

static struct ${moduleNameUpperCase}_RX_FIFO rxFifos[] = 
{
    <#list rxFifoList as fifo>
    {${fifo.name}, 0u}<#if fifo?has_next>,</#if>
    </#list>
};

</#if>
static volatile struct CAN_FIFOREG * const FIFO = (struct CAN_FIFOREG *)&C1TXQCONL;
<#if operatingMode == "CAN_NORMAL_FD_MODE">
static const uint8_t DLC_BYTES[] = {0U, 1U, 2U, 3U, 4U, 5U, 6U, 7U, 8U, 12U, 16U, 20U, 24U, 32U, 48U, 64U};
<#else>
static const uint8_t DLC_BYTES[] = {0U, 1U, 2U, 3U, 4U, 5U, 6U, 7U, 8U};
</#if>

<#list txFifoIntList as fifo>
static void (*${moduleNameUpperCase}_${fifo.interruptHandler})(void);
</#list>
<#list rxFifoIntList as fifo>
static void (*${moduleNameUpperCase}_${fifo.interruptHandler})(void);
</#list>
<#if CANI_ENABLE.value == "enabled">
static void (*${moduleNameUpperCase}_InvalidMessageHandler)(void);
static void (*${moduleNameUpperCase}_BusWakeUpActivityHandler)(void);
static void (*${moduleNameUpperCase}_BusErrorHandler)(void);
static void (*${moduleNameUpperCase}_ModeChangeHandler)(void);
static void (*${moduleNameUpperCase}_SystemErrorHandler)(void);
<#if txFifoList?has_content>
static void (*${moduleNameUpperCase}_TxAttemptHandler)(void);
</#if>
<#if rxFifoList?has_content>
static void (*${moduleNameUpperCase}_RxBufferOverflowHandler)(void);
</#if>
</#if>

<#list txFifoIntList as fifo>
static void ${fifo.defaultInterruptHandler}(void)
{
}

</#list>
<#list rxFifoIntList as fifo>
static void ${fifo.defaultInterruptHandler}(void)
{
}

</#list>
<#if CANI_ENABLE.value == "enabled">
static void DefaultInvalidMessageHandler(void)
{
}

static void DefaultBusWakeUpActivityHandler(void)
{
}

static void DefaultBusErrorHandler(void)
{
}

static void DefaultModeChangeHandler(void)
{
}

static void DefaultSystemErrorHandler(void)
{
}

<#if txFifoList?has_content>
static void DefaultTxAttemptHandler(void)
{
}

</#if>
<#if rxFifoList?has_content>
static void DefaultRxBufferOverflowHandler(void)
{
}

</#if>
</#if>
<#if rxFifoList?has_content>
void ${moduleNameUpperCase}_RX_FIFO_ResetInfo(void)
{
    uint8_t index;

    for (index = 0; index < NUM_OF_RX_FIFO; index++)
    {
        rxFifos[index].fifoHead = 0;
    }
}

static void ${moduleNameUpperCase}_RX_FIFO_Configuration(void)
{
    <#list rxFifoList as fifo>
    // ${.vars[fifo.CONL].csvComment}
    ${.vars[fifo.CONL].name} = ${.vars[fifo.CONL].hexValue};
    
    // ${.vars[fifo.CONH].csvComment}
    ${.vars[fifo.CONH].name} = ${.vars[fifo.CONH].hexValue};
    
    // ${.vars[fifo.CONU].csvComment}
    ${.vars[fifo.CONU].name} = ${.vars[fifo.CONU].hexValue};
    
    // ${.vars[fifo.CONT].csvComment}
    ${.vars[fifo.CONT].name} = ${.vars[fifo.CONT].hexValue};
    
    </#list>
    <#list rxFifoIntList as fifo>
    ${moduleNameUpperCase}_${fifo.setInterruptHandler}(${fifo.defaultInterruptHandler});
    </#list>
    <#if CANRXI_ENABLE.value == "enabled">
    
    ${CINTU.name}bits.RXIE = 1;
    
    ${CANRXI_FLAG.name} = 0;
    ${CANRXI_ENABLE.name} = 1;
    </#if>
}

static void ${moduleNameUpperCase}_RX_FIFO_FilterMaskConfiguration(void)
{
    <#list filterList as filter>
    // ${.vars[filter.FLTCON].csvComment}
    ${.vars[filter.FLTOBJL].name} = ${.vars[filter.FLTOBJL].hexValue};
    ${.vars[filter.FLTOBJH].name} = ${.vars[filter.FLTOBJH].hexValue};
    ${.vars[filter.FLTOBJU].name} = ${.vars[filter.FLTOBJU].hexValue};
    ${.vars[filter.FLTOBJT].name} = ${.vars[filter.FLTOBJT].hexValue};
    ${.vars[filter.MASKL].name} = ${.vars[filter.MASKL].hexValue};
    ${.vars[filter.MASKH].name} = ${.vars[filter.MASKH].hexValue};
    ${.vars[filter.MASKU].name} = ${.vars[filter.MASKU].hexValue};
    ${.vars[filter.MASKT].name} = ${.vars[filter.MASKT].hexValue};
    ${.vars[filter.FLTCON].name} = ${.vars[filter.FLTCON].hexValue}; 
    
    </#list>
}
</#if>

<#if txFifoList?has_content>
static void ${moduleNameUpperCase}_TX_FIFO_Configuration(void)
{
    <#list txFifoList as fifo>
    // ${.vars[fifo.CONL].csvComment}
    ${.vars[fifo.CONL].name} = ${.vars[fifo.CONL].hexValue};
    
    // ${.vars[fifo.CONH].csvComment}
    ${.vars[fifo.CONH].name} = ${.vars[fifo.CONH].hexValue};
    
    // ${.vars[fifo.CONU].csvComment}
    ${.vars[fifo.CONU].name} = ${.vars[fifo.CONU].hexValue};
    
    // ${.vars[fifo.CONT].csvComment}
    ${.vars[fifo.CONT].name} = ${.vars[fifo.CONT].hexValue};
    
    </#list>
    <#list txFifoIntList as fifo>
    ${moduleNameUpperCase}_${fifo.setInterruptHandler}(${fifo.defaultInterruptHandler});
    </#list>
    <#if CANTXI_ENABLE.value == "enabled">
    
    ${CINTU.name}bits.TXIE = 1;
    
    ${CANTXI_FLAG.name} = 0;
    ${CANTXI_ENABLE.name} = 1;
    </#if>
}
</#if>

static void ${moduleNameUpperCase}_BitRateConfiguration(void)
{
    <#if CNBTCFGL?has_content>
    // ${CNBTCFGL.csvComment}
    ${CNBTCFGL.name} = ${CNBTCFGL.hexValue};
    </#if>
    
    <#if CNBTCFGH?has_content>
    // ${CNBTCFGH.csvComment}
    ${CNBTCFGH.name} = ${CNBTCFGH.hexValue};
    </#if>
    
    <#if CNBTCFGU?has_content>
    // ${CNBTCFGU.csvComment}
    ${CNBTCFGU.name} = ${CNBTCFGU.hexValue};
    </#if>
    
    <#if CNBTCFGT?has_content>
    // ${CNBTCFGT.csvComment}
    ${CNBTCFGT.name} = ${CNBTCFGT.hexValue};
    </#if>
    
    <#if operatingMode == "CAN_NORMAL_FD_MODE" && bitRateSwitch == "enabled">
    <#if CDBTCFGL?has_content>
    // ${CDBTCFGL.csvComment}
    ${CDBTCFGL.name} = ${CDBTCFGL.hexValue};
    </#if>
    
    <#if CDBTCFGH?has_content>
    // ${CDBTCFGH.csvComment}
    ${CDBTCFGH.name} = ${CDBTCFGH.hexValue};
    </#if>
    
    <#if CDBTCFGU?has_content>
    // ${CDBTCFGU.csvComment}
    ${CDBTCFGU.name} = ${CDBTCFGU.hexValue};
    </#if>
    
    <#if CDBTCFGT?has_content>
    // ${CDBTCFGT.csvComment}
    ${CDBTCFGT.name} = ${CDBTCFGT.hexValue};
    </#if>
    
    <#if CTDCH??>
    // ${CTDCH.csvComment}
    ${CTDCH.name} = ${CTDCH.hexValue};
    </#if>
    
    <#if CTDCU??>
    // ${CTDCU.csvComment}
    ${CTDCU.name} = ${CTDCU.hexValue};
    </#if>
    </#if>
}

<#if CANI_ENABLE.value == "enabled">
static void ${moduleNameUpperCase}_ErrorNotificationInterruptEnable(void)
{
    ${moduleNameUpperCase}_SetInvalidMessageInterruptHandler(DefaultInvalidMessageHandler);
    ${moduleNameUpperCase}_SetBusWakeUpActivityInterruptHandler(DefaultBusWakeUpActivityHandler);
    ${moduleNameUpperCase}_SetBusErrorInterruptHandler(DefaultBusErrorHandler);
    ${moduleNameUpperCase}_SetModeChangeInterruptHandler(DefaultModeChangeHandler);
    ${moduleNameUpperCase}_SetSystemErrorInterruptHandler(DefaultSystemErrorHandler);
    <#if txFifoList?has_content>
    ${moduleNameUpperCase}_SetTxAttemptInterruptHandler(DefaultTxAttemptHandler);
    </#if>
    <#if rxFifoList?has_content>
    ${moduleNameUpperCase}_SetRxBufferOverFlowInterruptHandler(DefaultRxBufferOverflowHandler);
    </#if>
    ${CANI_FLAG.name} = 0;
    
    <#if CINTL?has_content>
    // ${CINTL.csvComment}
    ${CINTL.name} = ${CINTL.hexValue};
    </#if>
    
    <#if CINTH?has_content>
    // ${CINTH.csvComment}
    ${CINTH.name} = ${CINTH.hexValue};
    </#if>
    
    <#if CINTU?has_content>
    // ${CINTU.csvComment}
    ${CINTU.name} = ${CINTU.hexValue};
    </#if>
    
    <#if CINTT?has_content>
    // ${CINTT.csvComment}
    ${CINTT.name} = ${CINTT.hexValue};
    </#if>
    
    ${CANI_ENABLE.name} = 1;
}
</#if>

void ${moduleNameUpperCase}_Initialize(void)
{
    /* Enable the CAN module */
    ${CCONH.name}bits.ON = 1;
    
    if (CAN_OP_MODE_REQUEST_SUCCESS == ${moduleNameUpperCase}_OperationModeSet(CAN_CONFIGURATION_MODE))
    {
        /* Initialize the C1FIFOBA with the start address of the CAN FIFO message object area. */
        C1FIFOBA = ${fifoBaseAddress};
        
        <#if CCONL?has_content>
        // ${CCONL.csvComment}
        ${CCONL.name} = ${CCONL.hexValue};
        </#if>

        <#if CCONH?has_content>
        // ${CCONH.csvComment}
        ${CCONH.name} = ${CCONH.hexValue};
        </#if>

        <#if CCONU?has_content>
        // ${CCONU.csvComment}
        ${CCONU.name} = ${CCONU.hexValue};
        </#if>

        ${moduleNameUpperCase}_BitRateConfiguration();
        <#if txFifoList?has_content>
        ${moduleNameUpperCase}_TX_FIFO_Configuration();
        </#if>
        <#if rxFifoList?has_content>
        ${moduleNameUpperCase}_RX_FIFO_Configuration();
        ${moduleNameUpperCase}_RX_FIFO_FilterMaskConfiguration();
        ${moduleNameUpperCase}_RX_FIFO_ResetInfo();
        </#if>
        <#if CANI_ENABLE.value == "enabled">
        ${moduleNameUpperCase}_ErrorNotificationInterruptEnable();
        </#if>
        ${moduleNameUpperCase}_OperationModeSet(${operatingMode});    
    }
}

CAN_OP_MODE_STATUS ${moduleNameUpperCase}_OperationModeSet(const CAN_OP_MODES requestMode)
{
    CAN_OP_MODE_STATUS status = CAN_OP_MODE_REQUEST_SUCCESS;
    CAN_OP_MODES opMode = ${moduleNameUpperCase}_OperationModeGet();

    if (CAN_CONFIGURATION_MODE == opMode
            || CAN_DISABLE_MODE == requestMode
            || CAN_CONFIGURATION_MODE == requestMode)
    {
        ${CCONT.name}bits.REQOP = requestMode;
        
        while (${CCONU.name}bits.OPMOD != requestMode)
        {
            //This condition is avoiding the system error case endless loop
            if (1 == ${CINTH.name}bits.SERRIF)
            {
                status = CAN_OP_MODE_SYS_ERROR_OCCURED;
                break;
            }
        }
    }
    else
    {
        status = CAN_OP_MODE_REQUEST_FAIL;
    }

    return status;
}

CAN_OP_MODES ${moduleNameUpperCase}_OperationModeGet(void)
{
    return ${CCONU.name}bits.OPMOD;
}

<#if rxFifoList?has_content>
static uint8_t GetRxFifoDepth(uint8_t validChannel)
{
    return 1U + (FIFO[validChannel].CONT & _C1FIFOCON1T_FSIZE_MASK);
}

static CAN_RX_FIFO_STATUS GetRxFifoStatus(uint8_t validChannel)
{
    return FIFO[validChannel].STAL & (CAN_RX_MSG_AVAILABLE | CAN_RX_MSG_OVERFLOW);
}

static void ReadMessageFromFifo(uint8_t *rxFifoObj, CAN_MSG_OBJ *rxCanMsg)
{
    uint32_t msgId;
    uint8_t status = rxFifoObj[4];
    const uint8_t payloadOffsetBytes =
              4U    // ID
            + 1U    // FDF, BRS, RTR, ...
            + 1U    // FILHIT, ...
            + 2U;   // Unimplemented
    
    rxCanMsg->field.dlc = status;
    rxCanMsg->field.idType = (status & (1UL << IDE_POSN)) ? CAN_FRAME_EXT : CAN_FRAME_STD;
    rxCanMsg->field.frameType = (status & (1UL << RTR_POSN)) ? CAN_FRAME_RTR : CAN_FRAME_DATA;
    rxCanMsg->field.brs = (status & (1UL << BRS_POSN)) ? CAN_BRS_MODE : CAN_NON_BRS_MODE;
    rxCanMsg->field.formatType = (status & (1UL << FDF_POSN)) ? CAN_FRAME_EXT : CAN_FRAME_STD;
       
    msgId = rxFifoObj[1] & SID_HIGH_MASK;
    msgId <<= SID_LOW_WIDTH;
    msgId |= rxFifoObj[0];
    if (CAN_FRAME_EXT == rxCanMsg->field.idType)
    {
        msgId <<= EID_HIGH_WIDTH;
        msgId |= (rxFifoObj[3] & EID_HIGH_MASK);
        msgId <<= EID_MID_WIDTH;
        msgId |= rxFifoObj[2];
        msgId <<= EID_LOW_WIDTH;
        msgId |= (rxFifoObj[1] & EID_LOW_MASK) >> EID_LOW_POSN;
    }
    rxCanMsg->msgId = msgId;
    
    memcpy(rxMsgData, rxFifoObj + payloadOffsetBytes, DLCToPayloadBytes(rxCanMsg->field.dlc));
    rxCanMsg->data = rxMsgData;
}

<#if CANRXI_ENABLE.value == "enabled">
static bool Receive(uint8_t index, ${moduleNameUpperCase}_RX_FIFO_CHANNELS channel, CAN_MSG_OBJ *rxCanMsg)
{
    bool status = false;
    CAN_RX_FIFO_STATUS rxMsgStatus = GetRxFifoStatus(channel);

    if (CAN_RX_MSG_AVAILABLE == (rxMsgStatus & CAN_RX_MSG_AVAILABLE))
    {
        uint8_t *rxFifoObj = (uint8_t *) FIFO[channel].UA;

        if (rxFifoObj != NULL)
        {
            ReadMessageFromFifo(rxFifoObj, rxCanMsg);
            FIFO[channel].CONH |= _C1FIFOCON1H_UINC_MASK;

            rxFifos[index].fifoHead += 1;
            if (rxFifos[index].fifoHead >= GetRxFifoDepth(channel))
            {
                rxFifos[index].fifoHead = 0;
            }

            if (CAN_RX_MSG_OVERFLOW == (rxMsgStatus & CAN_RX_MSG_OVERFLOW))
            {
                FIFO[channel].STAL &= ~_C1FIFOSTA1L_RXOVIF_MASK;
            }

            status = true;
        }
    }
    
    return status;
}

bool ${moduleNameUpperCase}_Receive(CAN_MSG_OBJ *rxCanMsg)
{
    uint8_t index;
    bool status = false;
    
    for (index = 0; index < NUM_OF_RX_FIFO; index++)
    {
        status = Receive(index, rxFifos[index].channel, rxCanMsg);
        
        if (status)
        {
            break;
        }
    }
    
    return status;
}

bool ${moduleNameUpperCase}_ReceiveFrom(const ${moduleNameUpperCase}_RX_FIFO_CHANNELS channel, CAN_MSG_OBJ *rxCanMsg)
{
    uint8_t index;
    bool status = false;
    
    for (index = 0; index < NUM_OF_RX_FIFO; index++)
    {
        if (channel == rxFifos[index].channel)
        {
            status = Receive(index, channel, rxCanMsg);
            break;
        }
    }
    
    return status;
}
<#else>
bool ${moduleNameUpperCase}_Receive(CAN_MSG_OBJ *rxCanMsg)
{
    uint8_t index;
    bool status = false;
    
    for (index = 0; index < NUM_OF_RX_FIFO; index++)
    {
        ${moduleNameUpperCase}_RX_FIFO_CHANNELS channel = rxFifos[index].channel;
        CAN_RX_FIFO_STATUS rxMsgStatus = GetRxFifoStatus(channel);

        if (CAN_RX_MSG_AVAILABLE == (rxMsgStatus & CAN_RX_MSG_AVAILABLE))
        {
            uint8_t *rxFifoObj = (uint8_t *) FIFO[channel].UA;
            
            if (rxFifoObj != NULL)
            {
                ReadMessageFromFifo(rxFifoObj, rxCanMsg);
                FIFO[channel].CONH |= _C1FIFOCON1H_UINC_MASK;
                
                rxFifos[index].fifoHead += 1;
                if (rxFifos[index].fifoHead >= GetRxFifoDepth(channel))
                {
                    rxFifos[index].fifoHead = 0;
                }

                if (CAN_RX_MSG_OVERFLOW == (rxMsgStatus & CAN_RX_MSG_OVERFLOW))
                {
                    FIFO[channel].STAL &= ~_C1FIFOSTA1L_RXOVIF_MASK;
                }

                status = true;
            }

            break;
        }
    }
    return status;
}
</#if>

uint8_t ${moduleNameUpperCase}_ReceivedMessageCountGet(void)
{
    uint8_t index, totalMsgObj = 0;

    for (index = 0; index < NUM_OF_RX_FIFO; index++)
    {
        ${moduleNameUpperCase}_RX_FIFO_CHANNELS channel = rxFifos[index].channel;
        CAN_RX_FIFO_STATUS rxMsgStatus = GetRxFifoStatus(channel);

        if (CAN_RX_MSG_AVAILABLE == (rxMsgStatus & CAN_RX_MSG_AVAILABLE))
        {
            uint8_t numOfMsg, fifoDepth = GetRxFifoDepth(channel);
            
            if (CAN_RX_MSG_OVERFLOW == (rxMsgStatus & CAN_RX_MSG_OVERFLOW))
            {
                numOfMsg = fifoDepth;
            }
            else
            {
                uint8_t fifoTail = FIFO[channel].STAH & _C1FIFOSTA1H_FIFOCI_MASK;
                uint8_t fifoHead = rxFifos[index].fifoHead;

                if (fifoTail < fifoHead)
                {
                    numOfMsg = ((fifoTail + fifoDepth) - fifoHead); // wrap
                }
                else if (fifoTail > fifoHead)
                {
                    numOfMsg = fifoTail - fifoHead;
                }
                else
                {
                    numOfMsg = fifoDepth;
                }
            }

            totalMsgObj += numOfMsg;
        }
    }

    return totalMsgObj;
}
</#if>

<#if txFifoList?has_content>
static bool isTxChannel(uint8_t channel) 
{
    return channel < 4u && (FIFO[channel].CONL & _C1FIFOCON1L_TXEN_MASK);
}

static CAN_TX_FIFO_STATUS GetTxFifoStatus(uint8_t validChannel)
{
    return (FIFO[validChannel].STAL & _C1FIFOSTA1L_TFNRFNIF_MASK);
}

static void WriteMessageToFifo(uint8_t *txFifoObj, CAN_MSG_OBJ *txCanMsg)
{
    uint32_t msgId = txCanMsg->msgId;
    uint8_t status;
    const uint8_t payloadOffsetBytes =
              4U    // ID
            + 1U    // FDF, BRS, RTR, ...
            + 1U    // SEQ[6:0], ESI
            + 2U;   // SEQ
    
    if (CAN_FRAME_EXT == txCanMsg->field.idType)
    {
        txFifoObj[1] = (msgId << EID_LOW_POSN) & EID_LOW_MASK;
        msgId >>= EID_LOW_WIDTH;
        txFifoObj[2] = msgId;
        msgId >>= EID_MID_WIDTH;
        txFifoObj[3] = (msgId & EID_HIGH_MASK);
        msgId >>= EID_HIGH_WIDTH;
    }
    else
    {
        txFifoObj[1] = txFifoObj[2] = txFifoObj[3] = 0;
    }
    
    txFifoObj[0] = msgId;
    msgId >>= SID_LOW_WIDTH;
    txFifoObj[1] |= (msgId & SID_HIGH_MASK);
    
    status = txCanMsg->field.dlc;
    status |= (txCanMsg->field.idType << IDE_POSN);
    status |= (txCanMsg->field.frameType << RTR_POSN);
    status |= (txCanMsg->field.brs << BRS_POSN);
    status |= (txCanMsg->field.formatType << FDF_POSN);
    txFifoObj[4] = status;

    if (CAN_FRAME_DATA == txCanMsg->field.frameType)
    {
        memcpy(txFifoObj + payloadOffsetBytes, txCanMsg->data, DLCToPayloadBytes(txCanMsg->field.dlc));
    }
}

static CAN_TX_MSG_REQUEST_STATUS ValidateTransmission(uint8_t validChannel, CAN_MSG_OBJ *txCanMsg)
{
    CAN_TX_MSG_REQUEST_STATUS txMsgStatus = CAN_TX_MSG_REQUEST_SUCCESS;
    CAN_MSG_FIELD field = txCanMsg->field;
    <#if operatingMode == "CAN_NORMAL_FD_MODE">
    uint8_t plsize = (FIFO[validChannel].CONT & _C1FIFOCON1T_PLSIZE_MASK) >> _C1FIFOCON1T_PLSIZE_POSN;
    <#else>
    uint8_t plsize = 0;
    </#if>
    
    <#if operatingMode == "CAN_NORMAL_FD_MODE">
    if (CAN_BRS_MODE == field.brs && (1 == ${CCONH.name}bits.BRSDIS || CAN_NORMAL_2_0_MODE == ${moduleNameUpperCase}_OperationModeGet()))
    <#else>
    if (CAN_BRS_MODE == field.brs && (CAN_NORMAL_2_0_MODE == ${moduleNameUpperCase}_OperationModeGet()))
    </#if>
    {
        txMsgStatus |= CAN_TX_MSG_REQUEST_BRS_ERROR;
    }
    
    if (field.dlc > DLC_8 && (CAN_2_0_FORMAT == field.formatType || CAN_NORMAL_2_0_MODE == ${moduleNameUpperCase}_OperationModeGet()))
    {
        txMsgStatus |= CAN_TX_MSG_REQUEST_DLC_EXCEED_ERROR;
    }
    
    if (DLCToPayloadBytes(field.dlc) > PLSIZEToPayloadBytes(plsize))
    {
        txMsgStatus |= CAN_TX_MSG_REQUEST_DLC_EXCEED_ERROR;
    }
    
    if (CAN_TX_FIFO_FULL == GetTxFifoStatus(validChannel))
    {
        txMsgStatus |= CAN_TX_MSG_REQUEST_FIFO_FULL;
    }
    
    return txMsgStatus;
}

CAN_TX_MSG_REQUEST_STATUS ${moduleNameUpperCase}_Transmit(const ${moduleNameUpperCase}_TX_FIFO_CHANNELS fifoChannel, CAN_MSG_OBJ *txCanMsg)
{
    CAN_TX_MSG_REQUEST_STATUS status = CAN_TX_MSG_REQUEST_FIFO_FULL;
    
    if (isTxChannel(fifoChannel))
    {
        status = ValidateTransmission(fifoChannel, txCanMsg);
        if (CAN_TX_MSG_REQUEST_SUCCESS == status)
        {
            uint8_t *txFifoObj = (uint8_t *) FIFO[fifoChannel].UA;
            
            if (txFifoObj != NULL)
            {
                WriteMessageToFifo(txFifoObj, txCanMsg);
                FIFO[fifoChannel].CONH |= (_C1FIFOCON1H_TXREQ_MASK | _C1FIFOCON1H_UINC_MASK);
            }
        }
    }
    
    return status;
}

CAN_TX_FIFO_STATUS ${moduleNameUpperCase}_TransmitFIFOStatusGet(const ${moduleNameUpperCase}_TX_FIFO_CHANNELS fifoChannel)
{
    CAN_TX_FIFO_STATUS status = CAN_TX_FIFO_FULL;
    
    if (isTxChannel(fifoChannel)) 
    {
        status = GetTxFifoStatus(fifoChannel);
    }
    
    return status;
}
</#if>

bool ${moduleNameUpperCase}_IsBusOff(void)
{
    return ${CTRECU.name}bits.TXBO;
}

bool ${moduleNameUpperCase}_IsRxErrorPassive(void)
{
    return ${CTRECU.name}bits.RXBP;
}

bool ${moduleNameUpperCase}_IsRxErrorWarning(void)
{
    return ${CTRECU.name}bits.RXWARN;
}

bool ${moduleNameUpperCase}_IsRxErrorActive(void)
{
    return !${moduleNameUpperCase}_IsRxErrorPassive();
}

bool ${moduleNameUpperCase}_IsTxErrorPassive(void)
{
    return ${CTRECU.name}bits.TXBP;
}

bool ${moduleNameUpperCase}_IsTxErrorWarning(void)
{
    return ${CTRECU.name}bits.TXWARN;
}

bool ${moduleNameUpperCase}_IsTxErrorActive(void)
{
    return !${moduleNameUpperCase}_IsTxErrorPassive();
}

void ${moduleNameUpperCase}_Sleep(void)
{
    ${CINTH.name}bits.WAKIF = 0;
    ${CINTT.name}bits.WAKIE = 1;
    
    ${moduleNameUpperCase}_OperationModeSet(CAN_DISABLE_MODE);
}

<#if CANI_ENABLE.value == "enabled">
void ${moduleNameUpperCase}_SetInvalidMessageInterruptHandler(void (*handler)(void))
{
    ${moduleNameUpperCase}_InvalidMessageHandler = handler;
}

void ${moduleNameUpperCase}_SetBusWakeUpActivityInterruptHandler(void (*handler)(void))
{
    ${moduleNameUpperCase}_BusWakeUpActivityHandler = handler;
}

void ${moduleNameUpperCase}_SetBusErrorInterruptHandler(void (*handler)(void))
{
    ${moduleNameUpperCase}_BusErrorHandler = handler;
}

void ${moduleNameUpperCase}_SetModeChangeInterruptHandler(void (*handler)(void))
{
    ${moduleNameUpperCase}_ModeChangeHandler = handler;
}

void ${moduleNameUpperCase}_SetSystemErrorInterruptHandler(void (*handler)(void))
{
    ${moduleNameUpperCase}_SystemErrorHandler = handler;
}

<#if txFifoList?has_content>
void ${moduleNameUpperCase}_SetTxAttemptInterruptHandler(void (*handler)(void))
{
    ${moduleNameUpperCase}_TxAttemptHandler = handler;
}

</#if>
<#if rxFifoList?has_content>
void ${moduleNameUpperCase}_SetRxBufferOverFlowInterruptHandler(void (*handler)(void))
{
    ${moduleNameUpperCase}_RxBufferOverflowHandler = handler;
}

</#if>
<#if isVectoredInterrupt>
<#if isHighPriority>
void __interrupt(irq(${canIrqName}),base(${ivtBaseAddress})) ${moduleNameUpperCase}_${CANI_ISR}(void)
<#else>
void __interrupt(irq(${canIrqName}),base(${ivtBaseAddress}),low_priority) ${moduleNameUpperCase}_${CANI_ISR}(void)
</#if>
<#else>
void ${moduleNameUpperCase}_${CANI_ISR}(void)
</#if>
{
    if (1 == ${CINTH.name}bits.IVMIF)
    {
        ${moduleNameUpperCase}_InvalidMessageHandler();
        ${CINTH.name}bits.IVMIF = 0;
    }
    
    if (1 == ${CINTH.name}bits.WAKIF)
    {
        ${moduleNameUpperCase}_BusWakeUpActivityHandler();
        ${CINTH.name}bits.WAKIF = 0;
    }
    
    if (1 == ${CINTH.name}bits.CERRIF)
    {
        ${moduleNameUpperCase}_BusErrorHandler();
        ${CINTH.name}bits.CERRIF = 0;
    }
    
    if (1 == ${CINTL.name}bits.MODIF)
    {
        ${moduleNameUpperCase}_ModeChangeHandler();
        ${CINTL.name}bits.MODIF = 0;
    }
    
    if (1 == ${CINTH.name}bits.SERRIF)
    {
        ${moduleNameUpperCase}_SystemErrorHandler();
        ${CINTH.name}bits.SERRIF = 0;
    }
    
    <#if txFifoList?has_content>
    if (1 == ${CINTH.name}bits.TXATIF)
    {
        ${moduleNameUpperCase}_TxAttemptHandler();
        <#list txFifoList as fifo>
        if (1 == ${.vars[fifo.STAL].name}bits.TXATIF)
        {
            ${.vars[fifo.STAL].name}bits.TXATIF = 0;
        }
        </#list>
    }
    
    </#if>
    <#if rxFifoList?has_content>
    if (1 == ${CINTH.name}bits.RXOVIF)
    {
        ${moduleNameUpperCase}_RxBufferOverflowHandler();
        <#list rxFifoList as fifo>
        if (1 == ${.vars[fifo.STAL].name}bits.RXOVIF)
        {
            ${.vars[fifo.STAL].name}bits.RXOVIF = 0;
        }
        </#list>
    }
    
    </#if>
    ${CANI_FLAG.name} = 0;
}
</#if>

<#list rxFifoIntList as fifo>
void ${moduleNameUpperCase}_${fifo.setInterruptHandler}(void (*handler)(void))
{
    ${moduleNameUpperCase}_${fifo.interruptHandler} = handler;
}

</#list>
<#list txFifoIntList as fifo>
void ${moduleNameUpperCase}_${fifo.setInterruptHandler}(void (*handler)(void))
{
    ${moduleNameUpperCase}_${fifo.interruptHandler} = handler;
}

</#list>

<#if CANRXI_ENABLE.value == "enabled">
<#if isVectoredInterrupt>
<#if isHighPriorityCANRXI>
void __interrupt(irq(${canrxIrqName}),base(${ivtBaseAddress})) ${moduleNameUpperCase}_${CANRXI_ISR}(void)
<#else>
void __interrupt(irq(${canrxIrqName}),base(${ivtBaseAddress}),low_priority) ${moduleNameUpperCase}_${CANRXI_ISR}(void)
</#if>
<#else>
void ${moduleNameUpperCase}_${CANRXI_ISR}(void)
</#if>
{
    <#list rxFifoIntList as fifo>
    if (1 == ${.vars[fifo.STAL].name}bits.${fifo.intFlag})
    {
        ${moduleNameUpperCase}_${fifo.interruptHandler}();
        // flag readonly
    }
    
    </#list>
}
</#if>

<#if CANTXI_ENABLE.value == "enabled">
<#if isVectoredInterrupt>
<#if isHighPriorityCANTXI>
void __interrupt(irq(${cantxIrqName}),base(${ivtBaseAddress})) ${moduleNameUpperCase}_${CANTXI_ISR}(void)
<#else>
void __interrupt(irq(${cantxIrqName}),base(${ivtBaseAddress}),low_priority) ${moduleNameUpperCase}_${CANTXI_ISR}(void)
</#if>
<#else>
void ${moduleNameUpperCase}_${CANTXI_ISR}(void)
</#if>
{
    <#list txFifoIntList as fifo>
    if (1 == ${.vars[fifo.STAL].name}bits.${fifo.intFlag})
    {
        ${moduleNameUpperCase}_${fifo.interruptHandler}();
        // flag readonly
    }
    
    </#list>
}
</#if>
