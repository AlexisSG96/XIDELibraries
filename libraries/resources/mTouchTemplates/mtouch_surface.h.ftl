/*
    MICROCHIP SOFTWARE NOTICE AND DISCLAIMER:

    You may use this software, and any derivatives created by any person or
    entity by or on your behalf, exclusively with Microchip's products.
    Microchip and its subsidiaries ("Microchip"), and its licensors, retain all
    ownership and intellectual property rights in the accompanying software and
    in all derivatives hereto.

    This software and any accompanying information is for suggestion only. It
    does not modify Microchip's standard warranty for its products.  You agree
    that you are solely responsible for testing the software and determining
    its suitability.  Microchip has no obligation to modify, test, certify, or
    support the software.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".  NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE APPLY TO THIS SOFTWARE, ITS INTERACTION WITH MICROCHIP'S
    PRODUCTS, COMBINATION WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT, WILL MICROCHIP BE LIABLE, WHETHER IN CONTRACT, WARRANTY, TORT
    (INCLUDING NEGLIGENCE OR BREACH OF STATUTORY DUTY), STRICT LIABILITY,
    INDEMNITY, CONTRIBUTION, OR OTHERWISE, FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    EXEMPLARY, INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, FOR COST OR EXPENSE OF
    ANY KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWSOEVER CAUSED, EVEN IF
    MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE
    FORESEEABLE.  TO THE FULLEST EXTENT ALLOWABLE BY LAW, MICROCHIP'S TOTAL
    LIABILITY ON ALL CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED
    THE AMOUNT OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR
    THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF
    THESE TERMS.
*/

#ifndef __MTOUCH_SURFACE_H__
#define __MTOUCH_SURFACE_H__

/*----------------------------------------------------------------------------
  include files
----------------------------------------------------------------------------*/
#include "../mcc.h"
#include <stdint.h>
#include <__null.h>
<#if mtouch.button.enabled??>
#include "mtouch_button.h"
</#if>
<#if mtouch.gesture.enabled??>
#include "mtouch_gesture.h"
</#if>

/* 
 * =======================================================================
 * Surface Global Constants
 * =======================================================================
 */
#define HORIZONTAL                  0u
#define VERTICAL                    1u

/* 
 * =======================================================================
 * Surface Macros
 * =======================================================================
 */
#define SURFACE_RESOLUTION_BITS           12u      
#define SURFACE_RESOLUTION_VALUE         (uint16_t)((uint16_t)1u << SURFACE_RESOLUTION_BITS) 
#define SURFACE_DEAD_BAND_ONE_PERCENT	 (SURFACE_RESOLUTION_VALUE/100u)

#define DIFFERENCE(A,B) 	(((A)>=(B))?((A)-(B)):((B)-(A)))
#define MIN(A,B)                (((A)<(B))?(A):(B))
#define MAX(A,B)                (((A)>(B))?(A):(B))

/* Resolution / Deadband */
#define SURFACE_RESOLUTION(m)       ((uint8_t)(((m) & 0xF0u) >> 4u))
#define SURFACE_DEADBAND(m)         ((uint8_t)((m) & 0x0Fu))
#define SURFACE_RESOL_DEADBAND(r,p) ((uint8_t)(((r) << 4u)|(p)))

/* Position filtering */
#define POSITION_IIR_MASK           	0x03u
#define POSITION_MEDIAN_ENABLE      	0x10u
#define SURFACE_MEDIAN_IIR(r,p)         ((uint8_t)(((r) << 4u)|(p)))

/* Common status bits */
#define TOUCH_ACTIVE            (uint8_t)((uint8_t)1u<<0u) 		/* Bit 0 */
#define SURFACE_REBURST	    	(uint8_t)((uint8_t)1u<<7u) 		/* Bit 7 */

/* Contact status bits */
#define POSITION_CHANGE		    (uint8_t)((uint8_t)1u<<1u) 		/* Bit 1 */
#define POSITION_H_INC		    (uint8_t)((uint8_t)1u<<2u) 		/* Bit 2 */
#define POSITION_H_DEC		    (uint8_t)((uint8_t)1u<<3u) 		/* Bit 3 */
#define POSITION_V_INC		    (uint8_t)((uint8_t)1u<<4u) 		/* Bit 4 */
#define POSITION_V_DEC		    (uint8_t)((uint8_t)1u<<5u) 		/* Bit 5 */

/* Surface status bits */
#define POS_MERGED_H		    (uint8_t)((uint8_t)1u<<4u) 		/* Bit 4 */
#define POS_MERGED_V		    (uint8_t)((uint8_t)1u<<5u) 		/* Bit 5 */
/* 
 * =======================================================================
 * Surface Enumerations
 * =======================================================================
 */
/* surface resolution setting */
typedef enum tag_surface_resolution_t
{
	SURFACE_RESOL_2_BIT = 2,
	SURFACE_RESOL_3_BIT,
	SURFACE_RESOL_4_BIT,
	SURFACE_RESOL_5_BIT,
	SURFACE_RESOL_6_BIT,
	SURFACE_RESOL_7_BIT,
	SURFACE_RESOL_8_BIT,
	SURFACE_RESOL_9_BIT,
	SURFACE_RESOL_10_BIT,
	SURFACE_RESOL_11_BIT,
	SURFACE_RESOL_12_BIT	
}surface_resolution_t;

/* surface deadband percentage setting */
typedef enum tag_surface_deadband_t
{
	SURFACE_DB_NONE,
	SURFACE_DB_1_PERCENT,
	SURFACE_DB_2_PERCENT,
	SURFACE_DB_3_PERCENT,
	SURFACE_DB_4_PERCENT,
	SURFACE_DB_5_PERCENT,
	SURFACE_DB_6_PERCENT,
	SURFACE_DB_7_PERCENT,
	SURFACE_DB_8_PERCENT,
	SURFACE_DB_9_PERCENT,
	SURFACE_DB_10_PERCENT,
	SURFACE_DB_11_PERCENT,
	SURFACE_DB_12_PERCENT,
	SURFACE_DB_13_PERCENT,
	SURFACE_DB_14_PERCENT,
	SURFACE_DB_15_PERCENT
}surface_deadband_t;


/* 
 * =======================================================================
 * Surface Global Ptototypes
 * =======================================================================
 */
<#if mtouch.surface.num_contacts == 2>
uint8_t  MTOUCH_Surface_Contact_Status_Get(uint8_t contact );
uint16_t MTOUCH_Surface_Position_Get(uint8_t ver_or_hor, uint8_t contact );
<#else>
uint16_t MTOUCH_Surface_Position_Get(uint8_t ver_or_hor);
</#if>
uint8_t  MTOUCH_Surface_Status_Get(void);
uint8_t  MTOUCH_Surface_Resolution_Get(void);
uint8_t  MTOUCH_Surface_Deadband_Get(void);
void     MTOUCH_Surface_Resolution_Set(uint8_t resol);
void     MTOUCH_Surface_Deadband_Set(uint8_t db);
void     MTOUCH_Surface_InitializeAll(void);
void     MTOUCH_Surface_ServiceAll(void);
#endif
