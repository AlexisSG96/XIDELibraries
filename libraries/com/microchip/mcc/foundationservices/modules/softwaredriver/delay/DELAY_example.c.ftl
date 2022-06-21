/**
\file
\addtogroup doc_driver_delay_example
\brief This file contains sample source codes to demonstrate the Delay Driver by using it to toggle GPIO pins.

For this example application to work the following needs to be done:
1. In MCC Pin Manager Grid View, select a GPIO pin (preferably linked to an LED) to be configured as output. This can be done by clicking the lock square in the same column as the pin number and same row as the label "GPIO Output." The lock square should turn green once selected.
2. In MCC Project Resources, go to Pin Module. Rename the selected pin as PIN0. Configure it as digital output by unchecking the box under "Analog" and checking the box under "Output." 
3. Click the "Generate" button.
4. Include the pin_manager.h file in the DELAY_example.c 
5. Include the DELAY_example.h in main.c file.
6. Call the function DELAY_MsExample() or DELAY_UsExample() inside the while(1) loop to toggle PIN_0 for 500 ms or 50 ms (50000 us) respectively.

Note: 50 ms may be too fast for the naked eye to see, thus it may look like it is not toggling from its initial state. Use an oscillator or logic analyzer to view the changing states.

\copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
\page License
<#include "MicrochipDisclaimer.ftl">
**/

#include "DELAY_example.h"


/**
*  \ingroup doc_driver_delay_example
*  Call this function from main toggle PIN0 every 500 milliseconds
@param none
*/
void DELAY_MsExample(void)
{   
    ${delayInterface["delayMs"]}(500);

    PIN0_Toggle();
}

/**
*  \ingroup doc_driver_delay_example
*  Call this function from main toggle PIN0 every 50000 microseconds
@param none
*/
void DELAY_UsExample(void)
{
    ${delayInterface["delayUs"]}(50000);

    PIN0_Toggle();
}

/**
 End of File
 */
