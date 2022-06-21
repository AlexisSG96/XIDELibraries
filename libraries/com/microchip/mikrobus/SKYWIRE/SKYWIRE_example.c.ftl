/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "SKYWIRE_example.h"
#include "SKYWIRE_driver.h"

 /**
 * @brief  This is an example function for Sending SMS using Nimbelink/Skywire module.
 * @param  None
 * @return None
 */
void SKYWIRE_Example(void)
{
    SKYWIRE_SendSms("+14803712345","Hello from Skywire!\r\n");
}