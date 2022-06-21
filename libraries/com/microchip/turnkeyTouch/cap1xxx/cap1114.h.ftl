/*
<#include "MicrochipDisclaimer.ftl">
*/

#ifndef CAP1114_H
#define CAP1114_H

#ifdef __cplusplus
extern "C"
{
#endif

/*
 * Register Definitions For CAP1114
 */

#define CAP_PRODUCT_ID_ADDRESS  0xfd //CAP1114  ~~~~~~~ h
#define CAP_VENDOR_ID_ADDRESS   0xfe  // CAP1114 default 3Ah
#define CAP_REVISION_ADDRESS    0xff   // CAP1114 default 80h

#define PRODUCT_ID_CAP1114      0x3A
#define MANUFACTURER_ID_CAP1114 0x5d

#define CAP_MAX_SENSOR_NUM      14

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Register: CAP_MAIN_CONTROL               @       00h
#define CAP_MAIN_STATUS_CONTROL_ADDRESS 0x00

    typedef union {

        struct
        {
            unsigned INT : 1;
            unsigned PWR_LED : 1;
            unsigned : 2;
            unsigned DSLEEP : 1;
            unsigned SLEEP : 1;
            unsigned DEACT : 1;
            unsigned : 1;
        };

        unsigned value : 8;
    } CAP_MAIN_STATUS_CONTROLbits_t;

    // bit field macros
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: BUTTON STATUS REGISTER 1    @03h
    // Read Only .
#define CAP_BUTTON_STATUS_1_ADDRESS 0x03

    typedef union {

        struct
        {
            unsigned CS1 : 1;
            unsigned CS2 : 1;
            unsigned CS3 : 1;
            unsigned CS4 : 1;
            unsigned CS5 : 1;
            unsigned CS6 : 1;
            unsigned DOWN : 1;
            unsigned UP : 1;
        };
        unsigned value : 8;

    } CAP_BUTTON_STATUS_1bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: BUTTON STATUS REGISTER 2    @04h
    // Read Only .
#define CAP_BUTTON_STATUS_2_ADDRESS 0x04

    typedef union {

        struct
        {
            unsigned CS7 : 1;
            unsigned CS8 : 1;
            unsigned CS9 : 1;
            unsigned CS10 : 1;
            unsigned CS11 : 1;
            unsigned CS12 : 1;
            unsigned CS13 : 1;
            unsigned CS14 : 1;
        };
        unsigned value : 8;

    } CAP_BUTTON_STATUS_2bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: BUILD REVISION REGISTER  @   05h
    // Read Only
#define CAP_BUILD_REVISION_ADDRESS 0x05

    typedef union {

        struct
        {
            unsigned BUILD0 : 1;
            unsigned BUILD1 : 1;
            unsigned BUILD2 : 1;
            unsigned BUILD3 : 1;
            unsigned BUILD4 : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
        };
        unsigned value : 8;

    } CAP_BUILD_REVISIONbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: SLIDER POSITION / VOLUMETRIC DATA         @ 06h
#define CAP_SLIDER_POSITION_VOLUMETRIC_DATA_ADDRESS 0x06

    typedef union {

        struct
        {
            unsigned POS : 7;
            unsigned : 1;
        };
        unsigned value : 8;

    } CAP_SLIDER_POSITION_VOLUMETRIC_DATAbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: VOLUMETRIC STEP        @09h
#define CAP_VOLUMETRIC_STEP_ADDRESS 0x09

    typedef union {

        struct
        {
            unsigned VOL_STEP : 4;
            unsigned : 4;
        };
        unsigned value : 8;

    } CAP_VOLUMETRIC_STEPbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: NOISE STATUS REGISTERS 1  @   0Ah
    // Read Only
#define CAP_NOISE_STATUS_1_ADDRESS 0x0a

    typedef union {

        struct
        {
            unsigned S1_NOISE : 1;
            unsigned S2_NOISE : 1;
            unsigned S3_NOISE : 1;
            unsigned S4_NOISE : 1;
            unsigned S5_NOISE : 1;
            unsigned S6_NOISE : 1;
            unsigned S7_NOISE : 1;
            unsigned S1_RF_NOISE : 1;
        };
        unsigned value : 8;
    } CAP_NOISE_STATUS_1bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: NOISE STATUS REGISTERS 2  @   0Bh
    // Read Only
#define CAP_NOISE_STATUS_2_ADDRESS 0x0B

    typedef union {

        struct
        {
            unsigned S8_NOISE : 1;
            unsigned S9_NOISE : 1;
            unsigned S10_NOISE : 1;
            unsigned S11_NOISE : 1;
            unsigned S12_NOISE : 1;
            unsigned S13_NOISE : 1;
            unsigned S14_NOISE : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_NOISE_STATUS_2bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: LID CLOSURE STATUS 1  @   0Ch
    // Read Only
#define CAP_LID_CLOSURE_STATUS_1_ADDRESS 0x0C

    typedef union {

        struct
        {
            unsigned S1_LID : 1;
            unsigned S2_LID : 1;
            unsigned S3_LID : 1;
            unsigned S4_LID : 1;
            unsigned S5_LID : 1;
            unsigned S6_LID : 1;
            unsigned S7_LID : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_STATUS_1bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: LID CLOSURE STATUS 2  @   0Dh
    // Read Only
#define CAP_LID_CLOSURE_STATUS_2_ADDRESS 0x0D

    typedef union {

        struct
        {
            unsigned S8_LID : 1;
            unsigned S9_LID : 1;
            unsigned S10_LID : 1;
            unsigned S11_LID : 1;
            unsigned S12_LID : 1;
            unsigned S13_LID : 1;
            unsigned S14_LID : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_STATUS_2bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: GPIO STATUS  @   0Eh
    // R-C
#define CAP_GPIO_STATUS_ADDRESS 0x0E

    typedef union {

        struct
        {
            unsigned GPIO1_STS : 1;
            unsigned GPIO2_STS : 1;
            unsigned GPIO3_STS : 1;
            unsigned GPIO4_STS : 1;
            unsigned GPIO5_STS : 1;
            unsigned GPIO6_STS : 1;
            unsigned GPIO7_STS : 1;
            unsigned GPIO8_STS : 1;
        };
        unsigned value : 8;
    } CAP_GPIO_STATUSbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: GROUP STATUS  @   0Fh
    // R-C
#define CAP_GROUP_STATUS_ADDRESS 0x0F

    typedef union {

        struct
        {
            unsigned PH : 1;
            unsigned TAP : 1;
            unsigned DOWN : 1;
            unsigned UP : 1;
            unsigned : 1;
            unsigned RESET : 1;
            unsigned MULT : 1;
            unsigned LID : 1;
        };
        unsigned value : 8;
    } CAP_GROUP_STATUSbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // Register: SENSOR DELTA COUNT REGISTERS    @10h ~ 1Dh
    // Read Only
#define CAP_SENSOR_DELTA_COUNT_ADDRESS 0x10

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  QUEUE CONTROL  @     1Eh
     * R W 
     * */

#define CAP_QUEUE_CONTROL_ADDRESS 0x1E

    typedef union {

        struct
        {
            unsigned QUEUE_B : 3;
        };
        unsigned value : 8;
    } CAP_QUEUE_CONTROLbits_t;
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
    // Register: DATA SENSITIVITY     @   1Fh
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
#define DELTA_SENSE_128X 0x0 //MOST
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
            unsigned RPT_EN_G : 1;
            unsigned MAX_DUR_EN_G : 1;
            unsigned RPT_EN_B : 1;
            unsigned MAX_DUR_EN_B : 1;
            unsigned BLK_ANA_NOISE : 1;
            unsigned BLK_DIG_NOISE : 1;
            unsigned POS_VOL : 1;
            unsigned TIME_OUT : 1;
        };
        unsigned value : 8;
    } CAP_CONFIGURATIONbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: SENSOR  ENABLE REGISTER    @   21h
     R/W
     */

#define CAP_SENSOR_ENABLE_ADDRESS 0x21

    typedef union {

        struct
        {
            unsigned S1_EN : 1;
            unsigned S2_EN : 1;
            unsigned S3_EN : 1;
            unsigned S4_EN : 1;
            unsigned S5_EN : 1;
            unsigned S6_EN : 1;
            unsigned S7_EN : 1;
            unsigned GP_EN : 1;
        };
        unsigned value : 8;
    } CAP_SENSOR_ENABLEbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: BUTTON CONFIGURATION REGISTER    @   22h
    R/W
     * 
     * 
     */
#define CAP_BUTTON_CONFIGURATION_ADDRESS 0x22

    typedef union {

        struct
        {
            unsigned RPT_RATE : 4;
            unsigned MAX_DUR : 4;
        };
        unsigned value : 8;
    } CAP_BUTTON_CONFIGURATIONbits_t;

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
#define MAX_DUR8906ms 0xd //Default for Grouped Sensors
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

    /* Register: GROUP CONFIGURATION REGISTER 1 @   23h
    R/W
     * 
     * 
     */
#define CAP_GROUP_CONFIGURATION_REGISTER_1_ADDRESS 0x23

    typedef union {

        struct
        {
            unsigned M_PRESS : 4;
            unsigned RPT_RATE_PH : 4;
        };
        unsigned value : 8;
    } CAP_GROUP_CONFIGURATION_REGISTER_1bits_t;

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

    /* Register: GROUP_CONFIGURATION 2      @       24h
    R/W
     */
#define CAP_GROUP_CONFIGURATION_2_ADDRESS 0x24

    typedef union {

        struct
        {
            unsigned RPT_RATE_SL : 4;
            unsigned MAX_DUR_G : 4;
        };
        unsigned value : 8;
    } CAP_GROUP_CONFIGURATION_2bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: CALIBRATION ENABLE REGISTER    @   25h
    R/W
      */

#define CAP_CALIBRATION_ENABLE_ADDRESS 0x25

    typedef union {

        struct
        {
            unsigned S1_CEN : 1;
            unsigned S2_CEN : 1;
            unsigned S3_CEN : 1;
            unsigned S4_CEN : 1;
            unsigned S5_CEN : 1;
            unsigned S6_CEN : 1;
            unsigned S7_CEN : 1;
            unsigned G_CEN : 1;
        };
        unsigned value : 8;
    } CAP_CALIBRATION_ENABLEbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: CALIBRATION ACTIVATE     @   26h
    R/W
    */

#define CAP_CALIBRATION_ACTIVATE_ADDRESS 0x26

    typedef union {

        struct
        {
            unsigned S1_CAL : 1;
            unsigned S2_CAL : 1;
            unsigned S3_CAL : 1;
            unsigned S4_CAL : 1;
            unsigned S5_CAL : 1;
            unsigned S6_CAL : 1;
            unsigned S7_CAL : 1;
            unsigned G_CAL : 1;
        };
        unsigned value : 8;
    } CAP_CALIBRATION_ACTIVATEbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: GROUPED SENSOR CALIBRATION ACTIVATE @ 46h
    R/W
  
    
   */

#define CAP_GROUPED_SENSOR_CALIBRATION_ACTIVATE_ADDRESS 0x46

    typedef union {

        struct
        {
            unsigned S8_CAL : 1;
            unsigned S9_CAL : 1;
            unsigned S10_CAL : 1;
            unsigned S11_CAL : 1;
            unsigned S12_CAL : 1;
            unsigned S13_CAL : 1;
            unsigned S14_CAL : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_GROUPED_SENSOR_CALIBRATION_ACTIVATEbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: INTERRUPT ENABLE  1     @   27h
    R/W
     */

#define CAP_INTERRUPT_ENABLE_1_ADDRESS 0x27

    typedef union {

        struct
        {
            unsigned S1_INT_EN : 1;
            unsigned S2_INT_EN : 1;
            unsigned S3_INT_EN : 1;
            unsigned S4_INT_EN : 1;
            unsigned S5_INT_EN : 1;
            unsigned S6_INT_EN : 1;
            unsigned S7_INT_EN : 1;
            unsigned G_INT_EN : 1;
        };
        unsigned value : 8;
    } CAP_INTERRUPT_ENABLE_1bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: INTERRUPT ENABLE 2    @   28h
    R/W
     */

#define CAP_INTERRUPT_ENABLE_2_ADDRESS 0x28

    typedef union {

        struct
        {
            unsigned GPIO1_INT_EN : 1;
            unsigned GPIO2_INT_EN : 1;
            unsigned GPIO3_INT_EN : 1;
            unsigned GPIO4_INT_EN : 1;
            unsigned GPIO5_INT_EN : 1;
            unsigned GPIO6_INT_EN : 1;
            unsigned GPIO7_INT_EN : 1;
            unsigned GPIO8_INT_EN : 1;
        };
        unsigned value : 8;
    } CAP_INTERRUPT_ENABLE_2bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: SLEEP CHANNEL CONTROL     @   29h
    R/W
     */

#define CAP_SLEEP_CHANNEL_CONTROL_ADDRESS 0x29

    typedef union {

        struct
        {
            unsigned S1_SLEEP : 1;
            unsigned S2_SLEEP : 1;
            unsigned S3_SLEEP : 1;
            unsigned S4_SLEEP : 1;
            unsigned S5_SLEEP : 1;
            unsigned S6_SLEEP : 1;
            unsigned S7_SLEEP : 1;
            unsigned GR_SLEEP : 1;
        };
        unsigned value : 8;
    } CAP_RSLEEP_CHANNEL_CONTROLbits_t;
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
            unsigned G_MULT_T : 2;

            unsigned B_MULT_T : 2; // Bit field as below .

            unsigned : 3;

            unsigned MULT_BLK_EN : 1; // 1 default ( Enable ) ; 0 disable
        };
        unsigned value : 8;
    } CAP_MULTIPLE_TOUCH_CONFIGURATIONbits_t;

    // bit field macros
#define B_MULT_T_1 0x0 //DEFAULT
#define B_MULT_T_2 0x1
#define B_MULT_T_3 0x2
#define B_MULT_T_4 0x3

#define G_MULT_T_2 0x0
#define G_MULT_T_3 0x1
#define G_MULT_T_4 0x2 //DEFAULT
#define G_MULT_T_1 0x3

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: LID CLOSURE CONFIG   @   2Bh
        R/W
     */

#define CAP_LID_CLOSURE_CONFIG_ADDRESS 0x2b

    typedef union {

        struct
        {
            unsigned LID_ALERT : 1;

            unsigned COMP_PTRN : 1;

            unsigned : 5;

            unsigned LID_CLOSE : 1;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_CONFIGbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: LID CLOSURE QUEUE CONTROL REGISTER  @ 2ch
    R/W
     */

#define CAP_LID_CLOSURE_QUEUE_CONTROL_ADDRESS 0x2C

    typedef union {

        struct
        {
            unsigned QUEUE_l_B : 3;

            unsigned : 5;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_QUEUE_CONTROLbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: LID CLOSURE PATTERN 1   @   2Dh
    R/W
     */

#define CAP_LID_CLOSURE_PATTERN_1_ADDRESS 0x2D

    typedef union {

        struct
        {
            unsigned S1_LM : 1;
            unsigned S2_LM : 1;
            unsigned S3_LM : 1;
            unsigned S4_LM : 1;
            unsigned S5_LM : 1;
            unsigned S6_LM : 1;
            unsigned S7_LM : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_PATTERN_1bits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register: LID CLOSURE PATTERN REGISTERS  2  @   2Eh
    R/W
     */

#define CAP_LID_CLOSURE_PATTERN_2_ADDRESS 0x2E

    typedef union {

        struct
        {
            unsigned S8_LM : 1;
            unsigned S9_LM : 1;
            unsigned S10_LM : 1;
            unsigned S11_LM : 1;
            unsigned S12_LM : 1;
            unsigned S13_LM : 1;
            unsigned S14_LM : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_PATTERN_2bits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register:    RECALIBRATION CONFIGURATION REGISTERS @   2fh
     *  R/W  
     */

#define CAP_RECALIBRATION_CONFIGURATION_ADDRESS 0x2F

    typedef union {

        struct
        {
            unsigned CAL_CFG : 3;
            unsigned NEG_DELTA_CNT : 2;
            unsigned : 1;
            unsigned GP_LD_TH : 1;
            unsigned BUT_LD_TH : 1; // TH set for all CS or Individually
        };
        unsigned value : 8;
    } CAP_RECALIBRATION_CONFIGURATIONbits_t;

    // bit field macros
#define NEG_DELTA_CNT8 0x0
#define NEG_DELTA_CNT16 0x1
#define NEG_DELTA_CNT32 0x2 //Default set
#define NEG_DELTA_CNT8_DISABLE 0x3

#define CAL_CFG16 0x0
#define CAL_CFG32 0x1
#define CAL_CFG64 0x2
#define CAL_CFG128 0x3 //Default set
#define CAL_CFG256 0x4
#define CAL_CFG256_1024 0x5
#define CAL_CFG256_2048 0x6
#define CAL_CFG256_4096 0x7
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register:    SENSOR THRESHOLD REGISTERS @   30h~ 37h
     * R/W  
     */

#define CAP_SENSOR_THRESHOLD01_ADDRESS 0x30

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
    } CAP_SENSOR_THRESHOLD01bits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    BUTTON NOISE THRESHOLD REGISTERS  @   38h
     *  R only or R/W  
     */

#define CAP_BUTTON_NOISE_THRESHOLD_1_ADDRESS 0x38

    typedef union {

        struct
        {
            unsigned CS1_BN_TH : 2;
            unsigned CS2_BN_TH : 2;
            unsigned CS3_BN_TH : 2;
            unsigned CS4_BN_TH : 2;
        };
        unsigned value : 8;
    } CAP_SENSOR_INPUT_NOISE_THRESHOLD_1bits_t;

    // bit field macros
#define CSX_BN_TH6_25 0x0
#define CSX_BN_TH12_5 0x1
#define CSX_BN_TH25 0x2 //Default set
#define CSX_BN_TH50_5 0x3
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    BUTTON NOISE THRESHOLD REGISTERS 2 @   39h
     *  R only or R/W  
     */

#define CAP_BUTTON_NOISE_THRESHOLD_2_ADDRESS 0x39

    typedef union {

        struct
        {
            unsigned CS5_BN_TH : 2;
            unsigned CS6_BN_TH : 2;
            unsigned CS7_BN_TH : 2;
            unsigned GR_BN_TH : 2;
        };
        unsigned value : 8;
    } CAP_BUTTON_NOISE_THRESHOLD_2bits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    
   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    LID CLOSURE THRESHOLD 1 ~ 4 @   3Ah
     * R/W  
     */

#define CAP_LID_CLOSURE_THRESHOLD_1_ADDRESS 0x3A

    typedef union {

        struct
        {
            unsigned CS1_LD_TH : 2;
            unsigned CS2_LD_TH : 2;
            unsigned CS3_LD_TH : 2;
            unsigned CS4_LD_TH : 2;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_THRESHOLD_1bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    LID CLOSURE THRESHOLD 2 @   3Bh
     * R/W  
     */

#define CAP_LID_CLOSURE_THRESHOLD_2_ADDRESS 0x3B

    typedef union {

        struct
        {
            unsigned CS5_LD_TH : 2;
            unsigned CS6_LD_TH : 2;
            unsigned CS7_LD_TH : 2;
            unsigned CS8_LD_TH : 2;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_THRESHOLD_2bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    LID CLOSURE THRESHOLD 3 @   3Ch
     * R/W  
     */

#define CAP_LID_CLOSURE_THRESHOLD_3_ADDRESS 0x3C

    typedef union {

        struct
        {
            unsigned CS9_LD_TH : 2;
            unsigned CS10_LD_TH : 2;
            unsigned CS11_LD_TH : 2;
            unsigned CS12_LD_TH : 2;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_THRESHOLD_3bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    LID CLOSURE THRESHOLD 4 @   3Dh
     * R/W  
     */

#define CAP_LID_CLOSURE_THRESHOLD_4_ADDRESS 0x3D

    typedef union {

        struct
        {
            unsigned CS13_LD_TH : 2;
            unsigned CS14_LD_TH : 2;
            unsigned  : 2;
            unsigned  : 2;
        };
        unsigned value : 8;
    } CAP_LID_CLOSURE_THRESHOLD_4bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    SLIDER VELOCITY CONFIGURATION @   3Eh
     * R/W  
     */

#define CAP_SLIDER_VELOCITY_CONFIGURATION_ADDRESS 0x3E

    typedef union {

        struct
        {
            unsigned RPT_SCALE: 2;
            unsigned SLIDE_TIME: 2;
            unsigned MAX_INT: 3;
            unsigned ACC_INT_EN: 1;
            
        };
        unsigned value : 8;
    } CAP_SLIDER_VELOCITY_CONFIGURATIONbits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    DIGITAL RECALIBRATION CONTROL @   3Fh
     * R/W  
     */

#define CAP_DIGITA_RECALIBRATION_CONTROL_ADDRESS 0x3F

    typedef union {

        struct
        {
            unsigned CS1_D_CAL : 1;
            unsigned CS2_D_CAL : 1;
            unsigned CS3_D_CAL : 1;
            unsigned CS4_D_CAL : 1;
            unsigned CS5_D_CAL : 1;
            unsigned CS6_D_CAL : 1;
            unsigned CS7_D_CAL : 1;
            unsigned GP_D_CAL : 1;
        };
        unsigned value : 8;
    } CAP_DIGITA_RECALIBRATION_CONTROLbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    CONFIGURATION 2 @   40h
     * R/W  
     */

#define CAP_CONFIGURATION_2_ADDRESS 0x40

    typedef union {

        struct
        {
            unsigned INT_REL_n : 1;
            unsigned VOL_UP_DOWN : 1;
            unsigned BLK_RF_NOISE : 1;
            unsigned SHOW_RF_NOISE : 1;
            unsigned BLK_POL_MIR : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned INV_LINK_TRAN : 1;
        };
        unsigned value : 8;
    } CAP_CONFIGURATION_2bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    GROUPED SENSOR CHANNEL ENABLE REGISTER@   41h
     * R/W  
    */

#define CAP_GROUPED_SENSOR_CHANNEL_ENABLE_ADDRESS 0x41

    typedef union {

        struct
        {
            unsigned CS8_EN : 1;
            unsigned CS9_EN : 1;
            unsigned CS10_EN : 1;
            unsigned CS11_EN : 1;
            unsigned CS12_EN : 1;
            unsigned CS13_EN : 1;
            unsigned CS14_EN : 1;
            unsigned  : 1;
        };
        unsigned value : 8;
    } CAP_GROUPED_SENSOR_CHANNEL_ENABLEbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  PROXIMITY CONTROL @   42h
     * R/W  
     */

#define CAP_PROXIMITY_CONTROL_ADDRESS 0x42

    typedef union {

        struct
        {
            unsigned PROX_D_SENSE : 3;
            unsigned PROX_AVG : 2;
            unsigned : 1;
            unsigned PROX_SUM : 1;
            unsigned CS1_PROX : 1;
        };
        unsigned value : 8;
    } CAP_PROXIMITY_CONTROLbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /* Register:    SAMPLING CHANNEL SELECT @   4Eh
     * R/W  
     */

#define CAP_SAMPLING_CHANNEL_SELECT_ADDRESS 0x4E

    typedef union {

        struct
        {
            unsigned CS1_S : 1;
            unsigned CS2_S : 1;
            unsigned CS3_S : 1;
            unsigned CS4_S : 1;
            unsigned CS5_S : 1;
            unsigned CS6_S : 1;
            unsigned CS7_S : 1;
            unsigned GR_S : 1;
        };
        unsigned value : 8;
    } CAP_SAMPLING_CHANNEL_SELECTbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register: SAMPLING CONFIGURATION REGISTER @   4Fh
     * R/W  
     */

#define CAP_SAMPLING_CONFIGURATION_ADDRESS 0x4F

    typedef union {

        struct
        {
            unsigned OVERSAMP_RATE : 3;

            unsigned : 5;

        };
        unsigned value : 8;
    } CAP_SAMPLING_CONFIGURATIONbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    SENSOR  BASE COUNT REGISTERS @   50h~ 5Dh
     * Read Only 
     */

#define CAP_SENSOR_BASE_COUNT01_ADDRESS 0x50

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
    } CAP_SENSOR_BASE_COUNT01bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    LED STATUS 1 @  60H
     * Read Only 
     */

#define CAP_LED_STATUS_1_ADDRESS 0x60

    typedef union {

        struct
        {
            unsigned LED1_DN : 1;
            unsigned LED2_DN : 1;
            unsigned LED3_DN : 1;
            unsigned LED4_DN : 1;
            unsigned LED5_DN : 1;
            unsigned LED6_DN : 1;
            unsigned LED7_DN : 1;
            unsigned LED8_DN : 1;
        };
        unsigned value : 8;
    } CAP_LED_STATUS_1bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED STATUS REGISTERS 2  @     61h
     * R/W  
     */

#define CAP_LED_STATUS_2_ADDRESS 0x61

    typedef union {

        struct
        {
            unsigned LED9_DN : 1;
            unsigned LED10_DN : 1;
            unsigned LED11_DN : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LED_STATUS_2bits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED / GPIO DIRECTION REGISTER  @     70h
     * R/W  
     */

#define CAP_LED_GPIO_DIRECTION_ADDRESS 0x70

    typedef union {

        struct
        {
            unsigned LED1_DIR : 1;
            unsigned LED2_DIR : 1;
            unsigned LED3_DIR : 1;
            unsigned LED4_DIR : 1;
            unsigned LED5_DIR : 1;
            unsigned LED6_DIR : 1;
            unsigned LED7_DIR : 1;
            unsigned LED8_DIR : 1;
        };
        unsigned value : 8;
    } CAP_LED_GPIO_DIRECTIONbits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    LED / GPIO OUTPUT TYPE @71H
     * RW   
     */

#define CAP_LED_GPIO_OUTPUT_TYPE_ADDRESS 0x71

    typedef union {

        struct
        {
            unsigned LED1_OT : 1;
            unsigned LED2_OT : 1;
            unsigned LED3_OT : 1;
            unsigned LED4_OT : 1;
            unsigned LED5_OT : 1;
            unsigned LED6_OT : 1;
            unsigned LED7_OT : 1;
            unsigned LED8_OT : 1;
        };
        unsigned value : 8;
    } CAP_LED_GPIO_OUTPUT_TYPEbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP_GPIO_INPUT_REGISTER  @   72h
     * R/W  
     */

#define CAP_GPIO_INPUT_ADDRESS 0x72

    typedef union {

        struct
        {
            unsigned GPIO1 : 1;
            unsigned GPIO2 : 1;
            unsigned GPIO3 : 1;
            unsigned GPIO4 : 1;
            unsigned GPIO5 : 1;
            unsigned GPIO6 : 1;
            unsigned GPIO7 : 1;
            unsigned GPIO8 : 1;
        };
        unsigned value : 8;
    } CAP_GPIO_INPUTbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED OUTPUT CONTROL REGISTERS  1 @   73h
     * R/W  
     */

#define CAP_LED_OUTPUT_CONTROL_1_ADDRESS 0x73

    typedef union {

        struct
        {
            unsigned LED1_DR : 1;
            unsigned LED2_DR : 1;
            unsigned LED3_DR : 1;
            unsigned LED4_DR : 1;
            unsigned LED5_DR : 1;
            unsigned LED6_DR : 1;
            unsigned LED7_DR : 1;
            unsigned LED8_DR : 1;
        };
        unsigned value : 8;
    } CAP_LED_OUTPUT_CONTROL_1bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED OUTPUT CONTROL REGISTERS 2  @   74h
     * R/W  
     */

#define CAP_LED_OUTPUT_CONTROL_2_ADDRESS 0x74

    typedef union {

        struct
        {
            unsigned LED9_DR : 1;
            unsigned LED10_DR : 1;
            unsigned LED11_DR : 1;
            unsigned : 5;
        };
        unsigned value : 8;
    } CAP_LED_OUTPUT_CONTROL_2bits_t;

    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    LED POLARITY  1 @75H
     * RW   
     */

#define CAP_LED_POLARITY_1_ADDRESS 0x75

    typedef union {

        struct
        {
            unsigned LED1_POL : 1;
            unsigned LED2_POL : 1;
            unsigned LED3_POL : 1;
            unsigned LED4_POL : 1;
            unsigned LED5_POL : 1;
            unsigned LED6_POL : 1;
            unsigned LED7_POL : 1;
            unsigned LED8_POL : 1;
        };
        unsigned value : 8;
    } CAP_LED_POLARITY_1bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED_POLARITY 2  @   76h
     * R/W  
     */

#define CAP_LED_POLARITY_2_ADDRESS 0x76

    typedef union {

        struct
        {
            unsigned LED9_POL : 1;
            unsigned LED10_POL : 1;
            unsigned LED11_POL : 1;
            unsigned : 5;
        };
        unsigned value : 8;
    } CAP_LED_POLARITY_2bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP_LINKED LED TRANSITION CONTROL REGISTER 1  @   77h
     * R/W  
     */

#define CAP_LINKED_LED_TRANSITION_CONTROL_1_ADDRESS 0x77

    typedef union {

        struct
        {
            unsigned LED1_LTRAN : 1;
            unsigned LED2_LTRAN : 1;
            unsigned LED3_LTRAN : 1;
            unsigned LED4_LTRAN : 1;
            unsigned LED5_LTRAN : 1;
            unsigned LED6_LTRAN : 1;
            unsigned LED7_LTRAN : 1;
            unsigned  : 1;
        };
        unsigned value : 8;
    } CAP_LINKED_LED_TRANSITION_CONTROL_1bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP_LINKED LED TRANSITION CONTROL REGISTER 2  @   78h
     * R/W  
     */

#define CAP_LINKED_LED_TRANSITION_CONTROL_2_ADDRESS 0x78

    typedef union {

        struct
        {
            unsigned LED9_LTRAN : 1;
            unsigned LED10_LTRAN : 1;
            unsigned  : 6;
        };
        unsigned value : 8;
    } CAP_LINKED_LED_TRANSITION_CONTROL_2bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED MIRROR CONTROL 1  @   79h
     * R/W  
     */

#define CAP_LED_MIRROR_CONTROL_1_ADDRESS 0x79

    typedef union {

        struct
        {
            unsigned LED1_MIR_EN : 1;
            unsigned LED2_MIR_EN : 1;
            unsigned LED3_MIR_EN : 1;
            unsigned LED4_MIR_EN : 1;
            unsigned LED5_MIR_EN : 1;
            unsigned LED6_MIR_EN : 1;
            unsigned LED7_MIR_EN : 1;
            unsigned LED8_MIR_EN : 1;
        };
        unsigned value : 8;
    } CAP_LED_MIRROR_CONTROL_1bits_t;


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED MIRROR CONTROL 2  @   7Ah
     * R/W  
     */

#define CAP_LED_MIRROR_CONTROL_2_ADDRESS 0x7A

    typedef union {

        struct
        {
            unsigned LED9_MIR_EN : 1;
            unsigned LED10_MIR_EN : 1;
            unsigned LED11_MIR_EN : 1;
            unsigned : 5;
        
        };
        unsigned value : 8;
    } CAP_LED_MIRROR_CONTROL_2bits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  SENSOR LED LINKING  @   80h
     * R/W  
     */

#define CAP_SENSOR_LED_LINKING_ADDRESS 0x80

    typedef union {

        struct
        {
            unsigned CS1_LED1 : 1;
            unsigned CS2_LED2 : 1;
            unsigned CS3_LED3 : 1;
            unsigned CS4_LED4 : 1;
            unsigned CS5_LED5 : 1;
            unsigned CS6_LED6 : 1;
            unsigned CS7_LED7 : 1;
            unsigned UP_DOWN_LINK : 1;
        };
        unsigned value : 8;
    } CAP_SENSOR_LED_LINKINGbits_t;


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED_BEHAVIOR 1 @     81h
     * R/W  
     */

#define CAP_LED_BEHAVIOR_1_ADDRESS 0x81

    typedef union {

        struct
        {
            unsigned LED1_CTL : 2;
            unsigned LED2_CTL : 2;
            unsigned LED3_CTL : 2;
            unsigned LED4_CTL : 2;
        };
        unsigned value : 8;
    } CAP_LED_BEHAVIOR_1bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED_BEHAVIOR 2  @     82h
     * R/W  
     */

#define CAP_LED_BEHAVIOR_2_ADDRESS 0x82

    typedef union {

        struct
        {
            unsigned LED5_CTL : 2;
            unsigned LED6_CTL : 2;
            unsigned LED7_CTL : 2;
            unsigned LED8_CTL : 2;
        };
        unsigned value : 8;
    } CAP_LED_BEHAVIOR_2bits_t;
    
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED_BEHAVIOR 3  @     83h
     * R/W  
     */

#define CAP_LED_BEHAVIOR_3_ADDRESS 0x83

    typedef union {

        struct
        {
            unsigned LED9_CTL : 2;
            unsigned LED10_CTL : 2;
            unsigned LED11_CTL : 2;
            unsigned LED11_ALT : 2;
        };
        unsigned value : 8;
    } CAP_LED_BEHAVIOR_3bits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define CAP_LED_DIRECT 0x0
#define CAP_LED_PULSE1 0x1
#define CAP_LED_PULSE2 0x2
#define CAP_LED_BREATHE 0x3

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED PULSE 1 PERIOD  @   84h
     * R/W  
     */

#define CAP_LED_PULSE_1_PERIOD_ADDRESS 0x84

    typedef union {

        struct
        {
            unsigned P1_PER0 : 1;
            unsigned P1_PER1 : 1;
            unsigned P1_PER2 : 1;
            unsigned P1_PER3 : 1;
            unsigned P1_PER4 : 1;
            unsigned P1_PER5 : 1;
            unsigned P1_PER6 : 1;
            unsigned ST_TRIG : 1;
        };
        unsigned value : 8;
    } CAP_LED_PULSE_1_PERIODbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED PULSE 2 PERIOD   @   85h
     * R/W  
     */

#define CAP_LED_PULSE_2_PERIOD_ADDRESS 0x85

    typedef union {

        struct
        {
            unsigned P2_PER0 : 1;
            unsigned P2_PER1 : 1;
            unsigned P2_PER2 : 1;
            unsigned P2_PER3 : 1;
            unsigned P2_PER4 : 1;
            unsigned P2_PER5 : 1;
            unsigned P2_PER6 : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LED_PULSE_2_PERIODbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP LED BREATHE PERIOD   @   86h
     * R/W  
     */

#define CAP_LED_BREATHE_PERIOD_ADDRESS 0x86

    typedef union {

        struct
        {
            unsigned BR_PER0 : 1;
            unsigned BR_PER1 : 1;
            unsigned BR_PER2 : 1;
            unsigned BR_PER3 : 1;
            unsigned BR_PER4 : 1;
            unsigned BR_PER5 : 1;
            unsigned BR_PER6 : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LED_BREATHE_PERIODbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED CONFIG  @   88h
     * R/W  
     */

#define CAP_LED_CONFIG_ADDRESS 0x88

    typedef union {

        struct
        {
            unsigned PULSE1_CNT : 3;
            unsigned PULSE2_CNT : 3;
            unsigned RAMP_ALERT : 1;
            unsigned : 1;
        };
        unsigned value : 8;
    } CAP_LED_CONFIGbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // bit field macros
#define CAP_NUMBER_OF_BREATHS1 0x0 //Default Pulse 2
#define CAP_NUMBER_OF_BREATHS2 0x1
#define CAP_NUMBER_OF_BREATHS3 0x2
#define CAP_NUMBER_OF_BREATHS4 0x3
#define CAP_NUMBER_OF_BREATHS5 0x4 //Default Pulse 1
#define CAP_NUMBER_OF_BREATHS6 0x5
#define CAP_NUMBER_OF_BREATHS7 0x6
#define CAP_NUMBER_OF_BREATHS8 0x7

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED PULSE 1 DUTY CYCLE @   90H
     * R/W  
     */

#define CAP_LED_PULSE_1_DUTY_CYCLE_ADDRESS 0x90

    typedef union {

        struct
        {
            unsigned LED_P1_MIN_DUTY : 4;
            unsigned LED_P1_MAX_DUTY : 4;
        };
        unsigned value : 8;
    } CAP_LED_PULSE_1_DUTY_CYCLEbits_t;




    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED PULSE 2 DUTY CYCLE @   91H
     * R/W  
     */

#define CAP_LED_PULSE_2_DUTY_CYCLE_ADDRESS 0x91

    typedef union {

        struct
        {
            unsigned LED_P2_MIN_DUTY : 4;
            unsigned LED_P2_MAX_DUTY : 4;
        };
        unsigned value : 8;
    } CAP_LED_PULSE_2_DUTY_CYCLEbits_t;


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED BREATHE DUTY CYCLE @   92H
     * R/W  
     */

#define CAP_LED_BREATHE_DUTY_CYCLE_ADDRESS 0x92

    typedef union {

        struct
        {
            unsigned LED_BR_MIN_DUTY : 4;
            unsigned LED_BR_MAX_DUTY : 4;
        };
        unsigned value : 8;
    } CAP_LED_BREATHE_DUTY_CYCLEbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  DIRECT DUTY CYCLE @   93H
     * R/W  
     */

#define CAP_DIRECT_DUTY_CYCLE_ADDRESS 0x93

    typedef union {

        struct
        {
            unsigned LED_DR_MIN_DUTY : 4;
            unsigned LED_DR_MAX_DUTY : 4;
        };
        unsigned value : 8;
    } CAP_DIRECT_DUTY_CYCLEbits_t;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED DIRECT RAMP RATES REGISTER @   94H
     * R/W  
     */

#define CAP_LED_DIRECT_RAMP_RATES_ADDRESS 0x94

    typedef union {

        struct
        {
            unsigned FALL_RATE : 3;
            unsigned RISE_RATE : 3;
            unsigned  : 2;
        };
        unsigned value : 8;
    } CAP_LED_DIRECT_RAMP_RATESbits_t;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// bit field macros
#define CAP_LED_RISE_FALL_TIME0MS 0x0
#define CAP_LED_RISE_FALL_TIME250MS 0x1
#define CAP_LED_RISE_FALL_TIME500MS 0x2
#define CAP_LED_RISE_FALL_TIME750MS 0x3
#define CAP_LED_RISE_FALL_TIME1S 0x4
#define CAP_LED_RISE_FALL_TIME1_25S 0x5
#define CAP_LED_RISE_FALL_TIME1_50S 0x6
#define CAP_LED_RISE_FALL_TIME2S 0x7

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  LED OFF DELAY  @   95H
     * R/W  
     */

#define CAP_LED_OFF_DELAY_ADDRESS 0x95

    typedef union {

        struct
        {
            unsigned DIR_OFF_DLY : 3;
            unsigned : 5;
            
        };
        unsigned value : 8;
    } CAP_LED_OFF_DELAYbits_t;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    SENSOR CALIBRATION REGISTERS @B1h~BEh
     * Read Only    
     */

#define CAP_SENSOR_CALIBRATION_ADDRESS 0xB1

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
    } CAP_SENSOR_CALIBRATIONbits_t;

    // bit field macros

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:    SENSOR CALIBRATION LOW BYE @   D0h~ D3h
     * Read Only    
     */

#define CAP_SENSOR_CALIBRATION_LOW_BYE_ADDRESS 0xBE

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
    } CAP_SENSOR_CALIBRATION_LOW_BYEbits_t;


    //Here below was the examples to access the register and bits defined inside.
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    /* Register:  CAP_  @     99h
     *  R only or R/W  
     */

#define CAP__ADDRESS 0x99

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

#endif /* CAP1114_H */

