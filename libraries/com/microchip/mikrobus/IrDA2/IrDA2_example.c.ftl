/*
<#include "MicrochipDisclaimer.ftl">
*/

#include "IrDA2_example.h"
#include "IrDA2_driver.h"

 /**
 * @brief  This is an example function for Send and Receive data using IrDA2 module.
 * @param  None
 * @return None
 */
void IrDA2_Example(void)
{
    uint8_t rxIrDA2;
    IrDA2_SendData(0xAB);
    rxIrDA2 = IrDA2_ReceiveData();
    if(rxIrDA2 == 0xCD)
    {
        // Add your application code
        // Toggle LED
    }
}