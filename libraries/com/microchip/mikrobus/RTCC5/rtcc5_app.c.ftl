/*
<#include "MicrochipDisclaimer.ftl">
*/

#include <stdint.h>
#include <string.h>
#include "rtcc5_app.h"
#include "mcc.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"

/***************** MCP79512 Instruction Set Summary *********************/


#define EEREAD  0x03  //Read data from EE memory array beginning at selected address
#define EEWRITE 0x02  //Write data to EE memory array beginning at selected address
#define EEWRDI  0x04 //Reset the write enable latch (disable write operations)
#define EEWREN  0x06 //Set the write enable latch (enable write operations)
#define SRREAD  0x05 //Read STATUS register
#define SRWRITE 0x01 //Write STATUS register
#define RTCC_READ    0x13 //Read RTCC/SRAM array beginning at selected address
#define RTCC_WRITE   0x12 //Write RTCC/SRAM data to memory array beginning at selected address
#define UNLOCK  0x14 //Unlock ID Locations
#define IDWRITE 0x32 //Write to the ID Locations
#define IDREAD  0x33 //Read the ID Locations
#define CLRRAM 0x54 //Clear RAM Location to ‘0’


/*********************** RTCC Register Addresses ***************************/

#define RTCC_HUNDRETHS_OF_SECONDS   0x00  //millisecond
#define RTCC_SECONDS                0x01
#define RTCC_MINUTES                0x02
#define RTCC_HOUR                   0x03
#define RTCC_DAY                    0x04
#define RTCC_DATE                   0x10
#define RTCC_MONTH                  0x06
#define RTCC_YEAR                   0x07

#define CONTROL_REG                 0x08
#define CALIBRATION                 0x09

#define ALARM0_SECONDS              0x0C
#define ALARM0_MINUTES              0x0D
#define ALARM0_HOUR                 0x0E
#define ALARM0_DAY                  0x0F
#define ALARM0_DATE                 0x10
#define ALARM0_MONTH                0x11

#define ALARM1_HUNDRETHS_OF_SECONDS 0x12
#define ALARM1_SECONDS              0x13
#define ALARM1_MINUTES              0x14
#define ALARM1_HOUR                 0x15
#define ALARM1_DAY                  0x16
#define ALARM1_DATE                 0x17

#define PWR_DOWN_MINUTES            0x18
#define PWR_DOWN_HOUR               0x19
#define PWR_DOWN_DATE               0x1A
#define PWR_DOWN_MONTH              0x1B

#define PWR_UP_MINUTES              0x1C
#define PWR_UP_HOUR                 0x1D
#define PWR_UP_DATE                 0x1E
#define PWR_UP_MONTH                0x1F

#define MAC_ADDR_48                 0x02
#define MAC_ADDR_64                 0x00


/******************************************************************************/

#define  SQWE                       0x40            //  Square Wave Enable BIT
#define  ALM_NO                     0x00            //  no alarm activated    
#define  MFP_01H                    0x00            //  MFP = SQWAV(01 HERZ)      
#define  OSCON                      0x20            //  state of the oscillator(running or not)
#define  VBATEN                     0x08            //  enable battery for back-up
#define  VBAT_CLR                   0xEF            //  Mask to clear VBAT flag BIT
#define  EXTOSC                     0x08            //  enable external 32khz signal
#define  ST_SET                     0x80            //  start oscillator

#define EEPR_PAGE_SIZE               8

/******************************************************************************/

static void rtcc_write(uint8_t addr, uint8_t data);
static uint8_t rtcc_read(uint8_t addr);
static void rtcc5_EEPRWriteLatchEnable(void);
static void rtcc5_EEPRWriteLatchDisable(void);
static uint8_t rtcc5_EEPRReadStatusRegister(void);

/******************************************************************************/

typedef struct
{
int sec,min,hr;
int year,month,date,day;
}DateTime_t;

DateTime_t dateTime;


void rtcc5_Initialize(void){
  uint8_t reg = 0;
  ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
  
  dateTime.day = (rtcc_read(RTCC_DAY) & 0x07);
  rtcc_write(RTCC_DAY, (dateTime.day | 0x08));
  dateTime.sec = rtcc_read(RTCC_SECONDS);
    
  //Configure Control Register - SQWE=1, ALM0 = 00 {No Alarms Activated},
  //                             RS2, RS1, RS0 = 000 {1 HZ}
  rtcc_write(CONTROL_REG, ALM_NO + SQWE + MFP_01H); 
  
  // Start the external crystal and check OSCON to know when it is running
  rtcc_write(RTCC_SECONDS, dateTime.sec | ST_SET);
  while(!reg)
  {
    reg = rtcc_read(RTCC_DAY);
    reg &= OSCON;
  }
    
   // Configure external battery enable BIT and clear the VBAT flag
    rtcc_write(RTCC_DAY, dateTime.day | (VBATEN & VBAT_CLR)); 
  
}

static uint8_t rtcc_read(uint8_t addr)
{
    uint8_t ret;
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(RTCC_READ);     //RTCC Read Instruction
    ${SPIFunctions["exchangeByte"]}(addr);          //Write RTCC address to read data from
    ret = ${SPIFunctions["exchangeByte"]}(0);
     
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;
    ${SPIFunctions["spiClose"]}();
  
    return ret;    
}

static void rtcc_write(uint8_t addr, uint8_t data)
{    
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(RTCC_WRITE);     //RTCC Write Instruction
    ${SPIFunctions["exchangeByte"]}(addr);          //Write RTCC address to write data to
    ${SPIFunctions["exchangeByte"]}(data);          //Write data
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;  
    ${SPIFunctions["spiClose"]}();
}

static void rtcc5_SetComponent(uint8_t location, uint8_t mask, uint8_t time){
    uint8_t inMemory = rtcc_read(location) & mask;
    rtcc_write(location, inMemory | (time % 10) | ((time / 10) << 4)); 
}

void rtcc5_SetTime(time_t t)
{
   
    struct tm *tm_t;
    memset(tm_t, 0, sizeof (tm_t));

    tm_t = localtime(&t);
    rtcc5_SetComponent(RTCC_YEAR, 0x00, tm_t->tm_year % 100); // RTC only has two digits for year
    rtcc5_SetComponent(RTCC_MONTH, 0xD0, tm_t->tm_mon + 1); // time.h gives January as zero, clock expects 1
    rtcc5_SetComponent(RTCC_DATE, 0x00, tm_t->tm_mday);
    rtcc5_SetComponent(RTCC_MINUTES, 0x00, tm_t->tm_min);
    rtcc5_SetComponent(RTCC_SECONDS, 0x80, tm_t->tm_sec);
    rtcc5_SetComponent(RTCC_HOUR, 0x00, tm_t->tm_hour);   
   
}

static uint8_t rtcc5_GetComponent(uint8_t location, uint8_t mask){
    uint8_t working = rtcc_read(location) & mask;
    return (working & 0x0F) + (((working & (mask & 0xF0)) >> 4) * 10);
}

time_t rtcc5_GetTime(void)
{
   struct tm tm_t;
   memset(&tm_t, 0, sizeof (tm_t));
    
   tm_t.tm_year = rtcc5_GetComponent(RTCC_YEAR, 0xFF) + 100; // Result only has two digits, this assumes 20xx
   tm_t.tm_mon = rtcc5_GetComponent(RTCC_MONTH, 0x1F) - 1; // time.h expects January as zero, clock gives 1
   tm_t.tm_mday = rtcc5_GetComponent(RTCC_DATE, 0x3F);
   tm_t.tm_hour = rtcc5_GetComponent(RTCC_HOUR, 0x3F);
   tm_t.tm_min = rtcc5_GetComponent(RTCC_MINUTES, 0x7F);
   tm_t.tm_sec = rtcc5_GetComponent(RTCC_SECONDS, 0x7F);

   return mktime(&tm_t);
}

/******************************************************************************/

static void rtcc5_EEPRWriteLatchEnable(void)
{
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(EEWREN);        //Write Enable Instruction
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;                //CS High
}

static void rtcc5_EEPRWriteLatchDisable(void)
{
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(EEWRDI);        //Write Disable Instruction
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;                //CS High
}

static uint8_t rtcc5_EEPRReadStatusRegister(void)
{
    uint8_t ret;
    
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(SRREAD);                // Read Status Register
    ret = ${SPIFunctions["exchangeByte"]}(0);
   ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;               //CS High
    
    return ret;
}

uint8_t rtcc5_ReadByteEEPROM(uint8_t addr)
{
    uint8_t ret;
    uint8_t stat_reg; 
    
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
     
    rtcc5_EEPRWriteLatchDisable();      //Disable write latch
    
     do
    {
        stat_reg = rtcc5_EEPRReadStatusRegister();  //Read Status Register
    }while(((stat_reg & 0x03) != 0x00));
    
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(EEREAD);        //RTCC Read Instruction
    ${SPIFunctions["exchangeByte"]}(addr);          //Write RTCC address to read data from
    ret = ${SPIFunctions["exchangeByte"]}(0);         //Read Data
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;                //CS High
    
    ${SPIFunctions["spiClose"]}();
    
    return ret;    
}

void rtcc5_ReadBlockEEPROM(uint8_t addr, void *data, uint8_t len)
{  
    uint8_t stat_reg; 
    register char *p = (char *) data;
    
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
   
    rtcc5_EEPRWriteLatchDisable();      //Disable write latch   
    
     do
    {
        stat_reg = rtcc5_EEPRReadStatusRegister();  //Read Status Register
    }while(((stat_reg & 0x03) != 0x00));
    
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(EEREAD);        //RTCC Read Instruction
    ${SPIFunctions["exchangeByte"]}(addr);          //Write RTCC address to read data from
    while(len--)
    {
        *p++ = ${SPIFunctions["exchangeByte"]}(0);         //Read Data
        addr++;
        if(addr%EEPR_PAGE_SIZE)
        {
            ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;                //CS High
            rtcc5_EEPRWriteLatchDisable();      //Disable write latch
            ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
            ${SPIFunctions["exchangeByte"]}(EEREAD);        //RTCC Read Instruction
            ${SPIFunctions["exchangeByte"]}(addr);          //Write RTCC address to read data from
        }
    }  
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;                //CS High    
    
    ${SPIFunctions["spiClose"]}();
}

void rtcc5_WriteByteEEPROM(uint8_t addr, uint8_t data)
{ 
    uint8_t stat_reg; 
    
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    
    do{
        stat_reg = rtcc5_EEPRReadStatusRegister();  //Read Status Register to check for bus not busy
    }while((stat_reg & 0x01) != 0x00); 

    rtcc5_EEPRWriteLatchEnable();      //Enable write latch
    
    do{
        stat_reg = rtcc5_EEPRReadStatusRegister();  //Read Status Register
    }while((stat_reg & 0x03) != 0x02);
    
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;
    ${SPIFunctions["exchangeByte"]}(EEWRITE);        //RTCC Write Instruction
    ${SPIFunctions["exchangeByte"]}(addr);           //Write RTCC address to write data to
    ${SPIFunctions["exchangeByte"]}(data);           //Write data
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;                 //CS High
    
   rtcc5_EEPRWriteLatchDisable();      //Disable write latch
   
   ${SPIFunctions["spiClose"]}();
}

void rtcc5_WriteBlockEEPROM(uint8_t addr, void *data, uint8_t len)
{ 
    uint8_t stat_reg; 
    register char *p = (char *) data;
    
    while(!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    
     do{
        stat_reg = rtcc5_EEPRReadStatusRegister();  //Read Status Register to check for bus not busy
    }while((stat_reg &0x01) != 0x00); 
    
    rtcc5_EEPRWriteLatchEnable();      //Enable write latch
    
    do{
        stat_reg = rtcc5_EEPRReadStatusRegister();  //Read Status Register
    }while((stat_reg & 0x03) != 0x02);    
   
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
    ${SPIFunctions["exchangeByte"]}(EEWRITE);     //RTCC Write Instruction
    ${SPIFunctions["exchangeByte"]}(addr);          //Write RTCC address to read data from
    while(len--)
    {
        ${SPIFunctions["exchangeByte"]}(*p++);        
        addr++;
        if(addr%EEPR_PAGE_SIZE==0)
        {
            ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;              
            
            rtcc5_EEPRWriteLatchEnable();      //Enable write latch
            ${spiSSPinSettings["spiSlaveSelectLat"]} = 0;               //CS low
            ${SPIFunctions["exchangeByte"]}(EEWRITE);     //RTCC Read Instruction
            ${SPIFunctions["exchangeByte"]}(addr);          //Write RTCC address to read data from      
        }       
    }
    ${spiSSPinSettings["spiSlaveSelectLat"]} = 1;    
    rtcc5_EEPRWriteLatchDisable();      //Disable write latch    
    
    ${SPIFunctions["spiClose"]}();
}
