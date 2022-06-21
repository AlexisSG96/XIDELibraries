 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#include "LED7X10R.h"
#include "${SPIFunctions["spiHeader"]}"
#ifdef __XC
#include <xc.h>
#endif

#define LED7X10R LED7X10R

void LED7X10R_Write(const uint8_t *buff ){

  ${SPIFunctions["spiOpen"]}(LED7X10R);

  uint8_t *ptr = buff;
   
  ${RRLat} = 1;
  ${RRLat} = 0;
 
  for(int i = 0; i < 7; i++ )
   {
    ${SPIFunctions["exchangeByte"]}(*( ptr++ ));
    ${SPIFunctions["exchangeByte"]}(*( ptr++ ));
    ${LTLat} = 0;
    ${LTLat} = 1;

    ${RCLat} = 1;
    ${RCLat} = 0; 
   }
   ${SPIFunctions["spiClose"]}();
}