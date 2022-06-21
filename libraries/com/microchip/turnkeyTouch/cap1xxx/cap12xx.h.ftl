/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef CAP12xx_H
#define CAP12xx_H

#ifdef __cplusplus
extern "C"
{
#endif

/*
 * Register Definitions For CAP12xx
 */

#define CAP_PRODUCT_ID_ADDRESS  0xfd 
#define CAP_VENDOR_ID_ADDRESS   0xfe  
#define CAP_REVISION_ADDRESS    0xff  

#define PRODUCT_ID_CAP12xx      ${deviceID} 

#define CAP_MAX_SENSOR_NUM      ${numberOfSensor}  

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Register: CAP_MAIN_CONTROL               @       00h
#define CAP_MAIN_CONTROL_ADDRESS 0x00

    typedef union {

        struct
        {
            unsigned INT : 1;
            unsigned COMBO : 1;
            unsigned C_GAIN : 2;
            unsigned DSLEEP : 1;
            unsigned STBY : 1;
            unsigned GAIN : 2;
        };

        unsigned value : 8;
    } CAP_MAIN_CONTROLbits_t;

    // bit field macros
#define GAIN_1 0x0
#define GAIN_2 0x1
#define GAIN_4 0x2
#define GAIN_8 0x3

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Register: General Status     @ 02h
#define CAP_GENERAL_STATUS_ADDRESS 0x02

    typedef union {

        struct
        {
            unsigned TOUCH : 1;
            unsigned MTP : 1;
            unsigned MULT : 1;
            unsigned RESET : 1;
            unsigned PWR : 1;
            unsigned ACAL_FAIL : 1;
            unsigned BC_OUT : 1;
            unsigned : 1;
        };
        unsigned value : 8;

    } CAP_GENERAL_STATUSbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: Sensor Input Status        @03h
#define CAP_SENSOR_INPUT_STATUS_ADDRESS 0x03

    typedef union {

        struct
        {
            unsigned CS1 : 1;
            unsigned CS2 : 1;
            unsigned CS3 : 1;
            unsigned CS4 : 1;
            unsigned CS5 : 1;
            unsigned CS6 : 1;
            unsigned CS7 : 1;
            unsigned CS8 : 1;
        };
        unsigned value : 8;

    } CAP_SENSOR_INPUT_STATUSbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: NOISE FLAG STATUS REGISTERS    @   0Ah
    // Read Only
#define CAP_NOISE_FLAG_STATUS_ADDRESS 0x0a

    typedef union {

        struct
        {
            unsigned CS1_NOISE : 1;
            unsigned CS2_NOISE : 1;
            unsigned CS3_NOISE : 1;
            unsigned CS4_NOISE : 1;
            unsigned CS5_NOISE : 1;
            unsigned CS6_NOISE : 1;
            unsigned CS7_NOISE : 1;
            unsigned CS8_NOISE : 1;
        };
        unsigned value : 8;
    } CAP_NOISE_FLAG_STATUSbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: SENSOR INPUT DELTA COUNT REGISTERS    @   10h ~ 17h
    // Read Only
#define CAP_SENSOR_INPUT_DELTA_COUNT_ADDRESS 0x10

    // Register: SENSITIVITY CONTROL REGISTER    @   1Fh
    // Read / Write

#define CAP_SENSITIVITY_CONTROL_ADDRESS 0x1f

    typedef union {

        struct
        {
            unsigned BASE_SHIFT : 4;
            unsigned DELTA_SENSE : 3;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_SENSITIVITY_CONTROLbits_t;

    // bit field macros
#define DELTA_SENSE_128X 0x0
#define DELTA_SENSE_64X 0x1
#define DELTA_SENSE_32X 0x2 //Default set
#define DELTA_SENSE_16X 0x3
#define DELTA_SENSE_8X 0x4
#define DELTA_SENSE_4X 0x5
#define DELTA_SENSE_2X 0x6
#define DELTA_SENSE_1X 0x7

#define BASE_SHIFT 0b1111 //Data Scaling Factor default 0b1111
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: CONFIGURATION REGISTERS    @   20h
    // Read / Write
#define CAP_CONFIGURATION_ADDRESS 0x20

    typedef union {

        struct
        {
            unsigned : 3;
            unsigned MAX_DUR_EN : 1;
            unsigned DIS_ANA_NOISE : 1;
            unsigned DIS_DIG_NOISE : 1;
            unsigned : 1;
            unsigned TIME_OUT : 1;
        };
        unsigned value : 8;
    } CAP_CONFIGURATIONbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: CONFIGURATION REGISTERS    @   44h
    // Read / Write
#define CAP_CONFIGURATION_2_ADDRESS 0x44

    typedef union {

        struct
        {
            unsigned INT_REL_n : 1;
            unsigned ACAL_FAIL_INT : 1;
            unsigned DIS_RF_NOISE : 1;
            unsigned SHOW_RF_NOISE : 1;
            unsigned BC_OUT_INT : 1;
            unsigned BLK_PWR_CTRL : 1;
            unsigned BC_OUT_RECAL : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_CONFIGURATION_2bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: SENSOR INPUT ENABLE REGISTER    @   21h
     R/W
        ? ?0?-ThespecifiedinputisnotincludedinthesensingcycleintheActivestate.
        ? ?1?(default)-ThespecifiedinputisincludedinthesensingcycleintheActivestate.
     */

#define CAP_SENSOR_INPUT_ENABLE_ADDRESS 0x21

    typedef union {

        struct
        {
            unsigned CS1_EN : 1;
            unsigned CS2_EN : 1;
            unsigned CS3_EN : 1;
            unsigned CS4_EN : 1;
            unsigned CS5_EN : 1;
            unsigned CS6_EN : 1;
            unsigned CS7_EN : 1;
            unsigned CS8_EN : 1;
        };
        unsigned value : 8;
    } CAP_SENSOR_INPUT_ENABLEbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: SENSOR INPUT CONFIGURATION REGISTER    @   22h
    R/W
     * 
     * 
     */
#define CAP_SENSOR_INPUT_CONFIGURATION_ADDRESS 0x22

    typedef union {

        struct
        {
            unsigned RPT_RATE : 4;
            unsigned MAX_DUR : 4;
        };
        unsigned value : 8;
    } CAP_SENSOR_INPUT_CONFIGURATIONbits_t;

    // bit field macros
#define MAX_DUR560ms 0x0
#define MAX_DUR840ms 0x1
#define MAX_DUR1120ms 0x2
#define MAX_DUR1400ms 0x3
#define MAX_DUR1680ms 0x4
#define MAX_DUR2240ms 0x5
#define MAX_DUR2800ms 0x6
#define MAX_DUR3360ms 0x7

#define MAX_DUR3920ms 0x8
#define MAX_DUR4480ms 0x9
#define MAX_DUR5600ms 0xa //Default set
#define MAX_DUR6720ms 0xb
#define MAX_DUR7840ms 0xc
#define MAX_DUR8906ms 0xd
#define MAX_DUR10080ms 0xe
#define MAX_DUR11200ms 0xf

#define RPT_RATE35ms 0x0
#define RPT_RATE70ms 0x1
#define RPT_RATE105ms 0x2
#define RPT_RATE140ms 0x3
#define RPT_RATE175ms 0x4 //Default set
#define RPT_RATE210ms 0x5
#define RPT_RATE245ms 0x6
#define RPT_RATE280ms 0x7

#define RPT_RATE315ms 0x8
#define RPT_RATE350ms 0x9
#define RPT_RATE385ms 0xa
#define RPT_RATE420ms 0xb
#define RPT_RATE455ms 0xc
#define RPT_RATE490ms 0xd
#define RPT_RATE525ms 0xe
#define RPT_RATE560ms 0xf
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: SENSOR INPUT CONFIGURATION REGISTER 2    @   23h
    R/W
     * 
     * 
     */
#define CAP_SENSOR_INPUT_CONFIGURATION_2_ADDRESS 0x23

    typedef union {

        struct
        {
            unsigned M_PRESS : 4;
            unsigned : 4;
        };
        unsigned value : 8;
    } CAP_SENSOR_INPUT_CONFIGURATION_2bits_t;

    // bit field macros
#define M_PRESS35ms 0x0
#define M_PRESS70ms 0x1
#define M_PRESS105ms 0x2
#define M_PRESS140ms 0x3
#define M_PRESS175ms 0x4
#define M_PRESS210ms 0x5
#define M_PRESS245ms 0x6
#define M_PRESS280ms 0x7 //Default set

#define M_PRESS315ms 0x8
#define M_PRESS350ms 0x9
#define M_PRESS385ms 0xa
#define M_PRESS420ms 0xb
#define M_PRESS455ms 0xc
#define M_PRESS490ms 0xd
#define M_PRESS525ms 0xe
#define M_PRESS560ms 0xf
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: AVERAGING AND SAMPLING CONFIGURATION REGISTER        @       24h
   R/W
     * 
     * 
     */
#define CAP_AVERAGING_AND_SAMPLING_CONFIGURATION_ADDRESS 0x24

    typedef union {

        struct
        {
            unsigned CYCLE_TIME : 2;
            unsigned SAMP_TIME : 2;
            unsigned AVG : 3;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_AVERAGING_AND_SAMPLING_CONFIGURATIONbits_t;

    // bit field macros
#define AVG1 0x0
#define AVG2 0x1
#define AVG4 0x2
#define AVG8 0x3 //Default set
#define AVG16 0x4
#define AVG32 0x5
#define AVG64 0x6
#define AVG128 0x7

#define SAMP_TIME320us 0x0
#define SAMP_TIME640us 0x1
#define SAMP_TIME1_28ms 0x2 //Default set
#define SAMP_TIME2_56ms 0x3

#define CYCLE_TIME35ms 0x0
#define CYCLE_TIME70ms 0x1 //Default set
#define CYCLE_TIME105ms 0x2
#define CYCLE_TIME140ms 0x3
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: CALIBRATION ACTIVATE AND STATUS REGISTER    @   26h
    R/W
  
     * For all bits in this register:
   ? ?0?-Noactionneeded.
   ? ?1?-Writinga?1?,forcesacalibrationonthecorrespondingsensorinput.IftheACAL_FAILflagissetandthisbitis set (see application note above), the sensor input could not complete analog calibration.
     */

#define CAP_CALIBRATION_ACTIVATE_AND_STATUS_ADDRESS 0x26

    typedef union {

        struct
        {
            unsigned CS1_CAL : 1;
            unsigned CS2_CAL : 1;
            unsigned CS3_CAL : 1;
            unsigned CS4_CAL : 1;
            unsigned CS5_CAL : 1;
            unsigned CS6_CAL : 1;
            unsigned CS7_CAL : 1;
            unsigned CS8_CAL : 1;
        };
        unsigned value : 8;
    } CAP_CALIBRATION_ACTIVATE_AND_STATUSbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: INTERRUPT ENABLE REGISTER    @   27h
    R/W
     */

#define CAP_INTERRUPT_ENABLE_ADDRESS 0x27

    typedef union {

        struct
        {
            unsigned CS1_INT_EN : 1;
            unsigned CS2_INT_EN : 1;
            unsigned CS3_INT_EN : 1;
            unsigned CS4_INT_EN : 1;
            unsigned CS5_INT_EN : 1;
            unsigned CS6_INT_EN : 1;
            unsigned CS7_INT_EN : 1;
            unsigned CS8_INT_EN : 1;
        };
        unsigned value : 8;
    } CAP_INTERRUPT_ENABLEbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register: REPEAT RATE ENABLE REGISTER    @   28h
    R/W
     */

#define CAP_REPEAT_RATE_ENABLE_ADDRESS 0x28

    typedef union {

        struct
        {
            unsigned CS1_RPT_EN : 1;
            unsigned CS2_RPT_EN : 1;
            unsigned CS3_RPT_EN : 1;
            unsigned CS4_RPT_EN : 1;
            unsigned CS5_RPT_EN : 1;
            unsigned CS6_RPT_EN : 1;
            unsigned CS7_RPT_EN : 1;
            unsigned CS8_RPT_EN : 1;
        };
        unsigned value : 8;
    } CAP_REPEAT_RATE_ENABLEbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: SIGNAL GUARD ENABLE REGISTER    @   29h
    R/W
     */

#define CAP_SIGNAL_GUARD_ENABLE_ADDRESS 0x29

    typedef union {

        struct
        {
            unsigned CS1_SG_EN : 1;
            unsigned CS2_SG_EN : 1;
            unsigned CS3_SG_EN : 1;
            unsigned CS4_SG_EN : 1;
            unsigned : 1; //SG
            unsigned CS6_SG_EN : 1;
            unsigned CS7_SG_EN : 1;
            unsigned CS8_SG_EN : 1;
        };
        unsigned value : 8;
    } CAP_SIGNAL_GUARD_ENABLEbits_t; //For CAP1298

    //
#define CAP_GUARD_MASK_BIT_CAP1298 0x4
#define CAP_GUARD_MASK_BIT_CAP1296 0x2
#define CAP_GUARD_MASK_BIT_CAP1293 0x1
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: MULTIPLE TOUCH CONFIGURATION    @   2ah
    R/W
     */

#define CAP_MULTIPLE_TOUCH_CONFIGURATION_ADDRESS 0x2a

    typedef union {

        struct
        {
            unsigned : 2;

            unsigned B_MULT_T : 2; // Bit field as below .

            unsigned : 3;
            unsigned MULT_BLK_EN : 1; // 1 default ( Enable ) ; 0 disable
        };
        unsigned value : 8;
    } CAP_MULTIPLE_TOUCH_CONFIGURATIONbits_t;

    // bit field macros
#define B_MULT_T_1 0x0
#define B_MULT_T_2 0x1
#define B_MULT_T_3 0x2
#define B_MULT_T_4 0x3
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: MULTIPLE TOUCH PATTERN CONFIGURATION   @   2bh
        R/W
     */

#define CAP_MULTIPLE_TOUCH_PATTERN_CONFIGURATION_ADDRESS 0x2b

    typedef union {

        struct
        {
            unsigned MTP_ALERT : 1;

            unsigned COMP_PTRN : 1;

            unsigned MTP_TH : 2; //Threshold Divide Setting ; Bit field as below .
            unsigned : 3;
            unsigned MTP_EN : 1;
        };
        unsigned value : 8;
    } CAP_MULTIPLE_TOUCH_PATTERN_CONFIGURATIONbits_t;

    // bit field macros
#define MTP_TH12_5 0x0
#define MTP_TH25 0x1
#define MTP_TH37_5 0x2
#define MTP_TH100 0x3
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: MULTIPLE TOUCH PATTERN REGISTER   @   2dh
    R/W
     */

#define CAP_MULTIPLE_TOUCH_PATTERN_ADDRESS 0x2d

    typedef union {

        struct
        {
            unsigned CS1_PTRN : 1;
            unsigned CS2_PTRN : 1;
            unsigned CS3_PTRN : 1;
            unsigned CS4_PTRN : 1;
            unsigned CS5_PTRN : 1;
            unsigned CS6_PTRN : 1;
            unsigned CS7_PTRN : 1;
            unsigned CS8_PTRN : 1;
        };
        unsigned value : 8;
    } CAP_MULTIPLE_TOUCH_PATTERNbits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: BASE COUNT OUT OF LIMIT REGISTER   @   2eh
     *  R only 
     */

#define CAP_BASE_COUNT_OUT_OF_LIMIT_ADDRESS 0x2e

    typedef union {

        struct
        {
            unsigned BC_OUT_1 : 1;
            unsigned BC_OUT_2 : 1;
            unsigned BC_OUT_3 : 1;
            unsigned BC_OUT_4 : 1;
            unsigned BC_OUT_5 : 1;
            unsigned BC_OUT_6 : 1;
            unsigned BC_OUT_7 : 1;
            unsigned BC_OUT_8 : 1;
        };
        unsigned value : 8;
    } CAP_BASE_COUNT_OUT_OF_LIMITbits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register:    RECALIBRATION CONFIGURATION REGISTERS @   2fh
     *  R/W  
     */

#define CAP_RECALIBRATION_CONFIGURATION_ADDRESS 0x2f

    typedef union {

        struct
        {
            unsigned CAL_CFG : 3;
            unsigned NEG_DELTA_CNT : 2;
            unsigned NO_CLR_NEG : 1;
            unsigned NO_CLR_INTD : 1;
            unsigned BUT_LD_TH : 1; // TH set for all CS or Individually
        };
        unsigned value : 8;
    } CAP_RECALIBRATION_CONFIGURATIONbits_t;

    // bit field macros
#define NEG_DELTA_CNT8 0x0
#define NEG_DELTA_CNT16 0x1 //Default set
#define NEG_DELTA_CNT32 0x2
#define NEG_DELTA_CNT8_DISABLE 0x3

#define CAL_CFG16 0x0
#define CAL_CFG32 0x1
#define CAL_CFG64 0x2 //Default set
#define CAL_CFG128 0x3
#define CAL_CFG256 0x4
#define CAL_CFG256_1024 0x5
#define CAL_CFG256_2048 0x6
#define CAL_CFG256_4096 0x7
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register:    SENSOR INPUT THRESHOLD REGISTERS @   30h~ 37h
     * R/W  
     */

#define CAP_SENSOR_INPUT_THRESHOLD01_ADDRESS 0x30

    typedef union {

        struct
        {
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_SENSOR_INPUT_THRESHOLD01bits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    SENSOR INPUT NOISE THRESHOLD REGISTER REGISTER  @   38h
     *  R only or R/W  
     */

#define CAP_SENSOR_INPUT_NOISE_THRESHOLD_ADDRESS 0x38

    typedef union {

        struct
        {
            unsigned CS_BN_TH : 2;
            unsigned : 6;
        };
        unsigned value : 8;
    } CAP_SENSOR_INPUT_NOISE_THRESHOLDbits_t;

    // bit field macros
#define CSX_BN_TH25 0x0
#define CSX_BN_TH37_5 0x1
#define CSX_BN_TH50 0x2
#define CSX_BN_TH62_5 0x3 //Default set
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    STANDBY CHANNEL REGISTER @   40h
     * R/W  
     */

#define CAP_STANDBY_CHANNEL_ADDRESS 0x40

    typedef union {

        struct
        {
            unsigned CS1_STBY : 1;
            unsigned CS2_STBY : 1;
            unsigned CS3_STBY : 1;
            unsigned CS4_STBY : 1;
            unsigned CS5_STBY : 1;
            unsigned CS6_STBY : 1;
            unsigned CS7_STBY : 1;
            unsigned CS8_STBY : 1;
        };
        unsigned value : 8;
    } CAP_STANDBY_CHANNELbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  STANDBY CONFIGURATION REGISTER  @   41h
     *  R only or R/W  
     */

#define CAP_STANDBY_CONFIGURATION_ADDRESS 0x41

    typedef union {

        struct
        {
            unsigned STBY_CY_TIME : 2;
            unsigned STBY_SAMP_TIME : 2;
            unsigned STBY_AVG : 3;
            unsigned AVG_SUM : 1;
        };
        unsigned value : 8;
    } CAP_STANDBY_CONFIGURATIONbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define STBY_AVG1 0x0
#define STBY_AVG2 0x1
#define STBY_AVG4 0x2
#define STBY_AVG8 0x3 //Default set
#define STBY_AVG16 0x4
#define STBY_AVG32 0x5
#define STBY_AVG64 0x6
#define STBY_AVG128 0x7

#define STBY_SAMP_TIME320us 0x0
#define STBY_SAMP_TIME640us 0x1
#define STBY_SAMP_TIME1280us 0x2 //Default set
#define STBY_SAMP_TIME2560us 0x3

#define STBY_CY_TIME35ms 0x0
#define STBY_CY_TIME70ms 0x1 //Default set
#define STBY_CY_TIME105ms 0x2
#define STBY_CY_TIME140ms 0x3
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  STANDBY SENSITIVITY REGISTER  @   42h
     * R/W  
     */

#define CAP_STANDBY_SENSITIVITY_ADDRESS 0x42

    typedef union {

        struct
        {
            unsigned STBY_SENSE : 3;
            unsigned : 5;
        };
        unsigned value : 8;
    } CAP_STANDBY_SENSITIVITYbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define STBY_SENSE128x 0x0
#define STBY_SENSE64x 0x1
#define STBY_SENSE32xDEFAULT 0x2 //Default set
#define STBY_SENSE16x 0x3
#define STBY_SENSE8x 0x4
#define STBY_SENSE4x 0x5
#define STBY_SENSE2x 0x6
#define STBY_SENSE1x 0x7
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register:    STANDBY THRESHOLD REGISTER @   43h
     * R/W  
     */

#define CAP_STANDBY_THRESHOLD_ADDRESS 0x43

    typedef union {

        struct
        {
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_STANDBY_THRESHOLDbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    SENSOR INPUT BASE COUNT REGISTERS @   50h~ 57h
     * Read Only 
     */

#define SENSOR_INPUT_BASE_COUNT01_ADDRESS 0x50

    typedef union {

        struct
        {
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } SENSOR_INPUT_BASE_COUNT01bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register: POWER BUTTON REGISTER   @   60h
     *  R only or R/W  
     */

#define CAP_POWER_BUTTON_ADDRESS 0x60

    typedef union {

        struct
        {
            unsigned PWR_BTN : 3;

            unsigned : 5;
        };
        unsigned value : 8;
    } CAP_POWER_BUTTONbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define PWR_BTNCS1 0x0
#define PWR_BTNCS2 0x1
#define PWR_BTNCS3 0x2
#define PWR_BTNCS4 0x3
#define PWR_BTNCS5 0x4
#define PWR_BTNCS6 0x5
#define PWR_BTNCS7 0x6
#define PWR_BTNCS8 0x7
    ///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  POWER BUTTON CONFIGURATION REGISTER  @   61h
     *  R only or R/W  
     */

#define CAP_POWER_BUTTON_CONFIGURATION_ADDRESS 0x61

    typedef union {

        struct
        {
            unsigned PWR_TIME : 2;
            unsigned PWR_EN : 1;
            unsigned STBY_PWR_TIME : 2;
            unsigned STBY_PWR_EN : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_POWER_BUTTON_CONFIGURATIONbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define PWR_TIME280ms 0x0
#define PWR_TIME560ms 0x1
#define PWR_TIME1_12s 0x2 //Default set
#define PWR_TIME2_24s 0x3

#define STBY_PWR_TIME280ms 0x0
#define STBY_PWR_TIME560ms 0x1
#define STBY_PWR_TIME1_12s 0x2 //Default set
#define STBY_PWR_TIME2_24s 0x3

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    SENSOR INPUT CALIBRATION REGISTERS @   b1h~ b8h b9h~bah contain 2 bits for each sensor.
     * Read Only    
     */

#define SENSOR_INPUT_CALIBRATION01_ADDRESS 0xb1

    typedef union {

        struct
        {
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } SENSOR_INPUT_CALIBRATION01bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP_CALIBRATION SENSITIVITY CONFIGURATION REGISTERS  @     80h
     *  R only or R/W  
     */

#define CAP_CALIBRATION_SENSITIVITY_CONFIGURATION_ADDRESS 0x80

    typedef union {

        struct
        {
            unsigned CALSEN1 : 2;
            unsigned CALSEN2 : 2;
            unsigned CALSEN3 : 2;
            unsigned CALSEN4 : 2;
        };
        unsigned value : 8;
    } CAP_CALIBRATION_SENSITIVITY_CONFIGURATIONbits_t;
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define CALSEN5_50pf 0x0
#define CALSEN0_25pf 0x1
#define CALSEN0_12_5pf 0x2

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP_CALIBRATION SENSITIVITY CONFIGURATION REGISTERS ( 2nd Byte ) @     81h
     *  R only or R/W  
     */

#define CAP_CALIBRATION_SENSITIVITY_CONFIGURATION_1_ADDRESS 0x81

    typedef union {

        struct
        {
            unsigned CALSEN5 : 2;
            unsigned CALSEN6 : 2;
            unsigned CALSEN7 : 2;
            unsigned CALSEN8 : 2;
        };
        unsigned value : 8;
    } CAP_CALIBRATION_SENSITIVITY_CONFIGURATION_1bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define CALSEN5_50pf 0x0
#define CALSEN0_25pf 0x1
#define CALSEN0_12_5pf 0x2

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //Here below was the examples to access the register and bits defined inside.
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP_  @     88h
     *  R only or R/W  
     */

#define CAP__ADDRESS 0x88

    typedef union {

        struct
        {
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define A1 0x0
#define A2 0x1
#define A4 0x2
#define A8 0x3 //Default set
#define A16 0x4
#define A32 0x5
#define A64 0x6
#define A128 0x7
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#ifdef __cplusplus
}
#endif

#endif /* CAP12xx_H */
