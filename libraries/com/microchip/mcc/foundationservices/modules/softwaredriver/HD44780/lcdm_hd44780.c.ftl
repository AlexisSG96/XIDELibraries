/*
<#include "MicrochipDisclaimer.ftl">
*/

/**
  Section: Included Files
 */

#include "lcdm_hd44780.h"
#include "../${simpleheader}"

/**
  Section: Macro Declarations
 */

#define HD44780_CLEAR    0x01
#define HD44780_HOME     0x02    

//LCD FUNCTION CONTROL
#define HD44780_FUNCTION 0x20   
//Control Function for LCD
#define FUNCTION_4BITS  0x00    
#define FUNCTION_8BITS  0x10
//Control of HD44780 Line
#define FUNCTION_1_LINE 0x00    
#define FUNCTION_2_LINE 0x08
//Control of HD44780 Functions
#define FUNCTION_1_HIGH 0x00    
#define FUNCTION_2_HIGH 0x04

//Instruction Page (IS)
//Control of HD44780 functions (1st)
#define FUNCTION_nIS    0x00  
//Control of HD44780 functions (2nd)  
#define FUNCTION_IS     0x01    

//LCD ADDRESSES
#define HD44780_CGRAM_ADDRESS(adr)   (0x40 | (adr & 0x3F))  
#define HD44780_DDRAM_ADDRESS(adr)   (0x80 | (adr & 0x7F))  
#define HD44780_ICON_ADDRESS(adr)    (0x40 | (adr & 0x0F)) 
#define HD44780_ADDRESS_MASK         0x7F                    

//READ BUSY - LCD Busy Flag Mask
#define HD44780_BUSY_FLAG_MASK 0x80

//BIAS - HD44780 Bias control
#define BIAS_1_5    0x00
#define BIAS_1_4    0x08

//HD44780 Frequency Control
#define FREQ_CNTRL(f)       (f&0x07)  
//Operating Frequency  
#define HD44780_OSC_FREQ     0x10        

//LCD POWER/ICON/CONTRAST
#define HD44780_CONTRAST(c)  (0x70 | (c & 0x0F))  
#define HD44780_PWR_CONTROL  0x50                 
#define nICON               0x00                 
#define ICON                0x08                   
#define nBOOST              0x00                   
#define BOOST               0x04                  
#define CONTRAST(c)         (c&0x03)                

//FOLLOWER
#define FOLLOWER_GAIN(g)        (g&0x07)    
#define HD44780_FOLLOWER_OFF     0x60      
#define HD44780_FOLLOWER_ON      0x68        

#define HD44780_ENTRY_MODE 0x04

//SHIFT CURSOR
#define CURSOR_nSHIFT   0x00  
#define CURSOR_SHIFT    0x01    

//DATA
#define DATA_DECREMENT  0x00  
#define DATA_INCREMENT  0x02   

//LCD DISPLAY
#define HD44780_DISPLAY_OFF  0x08  
#define HD44780_DISPLAY_ON   0x0C    

//CURSOR
#define CURSOR_OFF  0x00    
#define CURSOR_ON   0x02    
#define BLINK_OFF   0x00    
#define BLINK_ON    0x01   

//COMMANDS
#define HD44780_ADDRESS_LINE_1 0x00      
#define HD44780_ADDRESS_LINE_2 0x40      
#define HD44780_SLAVE          0x7C>>1   
#define HD44780_COMSEND        0x00      
#define HD44780_DATASEND       0x40     

/**
  Section: Variable Definitions
 */

static const int8_t line_address[] = {HD44780_ADDRESS_LINE_1, HD44780_ADDRESS_LINE_2};

///**
//  Section: Private function prototypes
// */
//
//void HD44780_putchar(const int8_t c);
//void HD44780_putcmd(uint8_t Command);

/**
  Section: Driver APIs
 */

void HD44780_Init(void) {
    uint8_t I2CM_dataBuffer[10];
    // Send init commands
    I2CM_dataBuffer[0] = HD44780_COMSEND;
    I2CM_dataBuffer[1] = HD44780_FUNCTION | FUNCTION_8BITS | FUNCTION_1_HIGH | FUNCTION_1_LINE | FUNCTION_nIS;
    I2CM_dataBuffer[2] = HD44780_FUNCTION | FUNCTION_8BITS | FUNCTION_1_HIGH | FUNCTION_2_LINE | FUNCTION_IS;
    I2CM_dataBuffer[3] = HD44780_OSC_FREQ | BIAS_1_5 | FREQ_CNTRL(4);
    I2CM_dataBuffer[4] = HD44780_CONTRAST(10);
    I2CM_dataBuffer[5] = HD44780_PWR_CONTROL | nICON | BOOST | CONTRAST(2);
    I2CM_dataBuffer[6] = HD44780_FOLLOWER_ON | FOLLOWER_GAIN(4);
    I2CM_dataBuffer[7] = HD44780_ENTRY_MODE | CURSOR_nSHIFT | DATA_INCREMENT;
    I2CM_dataBuffer[8] = HD44780_DISPLAY_ON | CURSOR_OFF | BLINK_OFF;
    ${writeNBytes}(HD44780_SLAVE, I2CM_dataBuffer, 9);
}

void HD44780_goto(const uint8_t x, const uint8_t y) {
    HD44780_putcmd(HD44780_DDRAM_ADDRESS(line_address[y] + x));
}

void HD44780_putchar(const int8_t c) {
    ${write1ByteRegister}(HD44780_SLAVE, HD44780_DATASEND, c);
}

void HD44780_putstr(char *s, uint8_t length) {
    // Build string in buffer till no more characters are left
    while (length-- > 0) // Write data to LCD up to null
    {
        HD44780_putchar(*s++);
    }
}

void HD44780_putcmd(uint8_t Command) {
    ${write1ByteRegister}(HD44780_SLAVE, HD44780_COMSEND, Command);
}

/**
 End of File
 */ 
