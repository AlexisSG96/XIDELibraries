/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "Ozone.h"
#include "${SPIFunctions["spiHeader"]}"
#include "${SPIFunctions["spiTypesHeader"]}"
#ifdef __XC
#include <xc.h>
#endif 
#include <math.h>
    
void MIKROE_CLICK_OZONE_CS_SET_HIGH()
{
    do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 1; } while(0);
}

void MIKROE_CLICK_OZONE_CS_SET_LOW()
{   
    do { ${spiSSPinSettings["spiSlaveSelectLat"]} = 0; } while(0);
}
    
float Ozone_Read(void)
{
    uint8_t adcReadByte[2];
    uint16_t adcRead;
    
    double Vout, Rs, ratio;
    
    //Reference voltage = 5V
    const double Vref = 5.0;
    
    //Sensing resistance in air (3k-60k ohms, typical 11k)
    //Note: Each sensors R100ppm value will need to be calibrated individually
    const double R100ppm = 11000.0;
    
    float ozone;
    
    while (!${SPIFunctions["spiOpen"]}(${spi_configuration}));
    MIKROE_CLICK_OZONE_CS_SET_LOW();
    adcReadByte[0] = ${SPIFunctions["exchangeByte"]}(0xFF);
    adcReadByte[1] = ${SPIFunctions["exchangeByte"]}(0xFF);
    MIKROE_CLICK_OZONE_CS_SET_HIGH();
    ${SPIFunctions["spiClose"]}();
    
    //MCP3201 has 12 bit data reading, mask out top 3 bits
    //First byte holds B11:B7
    adcRead = ( adcReadByte[0] & 0x1F );
    adcRead <<= 7;
    //Remove LSB, see Figure 6-1 in MCP3201 datasheet
    //Second byte holds B6:B0
    adcRead |= ( adcReadByte[1] >> 1 );
    
    //Voltage = (ADCRead/ADCResolution) * Vref
    Vout = (double)adcRead / 4096.0;
    Vout *= Vref;
    
    //10000 = R2 on Click board, known as RLOAD in datasheet
    //Rs (internal resistance) and R2 are connected as a voltage divider
    Rs = ((Vref*10000)/Vout) - 10000;
    
    //Following equation estimated from Rs/R100ppb VS 03 graph in MiCS-2614 datasheet
    /* Data points used:
     * Rs/R100ppb   O3 ppb
     * 0.063        10
     * 0.37         40
     * 0.5          50
     * 0.6          60
     * 0.7          70
     * 0.83         80
     * 0.94         90
     * 1.1          100
     * 2            200
     * 2.8          300
     * 4.2          500
     * 4.6          600
     * 6            800
     */
    //Note: Each sensors function may need to be calibrated individually
    ratio = Rs/R100ppm;
    ozone = 6.395488 + 81.005655*ratio + 8.640001*pow(ratio,2.0);
    return ozone; //Ozone is in ppb
}

void Ozone_Initialize(void)
{
    MIKROE_CLICK_OZONE_CS_SET_HIGH();
}