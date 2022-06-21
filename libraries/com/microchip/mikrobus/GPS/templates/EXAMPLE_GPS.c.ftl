/*
<#include "MicrochipDisclaimer.ftl">
*/
/*
<#if (GPS_CLICK_NAME == "GPS_Nano")>
 * File:   EXAMPLE_NanoGPS.c
<#elseif (GPS_CLICK_NAME == "GPS_3")>
 * File:   EXAMPLE_GPS3.c
</#if>
 */
#ifdef __XC
#include <xc.h>
#endif
#include <stdint.h>
#include "mcc.h"
<#if (NEMA_GPGGA == "enabled")>
#include "GGA_Sentence.h"
</#if>
<#if (NEMA_GPGLL == "enabled")>
#include "GLL_Sentence.h"
</#if>
<#if (NEMA_GPGSA == "enabled")>
#include "GSA_Sentence.h"
</#if>
<#if (NEMA_GPGSV == "enabled")>
#include "GSV_Sentence.h"
</#if>
<#if (NEMA_GPRMC == "enabled")>
#include "RMC_Sentence.h"
</#if>
<#if (NEMA_GPTXT == "enabled")>
#include "TXT_Sentence.h"
</#if>
<#if (NEMA_GPVTG == "enabled")>
#include "VTG_Sentence.h"
</#if>
#include "VT100.h"
#include "SOFTWARE_Uart.h"
<#if (GPS_CLICK_NAME == "GPS_Nano")>
#include "NANOGPS_driver.h"
<#elseif (GPS_CLICK_NAME == "GPS_3")>
#include "GPS3_driver.h"
</#if>
//*********************************************************
//          Local Defines/Variables used for Example
//*********************************************************
#define	NULL	(0)
static uint8_t  String[20];
//*********************************************************
//          Local Prototype Functions
//*********************************************************
<#if (NEMA_GPGGA == "enabled")>
static void EXAMPLE_ProcessGGA(void);
</#if>
<#if (NEMA_GPGLL == "enabled")>
static void EXAMPLE_ProcessGLL(void);
</#if>
<#if (NEMA_GPGSA == "enabled")>
static void EXAMPLE_ProcessGSA(void);
</#if>
<#if (NEMA_GPGSV == "enabled")>
static void EXAMPLE_ProcessGSV(void);
</#if>
<#if (NEMA_GPRMC == "enabled")>
static void EXAMPLE_ProcessRMC(void);
</#if>
<#if (NEMA_GPTXT == "enabled")>
static void EXAMPLE_ProcessTXT(void);
</#if>
<#if (NEMA_GPVTG == "enabled")>
static void EXAMPLE_ProcessVTG(void);
</#if>
static void EXAMPLE_Label_Screen(void);

//*********************************************************
//          Accessible Example Functions
//*********************************************************
void EXAMPLE_StartUp(void)
{
    SOFTWARE_UartInitialize ();
<#if (GPS_CLICK_NAME == "GPS_Nano")>
    NANOGPS_StartUp();
<#elseif (GPS_CLICK_NAME == "GPS_3")>
    GPS3_StartUp();
</#if>
    EXAMPLE_Label_Screen();
}
void EXAMPLE_Running(void)
{
    static uint8_t  one_shot = 1;

<#if (gpsResetPin != "")>
    if (${exampleResetScreen_PORT} == 0)
        EXAMPLE_Label_Screen();
</#if>

<#if (GPS_CLICK_NAME == "GPS_Nano")>
    NANOGPS_CollectNemaData();
<#elseif (GPS_CLICK_NAME == "GPS_3")>
    GPS3_CollectNemaData();
</#if>

<#if (NEMA_GPGGA == "enabled")>
    if (GGA_Data_Ready () == true)
        EXAMPLE_ProcessGGA();
</#if>
<#if (NEMA_GPGLL == "enabled")>
    if (GLL_Data_Ready () == true)
        EXAMPLE_ProcessGLL();
</#if>
<#if (NEMA_GPGSA == "enabled")>
    if (GSA_Data_Ready () == true)
        EXAMPLE_ProcessGSA();
</#if>
<#if (NEMA_GPGSV == "enabled")>
    if (GSV_Data_Ready () == true)
        EXAMPLE_ProcessGSV();
</#if>
<#if (NEMA_GPRMC == "enabled")>
    if (RMC_Data_Ready () == true)
        EXAMPLE_ProcessRMC();
</#if>
<#if (NEMA_GPTXT == "enabled")> 
    if (TXT_Data_Ready () == Valid)
        EXAMPLE_ProcessTXT();
</#if>
<#if (NEMA_GPVTG == "enabled")>  
    if (VTG_Data_Ready () == true)
        EXAMPLE_ProcessVTG();   
</#if>
}
////*********************************************************
////          Local Used Example Functions
////*********************************************************
<#if (NEMA_GPGGA == "enabled")>
static void EXAMPLE_ProcessGGA(void)
{
    /* process GGA sentence here */
    VT100_SetCursorRC (2, 6);
    SOFTWARE_UartPutString (Get_GGA_Latitude_Str());
    SOFTWARE_UartPutString (Get_GGA_Latitude_Direction());
    VT100_SetCursorRC (2, 25);
    SOFTWARE_UartPutString (Get_GGA_Longitude_Str());
    SOFTWARE_UartPutString (Get_GGA_Longitude_Direction());
    Free_GGA_Buffer();   
}
</#if>
<#if (NEMA_GPGSA == "enabled")>
static void EXAMPLE_ProcessGSA(void)
{
    char  ch;

    /* process GSA sentence here */
    VT100_SetCursorRC (1, 48);
    ch = *Get_GSA_Fix_Status ();
    if (ch == '1' )
        SOFTWARE_UartPutString ("No Fix");
    else if (ch == '2')
        SOFTWARE_UartPutString ("2D Fix");
    else if (ch == '3')
        SOFTWARE_UartPutString ("3D Fix");
    VT100_SetCursorRC (6, 13);
    for (uint8_t  i = 0; i < 12; i++)
    {
        char * satellite = Get_GSA_Satellite (i);
        /* process individual satellite number here */
        SOFTWARE_UartPutString (satellite);
        SOFTWARE_UartPutChar (',');
    }

    VT100_SetCursorRC (4, 7);
    SOFTWARE_UartPutString (Get_GSA_Pdop());
    VT100_SetCursorRC (4, 19);
    SOFTWARE_UartPutString (Get_GSA_Hdop());
    VT100_SetCursorRC (4, 31);
    SOFTWARE_UartPutString (Get_GSA_Vdop());
    Free_GSA_Buffer();       
}
</#if>
<#if (NEMA_GPGSV == "enabled")>
static void EXAMPLE_ProcessGSV(void)
{
    uint8_t  nS;
    float    HD;

    VT100_SetCursorRC (7,13);

    nS = Get_GSV_Num_Satellites();
    SOFTWARE_UartFormateUI8ToStr (nS, String);
    SOFTWARE_UartPutString (String);
    SOFTWARE_UartPutChar ('\r');
    SOFTWARE_UartPutChar ('\n');
    SOFTWARE_UartPutChar ('\n');
    for (uint8_t i = 0; i < nS; i++)
    {
        char * Satellite;
        uint8_t  Sat_Num;
        uint8_t  Azimuth;
        uint16_t  Heading;
        uint8_t   SNR;

        Satellite = Get_GSV_Sat_In_View (i);
        Parse_Satellite_Info (Satellite, &Sat_Num, &Azimuth, &Heading, &SNR);
        /* process individual satellite details here. */
        if (SNR > 0)
        {
            SOFTWARE_UartFormateUI8ToStr (Sat_Num, String);
            SOFTWARE_UartPutString (String);
            SOFTWARE_UartPutChar (' ');
            SOFTWARE_UartFormateUI8ToStr (Azimuth, String);
            SOFTWARE_UartPutString (String);
            SOFTWARE_UartPutChar (' ');
            SOFTWARE_UartFormateHdgToSt (Heading, String);
            SOFTWARE_UartPutString (String);
            SOFTWARE_UartPutChar (' ');
            SOFTWARE_UartFormateUI8ToStr (SNR, String);
            SOFTWARE_UartPutString (String);
            VT100_ClearToEOL ();
            SOFTWARE_UartPutString ("\r\n");
        }
    }
    VT100_ClearToEOL ();
    Free_GSV_Buffer();      
}
</#if>
<#if (NEMA_GPGLL == "enabled")>
static void EXAMPLE_ProcessGLL(void)
{   // /Process RMC sentence here.  
    Free_GLL_Buffer();       
}
</#if>
<#if (NEMA_GPRMC == "enabled")>
static void EXAMPLE_ProcessRMC(void)
{
    VT100_SetCursorRC (1,7);
    SOFTWARE_UartPutString (Get_RMC_Date());
    VT100_SetCursorRC (1,24);
    SOFTWARE_UartPutString (Get_RMC_Time());
    /* process RMC sentence here.  */
    Free_RMC_Buffer();   
}
</#if>
<#if (NEMA_GPTXT == "enabled")>
static void EXAMPLE_ProcessTXT(void)
{   /* process RMC sentence here.  */
    Free_TXT_Buffer();    
}
</#if>
<#if (NEMA_GPVTG == "enabled")>
static void EXAMPLE_ProcessVTG(void)
{   
    VT100_SetCursorRC (3,5);
    SOFTWARE_UartPutString (Get_VTG_True_Track());
    VT100_SetCursorRC (3,14);
    SOFTWARE_UartPutString (Get_VTG_Mag_Track());
    VT100_SetCursorRC (3,29);
    SOFTWARE_UartPutString (Get_VTG_Ground_Speed_Kts());
    VT100_SetCursorRC (3,43);
    SOFTWARE_UartPutString (Get_VTG_Ground_Speed_Kms());
    VT100_ClearToEOL ();

    /* process RMC sentence here.  */
    Free_VTG_Buffer(); 
}
</#if>
static void EXAMPLE_Label_Screen(void)
{
    VT100_ClearScreen();
    VT100_HomeCursor ();
    SOFTWARE_UartPutString ("Date:");
    VT100_SetCursorRC (1, 17);
    SOFTWARE_UartPutString ("Time:");
    VT100_SetCursorRC (1, 36);
    SOFTWARE_UartPutString ("Fix Status:");
    VT100_SetCursorRC (2,1);
    SOFTWARE_UartPutString ("Lat:");
    VT100_SetCursorRC (2,18);
    SOFTWARE_UartPutString ("Long:");


    VT100_SetCursorRC (3,1);
    SOFTWARE_UartPutString ("TT:");
    VT100_SetCursorRC (3, 13);
    SOFTWARE_UartPutString ("MT:");
    VT100_SetCursorRC (3, 22);
    SOFTWARE_UartPutString ("GS Kt:");
    VT100_SetCursorRC (3,36);
    SOFTWARE_UartPutString ("GS Km:");

    VT100_SetCursorRC (6, 1);
    SOFTWARE_UartPutString ("Satellites: ");
    VT100_SetCursorRC (4, 1);
    SOFTWARE_UartPutString ("Pdop:");
    VT100_SetCursorRC (4, 13);
    SOFTWARE_UartPutString ("Hdop:");
    VT100_SetCursorRC (4, 25);
    SOFTWARE_UartPutString ("Vdop:");

    VT100_SetCursorRC (7,1);
    SOFTWARE_UartPutString ("Satellites: ");
    SOFTWARE_UartPutChar ('\r');
    SOFTWARE_UartPutChar ('\n');
    SOFTWARE_UartPutString ("S# El AzT SNR");
}
/**
 End of File
 */