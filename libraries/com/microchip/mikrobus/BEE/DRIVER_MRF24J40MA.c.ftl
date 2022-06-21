/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "mcc.h"
#include "device_config.h"
#include "${pinHeader}"
#include "DRIVER_MRF24J40MA.h"
#include "${SPIFunctions["spiHeader"]}"

uint16_t address_RX_FIFO, address_TX_normal_FIFO;
uint8_t data_RX_FIFO[RX_FIFO_SIZE], data_TX_normal_FIFO[TX_NORMAL_FIFO_SIZE];
uint8_t SEQ_NUMBER;

void MRF24J40MA_nCS_set_level(bool level)
{
   ${spiSSPinSettings["LAT"]} = level;
}

void MRF24J40MA_RST_set_level(bool level)
{
    ${resetPinSettings["LAT"]} = level;
}

void MRF24J40MA_WAKE_set_level(bool level)
{
    ${wakePinSettings["LAT"]} = level;
}


void MRF24J40MA_RFReset(void)
{
    uint8_t tempVal;
    
    tempVal = MRF24J40MA_ReadShortRegister(RFCTL);
    tempVal |= 0x04;
    MRF24J40MA_WriteShortRegister(RFCTL, tempVal);
    tempVal &= (~0x04);
    MRF24J40MA_WriteShortRegister(RFCTL, tempVal);
    <#if (isAVR == "true")>
    _delay_ms(1);
	<#else>
    __delay_ms(1);
	</#if>
}

void MRF24J40MA_SoftwareReset(void)
{
    MRF24J40MA_WriteShortRegister(SOFTRST, 0x07);
}

void MRF24J40MA_HardwareReset(void)
{
    MRF24J40MA_RST_set_level(false);
    <#if (isAVR == "true")>
    _delay_ms(5);
	<#else>
    __delay_ms(5);
	</#if>
    MRF24J40MA_RST_set_level(true);
    <#if (isAVR == "true")>
    _delay_ms(5);
	<#else>
    __delay_ms(5);
	</#if>
}

/**
 * @brief Initializes MRF24J40MA module and its interfaces to host MCU
 *        This API follows the initialization steps given in Section 3.2
 *        of MRF24J40MA data sheet
 * @return None.
 * @param None.
 */
void MRF24J40MA_Init(void)
{
    /*
     * On Power-on RESET:
     * Delay of 2mS is recommended after a Reset before accessing the MRF24J40MA
     * to allow RF circuitry to start up and stabilize
     * 
     * On pin RESET:
     * Delay of 2mS is recommended after a Reset before accessing the MRF24J40MA
     * to allow RF circuitry to start up and stabilize
     * 
     * On SOFT RESET:
     * No delay is required
     * 
     * On RF State Machine Reset:
     * Allow at least 192 uS delay
     * 
     * Follow initialization sequence in Section 3.2 of MRF24J40MA data sheet
     * Add support for Non-beacon mode
     */
 
       
    /*
     * Address and data buffer initializations
     */    
    SEQ_NUMBER = 0x23;
    
    <#if (isAVR == "true")>
    _delay_ms(5);
	<#else>
    __delay_ms(5);
	</#if>
    
    /*
     * Initialize SPI module as MASTER
     */
    ${SPIFunctions["spiOpen"]}(BEE);
    MRF24J40MA_nCS_set_level(true);
    
    MRF24J40MA_HardwareReset();  
    MRF24J40MA_SoftwareReset();
    MRF24J40MA_RFReset();
    
    /*
     * Set source addresses and PAN ID
     */
    MRF24J40MA_SetShortAddress(SRC_SHORT_ADDRESS);               //Set source short address
    MRF24J40MA_SetPANID(SRC_PAN_ID);                             //Set source PAN ID
    
    /*
     * Initialize the MRF24J40MA internal registers
     */
    MRF24J40MA_WriteShortRegister(PACON2, 0x98);                 //Initialize FIFOEN = 1 and TXONTS = 0x6
    MRF24J40MA_WriteShortRegister(TXSTBL, 0x95);                 //Initialize RFSTBL = 0x9
    MRF24J40MA_WriteLongRegister(RFCON0, 0x03);                  //Initialize RFOPT = 0x03, to select channel # 11
    MRF24J40MA_WriteLongRegister(RFCON1, 0x01);                  //Initialize VCOOPT = 0x02
    MRF24J40MA_WriteLongRegister(RFCON2, 0x80);                  //Enable PLL (PLLEN = 1)
    MRF24J40MA_WriteLongRegister(RFCON6, 0x90);                  //Initialize TXFIL = 1 and 20MRECVR = 1
    MRF24J40MA_WriteLongRegister(RFCON7, 0x80);                  //Initialize SLPCLKSEL = 0x2 (100 kHz Internal oscillator)
    MRF24J40MA_WriteLongRegister(RFCON8, 0x10);                  //Initialize RFVCO = 1
    MRF24J40MA_WriteLongRegister(SLPCON1, 0x21);                 //Initialize CLKOUTEN = 1 and SLPCLKDIV = 0x01
    
    /*
     * Configuration for Non-beacon-enabled devices
     */
    MRF24J40MA_WriteShortRegister(BBREG2, 0x80);                 //Set CCA mode to ED
    MRF24J40MA_WriteShortRegister(CCAEDTH, 0x60);                //Set CCA ED threshold to -69 dBm
    MRF24J40MA_WriteShortRegister(BBREG6, 0x40);                 //Set appended RSSI2 value to RXFIFO
    MRF24J40MA_WriteShortRegister(INTCON_M, 0x00);               //Enable interrupts
    MRF24J40MA_WriteLongRegister(RFCON0, 0x03);                  //Set channel # 11
    MRF24J40MA_WriteLongRegister(RFCON3, 0x0);                   //Set maximum TX power of 0dB    
    MRF24J40MA_WriteShortRegister(RFCTL, 0x04);                  //Reset RF state machine
    MRF24J40MA_WriteShortRegister(RFCTL, 0x00);
    <#if (isAVR == "true")>
    _delay_ms(1);
	<#else>
    __delay_ms(1);
	</#if>
    
    MRF24J40MA_SetNodeType(NONBEACON_PAN_CORRD);
    MRF24J40MA_SetRxFrameFilter(RX_ALL);
    MRF24J40MA_SetReceptionMode(RX_MODE_NORMAL);
    
    MRF24J40MA_WAKE_set_level(true);
    <#if (isAVR == "true")>
    _delay_ms(5);
	<#else>
    __delay_ms(5);
	</#if>
}

/**
 * @brief Selects the desired RF frequency channel
 * @return None
 * @param [in]Desired channel enumeration
 *            Refer enumeration "rf_channel_t" for more details
 *            Refer Section 3.4 of MRF24J40MA data sheet for more details on -
 *            - channel selection.
 */
void MRF24J40MA_SelectChannel(rf_channel_t ch)
{
    switch(ch)
    {
        //Set RFCON0
        case CHANNEL_2_405GHZ: //channel # 11
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_405GHZ);
            break;
        case CHANNEL_2_410GHZ: //channel # 12
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_410GHZ);
            break;
        case CHANNEL_2_415GHZ: //channel # 13
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_415GHZ);
            break;
        case CHANNEL_2_420GHZ: //channel # 14
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_420GHZ);
            break;
        case CHANNEL_2_425GHZ: //channel # 15
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_425GHZ);
            break;
        case CHANNEL_2_430GHZ: //channel # 16
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_430GHZ);
            break;
        case CHANNEL_2_435GHZ: //channel # 17
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_435GHZ);
            break;
        case CHANNEL_2_440GHZ: //channel # 18
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_440GHZ);
            break;
        case CHANNEL_2_445GHZ: //channel # 19
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_445GHZ);
            break;
        case CHANNEL_2_450GHZ: //channel # 20
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_450GHZ);
            break;
        case CHANNEL_2_455GHZ: //channel # 21
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_455GHZ);
            break;
        case CHANNEL_2_460GHZ: //channel # 22
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_460GHZ);
            break;
        case CHANNEL_2_465GHZ: //channel # 23
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_465GHZ);
            break;
        case CHANNEL_2_470GHZ: //channel # 24
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_470GHZ);
            break;
        case CHANNEL_2_475GHZ: //channel # 25
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_475GHZ);
            break;
        case CHANNEL_2_480GHZ: //channel # 26
            MRF24J40MA_WriteLongRegister(RFCON0, CHANNEL_2_480GHZ);
            break;
    }
    MRF24J40MA_RFReset();
}

/**
 * @brief Selects the desired CCA mode
 * @return None
 * @param [in]Desired CCA mode enumeration
 *            Refer enumeration "cca_mode_t" for more details
 *            Refer Section 3.5 of MRF24J40MA data sheet for more details on -
 *            - CCA mode.
 */
void MRF24J40MA_SelectCCAMode(cca_mode_t mode)
{
    uint8_t tempVal;
    
    switch(mode)
    {
        case CCA_MODE_1:
            //Program CCAMODE 0x3A<7:6> to the value, ?10?.
            tempVal = MRF24J40MA_ReadShortRegister(BBREG2);
            tempVal |= CCA_MODE_1;
            tempVal &= 0xDF;      //Keeping BBREG2<5:2> to 1111 and BBREG2<1:0> unaffected
            MRF24J40MA_WriteShortRegister(BBREG2, tempVal);

            //Program CCAEDTH 0x3F<7:0> with CCA ED threshold value (RSSI value)
            MRF24J40MA_WriteShortRegister(CCAEDTH, 0x60);   //Set threshold to -69dBm
            break;
            
        case CCA_MODE_2:
            //Program CCAMODE 0x3A<7:6> to the value, ?01?
            tempVal = MRF24J40MA_ReadShortRegister(BBREG2);
            tempVal |= CCA_MODE_2;
            tempVal &= 0x7F;      //Keeping BBREG2<5:2> to 1111 and BBREG2<1:0> unaffected
            MRF24J40MA_WriteShortRegister(BBREG2, tempVal);
            
            //Program CCACSTH 0x3A<5:2> with the CCA carrier sense threshold (units)
            tempVal = MRF24J40MA_ReadShortRegister(BBREG2);
            tempVal |= 0x38;      //Set to recommended value
            tempVal &= 0xFB;      //Keeping BBREG2<5:2> to 1110 and BBREG2<1:0> unaffected
            MRF24J40MA_WriteShortRegister(BBREG2, tempVal);
            break;
            
        case CCA_MODE_3:
            //Program CCAMODE 0x3A<7:6> to the value, ?11?
            tempVal = MRF24J40MA_ReadShortRegister(BBREG2);
            tempVal |= CCA_MODE_3;
            MRF24J40MA_WriteShortRegister(BBREG2, tempVal);
            
            //Program CCACSTH 0x3A<5:2> with the CCA carrier sense threshold
            tempVal = MRF24J40MA_ReadShortRegister(BBREG2);
            tempVal |= 0x38;      //Set to recommended value
            tempVal &= 0xFB;      //Keeping BBREG2<5:2> to 1110 and BBREG2<1:0> unaffected
            MRF24J40MA_WriteShortRegister(BBREG2, tempVal);
            
            //Program CCAEDTH 0x3F<7:0> with the CCA ED threshold (RSSI value)
            MRF24J40MA_WriteShortRegister(CCAEDTH, 0x60);   //Set threshold to -69dBm
            break;
    }
}

/**
 * @brief Selects the desired RSSI mode
 * @return None
 * @param [in]Desired RSSI mode enumeration
 *            Refer enumeration "rssi_mode_t" for more details
 *            Refer Section 3.5 of MRF24J40MA data sheet for more details on -
 *            - RSSI mode.
 */
void MRF24J40MA_SelectRSSIMode(rssi_mode_t mode)
{
    uint8_t tempVal;
    
    switch(mode)
    {
        case RSSI_MODE_1:
            tempVal = MRF24J40MA_ReadShortRegister(BBREG6);
            tempVal |= RSSI_MODE_1;
            MRF24J40MA_WriteShortRegister(BBREG6, tempVal);
            break;
        case RSSI_MODE_2:
            MRF24J40MA_WriteShortRegister(BBREG6, RSSI_MODE_2);
            break;
    }
}

/**
 * @brief Reads data from RX FIFO
 * @return Status of receive operation.
 *        true: Expected length of data is received
 *        false: Expected length of data is not received
 * @param [out]Pointer to buffer in which received payload contents to be read
 */
bool MRF24J40MA_ReadRxFIFO(uint8_t *rxData, uint8_t payloadLen)
{
    //Follow the steps given in Section 3.11, EXAMPLE 3-2 of MRF24J40MA data sheet
/*
 *   |---------|-----------------|-----------|--------|--------|--------|
 *   |    1    |        11       |    n      |   2    |   1    |    1   |
 *   |---------|-----------------|-----------|--------|--------|--------|
 *   |  Frame  |     Header      |  Payload  |  FCS   |  LQI   |  RSSI  |
 *   | Length  |                 |           |        |        |        |
 *   |---------|-----------------|-----------|--------|--------|--------|
 */
    uint8_t tempVal, i, actualPayloadLen;
    
    //Set RXDECINV = 1; disable receiving packets off air
    tempVal = MRF24J40MA_ReadShortRegister(BBREG1);
    tempVal |= 0x04;
    MRF24J40MA_WriteShortRegister(BBREG1, tempVal);
    
    data_RX_FIFO[0] = MRF24J40MA_ReadLongRegister((uint16_t)(RX_FIFO_ADDR));
    actualPayloadLen = data_RX_FIFO[0] - TX_FIFO_FIXED_DATA_LENGTH;
    
    //Error check for valid FIFO length
    if(actualPayloadLen < payloadLen)
    {
        return false;
    }
    else
    {
        //Extract contents of RX FIFO
        for(i=1; i<RX_FIFO_SIZE; i++)
        {
            if(i < (RX_FIFO_FIXED_DATA_LENGTH + payloadLen))
            {
                data_RX_FIFO[i] = MRF24J40MA_ReadLongRegister((uint16_t)(RX_FIFO_ADDR + i));
            }
            else
            {
                break;
            }
        }
        
        //Extract payload from rx fifo buffer
        for(i=0; i<payloadLen; i++)
        {
            rxData[i] = (uint8_t)data_RX_FIFO[HEADER_LENGTH + 1 + i];      //Retrieve payload
        }
    }
    
    //Clear RXDECINV; enable receiving packets off air
    tempVal = MRF24J40MA_ReadShortRegister(BBREG1);
    tempVal &= (~0x04);
    MRF24J40MA_WriteShortRegister(BBREG1, tempVal);    
    
    return true;
}

/**
 * @brief Writes data to be copied to normal TX FIFO
 *        This includes writing Header length, Frame length, Header and Payload
 * @return None
 * @param [in]Pointer to data buffer to be copied to TX FIFO
 */
void MRF24J40MA_WriteTxNormalFIFO(uint8_t *txPayload, uint8_t payloadLen)
{
    //Follow the steps given in Section 3.12.2 of MRF24J40MA data sheet
        
/*
 *    |-------------------|------------------------------------------------------|---------------|
 *    |    1    |    1    |    2    |    1   |   2    |   2    |   2    |   2    |    N Bytes    |
 *    |---------|---------|---------|--------|--------|--------|--------|--------|---------------|
 *    | Header  | Frame   |  Frame  |   SEQ  |  DEST  |  DEST  |  SRC   |  SRC   |     Data      |
 *    | Length  | Length  | Control |   NUM  |  PAN   |  ADR   |  PAN   |  ADR   |               |
 *    |---------|---------|---------|--------|--------|--------|--------|--------|---------------|
 *                        |<----------------------- Header --------------------->|<-- Payload -->|
 */
    uint8_t i;
    
    //Add error check for valid FIFO length: TODO
    
    data_TX_normal_FIFO[0] = HEADER_LENGTH;
    data_TX_normal_FIFO[1] = (uint8_t)(HEADER_LENGTH + payloadLen);
    data_TX_normal_FIFO[2] = 0x01;        //Control byte
    data_TX_normal_FIFO[3] = 0x88;        //Control byte
    data_TX_normal_FIFO[4] = SEQ_NUMBER;
    data_TX_normal_FIFO[5] = (uint8_t)DEST_PAN_ID;
    data_TX_normal_FIFO[6] = (uint8_t)((DEST_PAN_ID >> 8) & 0xFF);
    data_TX_normal_FIFO[7] = (uint8_t)DEST_SHORT_ADDRESS;
    data_TX_normal_FIFO[8] = (uint8_t)((DEST_SHORT_ADDRESS >> 8) & 0xFF);
    data_TX_normal_FIFO[9] = (uint8_t)SRC_PAN_ID;
    data_TX_normal_FIFO[10] = (uint8_t)((SRC_PAN_ID >> 8) & 0xFF);
    data_TX_normal_FIFO[11] = (uint8_t)SRC_SHORT_ADDRESS;
    data_TX_normal_FIFO[12] = (uint8_t)((SRC_SHORT_ADDRESS >> 8) & 0xFF);
    
    //Insert payload
    for(i=0; i<payloadLen; i++)
    {
        data_TX_normal_FIFO[13 + i] = (uint8_t)txPayload[i];
    }
    
    //Copy TX FIFO to long address memory space
    for(i=0; i<(TX_FIFO_FIXED_DATA_LENGTH + payloadLen); i++)
    {
        MRF24J40MA_WriteLongRegister((uint16_t)(TX_NORMAL_FIFO_ADDR + i), (uint8_t)data_TX_normal_FIFO[i]);
    }
    
    //Disable ACk and Encryption
    MRF24J40MA_ControlAckRequest(0);        //No acknowledgment
    MRF24J40MA_ControlSecurity(0);          //No encryption
    
    //Transmit data: Set TXNTRIG bit to Transmit the frame in the TX Normal FIFO
    i = MRF24J40MA_ReadShortRegister(TXNCON);
    i |= 0x01;
    MRF24J40MA_WriteShortRegister(TXNCON, i);
}

/**
 * @brief Configures PAN ID
 * @return None
 * @param [in]16-bit PAN ID
 */
void MRF24J40MA_SetPANID(uint16_t panid)
{
    //Write desired PAN ID to PANIDL and PANIDH registers
    MRF24J40MA_WriteShortRegister(PANIDL, (panid & 0xFF));
    MRF24J40MA_WriteShortRegister(PANIDH, ((panid >> 8) & 0xFF));
}

/**
 * @brief Configures 16-bit short address
 * @return None
 * @param [in] Pointer to buffer containing 16-bit short address
 */
void MRF24J40MA_SetShortAddress(uint16_t address)
{
    //Write requested short address to SADRL:SADRH
    MRF24J40MA_WriteShortRegister(SADRL, (address & 0xFF));
    MRF24J40MA_WriteShortRegister(SADRH, ((address >> 8) & 0xFF));
}

/**
 * @brief Configures TX power
 * @return None
 * @param [in] Value of power to be configured
 */
void MRF24J40MA_SetTXPower(uint8_t power)
{
    //Configure RFCON3 register to set the requested power
    if(power > 31)
        power = 31;
    
    power = (uint8_t)(31 - power);                                  //0-max, 31 min -> 31 max, 0 min
    power = (uint8_t)(((power & 0b00011111) << 3) & 0b11111000);    //Calculate power
    MRF24J40MA_WriteLongRegister(RFCON3, power);    
}

/**
 * @brief Enables/Disables PLL
 * @return None
 * @param [in] PLL value to be configured
 *             1: Enables PLL; 0: Disables PLL
 */
void MRF24J40MA_ControlPLL(bool state)
{
    //Configure PLL based on requested state
    if(state)
        MRF24J40MA_WriteLongRegister(RFCON2, 0x80);        //Enable PLL
    else
        MRF24J40MA_WriteLongRegister(RFCON2, 0x00);        //Disable PLL
}

/**
 * @brief Configures frame filter on received data
 * @return None
 * @param [in] Filter value to be applied on received data
 */
void MRF24J40MA_SetRxFrameFilter(rxfrm_filter_t filter)
{
    uint8_t tempVal;
    
    //Set filter for received frame
    switch(filter)
    {
        case RX_ALL:
            tempVal = MRF24J40MA_ReadShortRegister(RXFLUSH);
            tempVal &= (~RX_ALL);
            MRF24J40MA_WriteShortRegister(RXFLUSH, tempVal);
            break;
        case RX_CMD_ONLY:
            tempVal = MRF24J40MA_ReadShortRegister(RXFLUSH);
            tempVal &= (~RX_CMD_ONLY);
            tempVal |= 0x08;
            MRF24J40MA_WriteShortRegister(RXFLUSH, tempVal);
            break;
        case RX_DATA_ONLY:
            tempVal = MRF24J40MA_ReadShortRegister(RXFLUSH);
            tempVal &= (~RX_DATA_ONLY);
            tempVal |= 0x04;
            MRF24J40MA_WriteShortRegister(RXFLUSH, tempVal);
            break;
        case RX_BCN_ONLY:
            tempVal = MRF24J40MA_ReadShortRegister(RXFLUSH);
            tempVal &= (~RX_BCN_ONLY);
            tempVal |= 0x04;
            MRF24J40MA_WriteShortRegister(RXFLUSH, tempVal);
            break;
    }
}

/**
 * @brief Configures reception mode
 * @return None
 * @param [in] Mode to be applied
 */
void MRF24J40MA_SetReceptionMode(rx_mode_t mode)
{
    uint8_t tempVal;
    switch(mode)
    {
        case RX_MODE_NORMAL:
            tempVal = MRF24J40MA_ReadShortRegister(RXMCR);
            tempVal &= (~RX_MODE_NORMAL);
            MRF24J40MA_WriteShortRegister(RXMCR, tempVal);
            break;
        case RX_MODE_ERROR:
            tempVal = MRF24J40MA_ReadShortRegister(RXMCR);
            tempVal &= (~RX_MODE_ERROR);
            tempVal |= 0x02;
            MRF24J40MA_WriteShortRegister(RXMCR, tempVal);
            break;
        case RX_MODE_PROMISCUOUS:
            tempVal = MRF24J40MA_ReadShortRegister(RXMCR);
            tempVal &= (~RX_MODE_PROMISCUOUS);
            tempVal |= 0x01;
            MRF24J40MA_WriteShortRegister(RXMCR, tempVal);
            break;
    }
}

/**
 * @brief Configures device type
 * @return None
 * @param [in] Type to be applied
 */
void MRF24J40MA_SetNodeType(node_type_t type)
{
    uint8_t tempVal;
    
    switch(type)
    {
        case NONBEACON_PAN_CORRD:
            //Set the PANCOORD (RXMCR 0x00<3>) bit = 1 to configure as the PAN coordinator
            tempVal = MRF24J40MA_ReadShortRegister(RXMCR);
            tempVal |= 0x08;
            MRF24J40MA_WriteShortRegister(RXMCR, tempVal);

            //Clear the SLOTTED (TXMCR 0x11<5>) bit = 0 to configure Unslotted CSMA-CA mode
            tempVal = MRF24J40MA_ReadShortRegister(TXMCR);
            tempVal &= 0xDF;
            MRF24J40MA_WriteShortRegister(TXMCR, tempVal);

            //Configure BO (ORDER 0x10<7:4>) value = 0xF
            //Configure SO (ORDER 0x10<3:0>) value = 0xF
            MRF24J40MA_WriteShortRegister(ORDER, 0xFF);
            break;
            
        case NONBEACON_COORD:
            //Set the COORD (RXMCR 0x00<2>) bit = 1 to configure as the coordinator
            tempVal = MRF24J40MA_ReadShortRegister(RXMCR);
            tempVal |= 0x04;
            MRF24J40MA_WriteShortRegister(RXMCR, tempVal);

            //Clear the SLOTTED (TXMCR 0x11<5>) bit = 0 to configure Unslotted CSMA-CA mode
            tempVal = MRF24J40MA_ReadShortRegister(TXMCR);
            tempVal &= 0xDF;
            MRF24J40MA_WriteShortRegister(TXMCR, tempVal);

            //Configure BO (ORDER 0x10<7:4>) value = 0xF
            //Configure SO (ORDER 0x10<3:0>) value = 0xF
            MRF24J40MA_WriteShortRegister(ORDER, 0xFF);
            
            break;
            
        case NONBEACON_DEV:
            //Clear the PANCOORD (RXMCR 0x00<3>) bit = 0 to configure as device
            tempVal = MRF24J40MA_ReadShortRegister(RXMCR);
            tempVal &= 0xF3;
            MRF24J40MA_WriteShortRegister(RXMCR, tempVal);
            
            //Clear the SLOTTED (TXMCR 0x11<5>) bit = 0 to use Unslotted CSMA-CA mode
            tempVal = MRF24J40MA_ReadShortRegister(TXMCR);
            tempVal &= 0xDF;
            MRF24J40MA_WriteShortRegister(TXMCR, tempVal);
            break;
    }
}

/**
 * @brief Enables/Disables ACK request
 * @return None
 * @param [in] Boolean to Enable/Disable ACK request
 *             True: ACK requested; False: ACK not requested
 */
void MRF24J40MA_ControlAckRequest(bool state)
{
    uint8_t tempVal;
    
    //Write TXNACKREQ with state
    tempVal = MRF24J40MA_ReadShortRegister(TXNCON);    
    (state)?(tempVal |= 0x04):(tempVal &= (~0x04));    
    MRF24J40MA_WriteShortRegister(TXNCON, tempVal);
}

/**
 * @brief Enables/Disables Security
 * @return None
 * @param [in] Boolean to Enable/Disable security bit
 *             1: Security enabled; 0: Security disabled
 */
void MRF24J40MA_ControlSecurity(bool state)
{
    uint8_t tempVal;
    
    //Write TXNSECEN with state
    tempVal = MRF24J40MA_ReadShortRegister(TXNCON);    
    (state)?(tempVal |= 0x02):(tempVal &= (~0x02));    
    MRF24J40MA_WriteShortRegister(TXNCON, tempVal);
}

/**
 * @brief Reads data from a short register
 *        Short register address range is 0x00 - 0x3F
 *        Refer FIGURE 2-7 from MRF24J40MA datasheet for more details
 * @return Contents of requested short register
 * @param [in] Address of short register
 */
uint8_t MRF24J40MA_ReadShortRegister(uint8_t address)
{    
    uint8_t data, dummyData = 0; 
    
    MRF24J40MA_nCS_set_level(false);
    
    address = (uint8_t)((address << 1) & 0x7E);
    ${SPIFunctions["exchangeByte"]}(address);
    data = ${SPIFunctions["exchangeByte"]}(dummyData);    
    
    MRF24J40MA_nCS_set_level(true);
    
    return data;
}

/**
 * @brief Writes data to a short register
 *        Short register address range is 0x00 - 0x3F
 *        Refer FIGURE 2-8 from MRF24J40MA datasheet for more details
 * @return None.
 * @param [in] Address of short register
 */
void MRF24J40MA_WriteShortRegister(uint8_t address, uint8_t data)
{
    //Write data to given short register 0x00-0x3F
    MRF24J40MA_nCS_set_level(false);
    
    address = (uint8_t)(((address << 1) & 0x7F) | 0x01);
    ${SPIFunctions["exchangeByte"]}(address);
    ${SPIFunctions["exchangeByte"]}(data);
    
    MRF24J40MA_nCS_set_level(true);
}

/**
 * @brief Reads data from a long register
 *        Long register address range is 0x200 - 0x24C
 *        Refer FIGURE 2-9 from MRF24J40MA datasheet for more details
 * @return Contents of requested long register
 * @param [in] Address of long register
 */
uint8_t MRF24J40MA_ReadLongRegister(uint16_t address)
{
    uint8_t address_h, address_l;
    uint8_t data, dummyData = 0;
    
    MRF24J40MA_nCS_set_level(false);
    
    address_h = (uint8_t)(((uint8_t)(address >> 3) & 0x7F) | 0x80);    //Add 1 to MSB to indicate a long address
    address_l = (uint8_t)(((uint8_t)(address << 5) & 0xE0));
    ${SPIFunctions["exchangeByte"]}(address_h);
    ${SPIFunctions["exchangeByte"]}(address_l);
    data = ${SPIFunctions["exchangeByte"]}(dummyData);
    
    MRF24J40MA_nCS_set_level(true);
    
    return data;
}

/**
 * @brief Writes data to a long register
 *        Long register address range is 0x200 - 0x24C
 *        Refer FIGURE 2-10 from MRF24J40MA datasheet for more details
 * @return None.
 * @param [in] Address of long register
 */
void MRF24J40MA_WriteLongRegister(uint16_t address, uint8_t data)
{
    uint8_t address_h, address_l;
    
    MRF24J40MA_nCS_set_level(false);
    
    address_h = (uint8_t)(((uint8_t)(address >> 3) & 0x7F) | 0x80);    //Add 1 to MSB to indicate a long address
    address_l = (uint8_t)(((uint8_t)(address << 5) & 0xE0) | 0x10);
    ${SPIFunctions["exchangeByte"]}(address_h);
    ${SPIFunctions["exchangeByte"]}(address_l);
    ${SPIFunctions["exchangeByte"]}(data);
    
    MRF24J40MA_nCS_set_level(true);
}