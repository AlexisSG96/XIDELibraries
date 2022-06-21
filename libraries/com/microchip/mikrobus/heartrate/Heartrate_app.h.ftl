/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef _HEARTRATE_H
#define	_HEARTRATE_H

/**
  Section: Included Files
 */

#include <stdint.h>
#include "max30100.h"

/**
  Section: Macro Declarations
 */

#define DEFAULT_MODE            MAX30100_${modeSelect}
#define DEFAULT_HIRES_SET       ${hiresSelect}
#define DEFAULT_SAMP_RATE       MAX30100_${srSelect}
#define DEFAULT_PWIDTH          MAX30100_${pwSelect}
#define DEFAULT_IR_CURRENT      MAX30100_${irSelect}
#define DEFAULT_RED_CURRENT     MAX30100_${redSelect}
#define SPO2_INTERRUPT_EN       ${spo2Enabled}   
#define HR_INTERRUPT_EN         ${hrEnabled}
#define TEMP_INTERRUPT_EN       ${tempEnabled} 
#define FIFO_INTERRUPT_EN       ${fifoEnabled}


/**
  Section: Driver APIs
 */

void HeartRate_readSensors(void);
uint16_t HeartRate_getIRdata(void);
uint16_t HeartRate_getREDdata(void);
float HeartRate_getTemperature(void);

#endif // _HEARTRATE_H
