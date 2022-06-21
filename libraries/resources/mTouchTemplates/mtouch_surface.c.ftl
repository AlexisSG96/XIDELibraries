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

/* Include files */
#include "mtouch_surface.h"
#include "mtouch_button.h"

/* 
 * =======================================================================
 * Surface Statics
 * =======================================================================
 */

static uint8_t new_contact_detected = 0u;
<#if mtouch.surface.num_contacts == 2>
static uint16_t median_filter_data_buffer[SURFACE_NUM_CONTACTS][2][3] = {0};
static uint16_t h_history[2] = {0u};
static uint16_t v_history[2] = {0u};
static uint16_t h_extrapolated[2] = {0u};
static uint16_t v_extrapolated[2] = {0u};
<#assign contacts = "[contact_number]">
<#else>
static uint16_t median_filter_data_buffer[2][3] = {0};
<#assign contacts = "">
</#if>


/* 
 * =======================================================================
 * Surface Structure Declarations
 * =======================================================================
 */
typedef struct
{
  /* Surface CS Configuration */
  uint8_t start_segment_h;					/* Start segment of horizontal axis */
  uint8_t number_of_segments_h;					/* Number of segments in horizontal axis */
  uint8_t start_segment_v;					/* Start segment of vertical axis */
  uint8_t number_of_segments_v;					/* Number of segments in vertical axis */
  uint8_t resol_deadband;					/* Resolution 2 to 12 bits | Deadband 0% to 15% */
  uint8_t position_hysteresis;					/* Distance threshold for initial move or direction change */
  uint8_t position_filter;					/* Bits 1:0 = IIR (0% / 25% / 50% / 75%), Bit 4 = Enable Median Filter (3-point) */
  uint16_t contact_min_threshold;				/* Contact threshold / Sum of 4 deltas */
  /* Surface Contact Data */
<#if mtouch.surface.num_contacts == 2>
  uint8_t surface_status;
  uint8_t contact_status[2];
  uint16_t h_position_abs[2];
  uint16_t h_position[2];
  uint16_t v_position_abs[2];
  uint16_t v_position[2];
  uint16_t contact_size[2];
<#else>
  uint8_t surface_status;
  uint16_t h_position_abs;
  uint16_t h_position;
  uint16_t v_position_abs;
  uint16_t v_position;
  uint16_t contact_size;
</#if>
}mtouch_surface_t;

/* 
 * =======================================================================
 * Surface Structure Definitions
 * =======================================================================
 */
static mtouch_surface_t mtouch_surface = {
    /* Surface CS Configuration */
    SURFACE_CS_START_SEGMENT_H, 
    SURFACE_CS_NUM_SEGMENTS_H,
    SURFACE_CS_START_SEGMENT_V,
    SURFACE_CS_NUM_SEGMENTS_V,
    SURFACE_RESOL_DEADBAND(SURFACE_CS_RESOLUTION, SURFACE_CS_DEADBAND),
    SURFACE_CS_POS_HYST,
    SURFACE_CS_FILT_CFG,
    SURFACE_CS_MIN_CONTACT,
    /* Surface Contact Data  */
<#if mtouch.surface.num_contacts == 2>
    0u, {0u}, {0u}, {0u}, {0u}, {0u}, {0u} 
<#else>
    0u, 0u, 0u, 0u, 0u, 0u
</#if>
};

/* 
 * =======================================================================
 * Surface static Prototypes
 * =======================================================================
 */
static void     Surface_Service();
static void     Surface_Initialize();
static uint16_t divide(uint16_t numerator, uint16_t denominator, uint8_t exponent);
static uint16_t interpolate(uint16_t deviation1, uint16_t deviation2, uint16_t deviation3);
static uint16_t get_interpolated_position(uint8_t axis_start_segment, uint8_t num_axis_segments, uint8_t contact_middle_segment);
static uint8_t  which_segment_biggest_deviation(uint8_t which_segment_start, uint8_t how_many_segments);
static uint16_t get_axis_contact_size(uint8_t which_segment_start, uint8_t how_many_segments, uint8_t touch_centre_segment);
static uint8_t  check_for_segment_detect(uint8_t which_segment_start, uint8_t how_many_segments);
static uint16_t get_positive_deviation(uint8_t which_segment_deviation);
static uint16_t deadband_and_scale(uint16_t interpolated_position );
<#if mtouch.surface.num_contacts == 2>
static void     median_filter_init(uint8_t contact_number, uint16_t init_h_position, uint16_t init_v_position);
static uint16_t median_filter_update(uint8_t contact_number, uint8_t h_or_v, uint16_t new_calc_pos);
<#else>
static void     median_filter_init(uint16_t init_h_position, uint16_t init_v_position);
static uint16_t median_filter_update(uint8_t h_or_v, uint16_t new_calc_pos);
</#if>
<#if mtouch.surface.num_contacts == 2>
static uint8_t  check_for_twin_peaks(uint8_t contact_0, uint8_t contact_1, uint8_t merged_check);
static uint16_t filter_position_iir(uint16_t new_calc_pos, uint16_t old_stored_pos, uint8_t iir_filter_cfg);
<#else>
static void calculate_xy_positions(uint8_t middle_segment_h, uint8_t middle_segment_v);
static uint16_t calculate_axis_position(uint8_t horizontal_or_vertial, uint8_t middle_segment);
</#if>




/* 
 * =======================================================================
 * Surface Function Definitions
 * =======================================================================
 */
/*
 * =======================================================================
 * general unsigned division routine; 
 * return value - the result of the division divided by 2^exponent. 
 * In case of an overflow, 0xffffu is returned 
 * The result is rounded down according to the resolution available in the return value 
 * =======================================================================
 */
static uint16_t divide(uint16_t numerator, uint16_t denominator, uint8_t exponent)
{
  uint16_t result = 0u;
  
  /* there is one shift less than expected */
  exponent++;
  
  if(denominator != 0u)
  {
    /* scale the numerator and denominator to avoid overflows -
    * we shift them up to use the MSB of the 16 bit variables and keep track
    * of the shifts done in exponent */
    while(((numerator & 0x8000u) == 0u) && (exponent != 0u))
    {
      exponent--;
      numerator = (uint16_t)(numerator << 1);
    }
    
    while((denominator & 0x8000u) == 0u)
    {
      exponent++;
      denominator = (uint16_t)(denominator << 1);
    }
    
    /* having done the scaling, we now do the actual divide */
    while((exponent != 0u) && ((result & 0x8000u) == 0u))
    {
      result = (uint16_t)(result << 1);
      exponent--;
      if(numerator >= denominator)
      {
        numerator -= denominator;
        result++;
      }
      denominator >>= 1;
    }
  }
  else
  {
    result = 0xffffu;
  }
  
  /* if we have exponent left we have overflowed */
  if(exponent)
  {
    result = 0xffffu;
  }
  
  return result;
}

/*
 * =======================================================================
 * interpolates between three deviations
 * =======================================================================
 */
static uint16_t interpolate(uint16_t deviation1, uint16_t deviation2, uint16_t deviation3)
{
  uint16_t rtnval;
  
  if(deviation1 >= deviation3)
  {
    rtnval = (uint16_t)((deviation2 - deviation3) + (deviation1 - deviation3));
    rtnval = (uint16_t)(divide((uint16_t)(deviation2 - deviation3), rtnval, SURFACE_RESOLUTION_BITS) - SURFACE_RESOLUTION_VALUE);
  }
  else
  {
    rtnval = (uint16_t)((deviation2 - deviation1) + (deviation3 - deviation1));
    rtnval = divide((uint16_t)(deviation3 - deviation1), rtnval, SURFACE_RESOLUTION_BITS);
  }
  
  return rtnval;
}

/*
 * =======================================================================
 * Applies deadband to axis interpolation and scales
 * =======================================================================
 */
static uint16_t deadband_and_scale(uint16_t interpolated_position )
{
    uint8_t deadband_set;
    uint16_t deadband;
    uint8_t resol_bits =  ((mtouch_surface.resol_deadband & (0xF0u)) >> 4u);

    /* ADJUST THE POSITION WITH DEAD BAND AT START AND END NODES (not applicable to wheel sensor) */
    /* trap overflow due to when get zero deviations 1 and 3 on final channel of slider */
    if(interpolated_position > SURFACE_RESOLUTION_VALUE)
    {
      interpolated_position = SURFACE_RESOLUTION_VALUE;
    }

    deadband = 0u;

    if(0u != (mtouch_surface.resol_deadband & (0x0Fu)))
    {
    /* Adjust the position with deadband offset on both sides */
    deadband_set = (uint8_t)(mtouch_surface.resol_deadband & (0x0Fu));
    while(deadband_set > 0u)
    {
      deadband_set--;
      deadband += SURFACE_DEAD_BAND_ONE_PERCENT;
    }

    if(interpolated_position < deadband)
    {
      interpolated_position = 0u;
    }
    else
    {
      interpolated_position = (uint16_t)(interpolated_position - deadband);
    }

    /* scale the position according to the new range after dead band adjustment */
    /* position = (position * resolution)/(resolution-deadband) */
    /* Position scaled to compensate for deadband. New Position = (Full length position / actual_length) */
    interpolated_position = divide((uint16_t)interpolated_position, (uint16_t)(SURFACE_RESOLUTION_VALUE-(uint16_t)(deadband << 1u)), SURFACE_RESOLUTION_BITS);
    }

    /********* SCALE TO USER RESOLUTION **********************/

    /* Overflow */
    if(interpolated_position > (SURFACE_RESOLUTION_VALUE - 1u))
    {
    interpolated_position =  (SURFACE_RESOLUTION_VALUE - 1u);
    }
    interpolated_position = interpolated_position >> (SURFACE_RESOLUTION_BITS-resol_bits);

    deadband = (uint16_t)(interpolated_position & 0x0000FFFFu);
    return deadband;
}

/*
 * =======================================================================
 * Calculate contact position per axis / contact
 * =======================================================================
 */
static uint16_t get_interpolated_position(uint8_t axis_start_segment, uint8_t num_axis_segments, uint8_t contact_middle_segment)
{
    uint16_t left_signal=0u, right_signal=0u, middle_signal=0u;
    uint32_t interpolated_position = 0u;

    /****** Middle, Left and Right deviations *******/
    /* Middle segment deviation */
    middle_signal = get_positive_deviation(contact_middle_segment);

    /* Left signal */
    if(contact_middle_segment == (axis_start_segment))
    {
    /* Start segment -> No 'left' */
        left_signal = 0;
    }
    else
    {
        left_signal = get_positive_deviation(contact_middle_segment - 1u);
    }

    /* Right signal */
    if(contact_middle_segment == ((axis_start_segment) + (num_axis_segments) - (uint8_t)1u))
    {
    /* End segment -> No 'right' */
        right_signal = 0;
    }
    else
    {
        right_signal = get_positive_deviation(contact_middle_segment + 1u);
    }


    /******* CALCULATE THE POSITION WITH INTERNAL RESOLUTION SETTING (default = 12 bits) **********/
    /* Rough position */
    interpolated_position = (((uint32_t)contact_middle_segment - (uint32_t)(axis_start_segment)) << SURFACE_RESOLUTION_BITS);

    /* Interpolate the middle signal offset with left/right signals and adjust the same with the calculated position */
    interpolated_position += (uint32_t)interpolate(left_signal, middle_signal, right_signal);

    /* scale to 12-bit resolution */
    if(num_axis_segments > 2u)
    {
        interpolated_position = divide((uint16_t)interpolated_position, (uint16_t)((uint16_t)(num_axis_segments) - 1u), 0u);
    }

    interpolated_position = (uint16_t)deadband_and_scale((uint16_t)interpolated_position);

    return((uint16_t)(interpolated_position & 0x0000FFFFu));
}

<#if mtouch.surface.num_contacts != 2>
/*
 * =======================================================================
 * calculates the X/Y position from the delta values of the segments
 * =======================================================================
 */
static void calculate_xy_positions(uint8_t middle_segment_h, uint8_t middle_segment_v)
{
    mtouch_surface.h_position_abs = calculate_axis_position(HORIZONTAL,middle_segment_h);
    mtouch_surface.v_position_abs = calculate_axis_position(VERTICAL,middle_segment_v);

}

static uint16_t calculate_axis_position(uint8_t horizontal_or_vertial, uint8_t middle_segment)
{
    uint8_t iir_filter_type = 0u;
    uint8_t axis_size = *((&mtouch_surface.number_of_segments_h) + (horizontal_or_vertial<<1));
    uint8_t axis_start_segment = *((uint8_t*)(&mtouch_surface.start_segment_h) + (horizontal_or_vertial<<1));
    uint16_t position,current_position,previous_position;
    
    
    position = get_interpolated_position(axis_start_segment , axis_size, middle_segment);    
    previous_position = *((uint8_t*) (&mtouch_surface.h_position_abs) + (horizontal_or_vertial << 2));
    
    if (0u == new_contact_detected)
    {
        /* Not a new contact */
        iir_filter_type = (mtouch_surface.position_filter) & POSITION_IIR_MASK;
        
        if (0u == iir_filter_type)
        {
            /* No IIR */
        }
        else
        {
            /* IIR Enabled */
            current_position = position;
            position += previous_position;
            if (1u == iir_filter_type)
            {
                /* 75% new / 25% old */
                position += (uint16_t) (current_position << 1u);
            }
            else if (2u == iir_filter_type)
            {
                /* 50:50 */
                position = (position << 1u);
            }
            else
            {
                /* 25% new / 75% old */
                position += (uint16_t) (previous_position << 1u);
            }

            if (current_position > previous_position)
            {
                position += 2u;
            }
            else if (current_position < previous_position)
            {
                position -= 1u;
            }
            else
            {
            }
            position = (position >> 2u);
        }
    }
    else
    {  
    }
    
    return position;
}

</#if>

/*
 * =======================================================================
 * Find the segment with biggest deviation
 * =======================================================================
 */
static uint8_t which_segment_biggest_deviation(uint8_t startSegment, uint8_t segmentCount)
{
    mtouch_button_deviation_t deviation;
    int16_t found_contact_size = 0;
    uint8_t found_contact_segment = startSegment;
    uint8_t segment = startSegment;
    
    /* Iterate through all the segments in surface checking for touch detect */
    do
    {
        deviation = get_positive_deviation(segment);
        if(deviation > 0)
        {
          if(deviation > found_contact_size)
          {
            found_contact_size = deviation;
            found_contact_segment = segment;
          }
        }
        else
        {
        }

        /* Increment segment */
        segment = segment + 1u; 

    }while (segment < (startSegment + segmentCount));

    return found_contact_segment;

}

/*
 * =======================================================================
 * Median Filter
 * =======================================================================
 */
<#if mtouch.surface.num_contacts == 2>
static uint16_t median_filter_update(uint8_t contact_number, uint8_t h_or_v, uint16_t new_calc_pos)
<#else>
static uint16_t median_filter_update(uint8_t h_or_v, uint16_t new_calc_pos)
</#if>
{
  uint16_t return_this_signal;
  
  median_filter_data_buffer${contacts}[h_or_v][0] = median_filter_data_buffer${contacts}[h_or_v][1];
  median_filter_data_buffer${contacts}[h_or_v][1] = median_filter_data_buffer${contacts}[h_or_v][2];
  median_filter_data_buffer${contacts}[h_or_v][2] = new_calc_pos;
  
  if(median_filter_data_buffer${contacts}[h_or_v][2] == median_filter_data_buffer${contacts}[h_or_v][1])
  {
    return_this_signal = median_filter_data_buffer${contacts}[h_or_v][2];
  }
  else if(median_filter_data_buffer${contacts}[h_or_v][1] == median_filter_data_buffer${contacts}[h_or_v][0])
  {
    return_this_signal = median_filter_data_buffer${contacts}[h_or_v][1];
  }
  else if (median_filter_data_buffer${contacts}[h_or_v][2] == median_filter_data_buffer${contacts}[h_or_v][0])
  {
    return_this_signal = median_filter_data_buffer${contacts}[h_or_v][2];
  }
  else
  {
    /* 3 Unique values */
    if(median_filter_data_buffer${contacts}[h_or_v][2] > median_filter_data_buffer${contacts}[h_or_v][1])
    {
      /* 2 > 1 */
      if(median_filter_data_buffer${contacts}[h_or_v][1] > median_filter_data_buffer${contacts}[h_or_v][0])
      {
        /* 2 > 1 > 0 */
        return_this_signal = median_filter_data_buffer${contacts}[h_or_v][1];
      }
      else if(median_filter_data_buffer${contacts}[h_or_v][0] > median_filter_data_buffer${contacts}[h_or_v][2])
      {
        /* 0 > 2 > 1 */
        return_this_signal = median_filter_data_buffer${contacts}[h_or_v][2];
      }
      else
      {
        /* 2 > 0 > 1 */
        return_this_signal = median_filter_data_buffer${contacts}[h_or_v][0];
      }
    }
    else
    {
      /* 2 < 1 */
      if(median_filter_data_buffer${contacts}[h_or_v][1] < median_filter_data_buffer${contacts}[h_or_v][0])
      {
        /* 2 < 1 < 0 */
        return_this_signal = median_filter_data_buffer${contacts}[h_or_v][1];
      }
      else if(median_filter_data_buffer${contacts}[h_or_v][0] < median_filter_data_buffer${contacts}[h_or_v][2])
      {
        /* 0 < 2 < 1 */
        return_this_signal = median_filter_data_buffer${contacts}[h_or_v][2];
      }
      else
      {
        /* 2 < 0 < 1 */
        return_this_signal = median_filter_data_buffer${contacts}[h_or_v][0];
      }
    }
  }
  return return_this_signal;
}

/*
 * =======================================================================
 * Initialize the median filter buffer
 * =======================================================================
 */
<#if mtouch.surface.num_contacts == 2> 
static void median_filter_init(uint8_t contact_number, uint16_t init_h_position, uint16_t init_v_position)
<#else>
static void median_filter_init(uint16_t init_h_position, uint16_t init_v_position)
</#if>
{
  median_filter_data_buffer${contacts}[HORIZONTAL][0] = init_h_position;
  median_filter_data_buffer${contacts}[HORIZONTAL][1] = init_h_position;
  median_filter_data_buffer${contacts}[HORIZONTAL][2] = init_h_position;
  
  median_filter_data_buffer${contacts}[VERTICAL][0] = init_v_position;
  median_filter_data_buffer${contacts}[VERTICAL][1] = init_v_position;
  median_filter_data_buffer${contacts}[VERTICAL][2] = init_v_position;
}

<#if mtouch.surface.num_contacts == 2>
/*
 * =======================================================================
 * Interpolates between three deviations
 * =======================================================================
 */
static uint16_t filter_position_iir(uint16_t new_calc_pos, uint16_t old_stored_pos, uint8_t iir_filter_cfg)
{
  uint16_t calc_d_iir = 0u;
  if(0u == iir_filter_cfg)
  {
    /* Disabled */
    calc_d_iir = new_calc_pos;
  }
  else if(new_calc_pos == (old_stored_pos + 1u))
  {
    calc_d_iir = new_calc_pos;
  }
  else if(new_calc_pos == (old_stored_pos - 1u))
  {
    calc_d_iir = new_calc_pos;
  }
  else
  {
    /* Differing by more than 1 count */
    calc_d_iir = new_calc_pos + old_stored_pos;
    if(1u == iir_filter_cfg)
    {
      calc_d_iir += (uint16_t)(new_calc_pos << 1u);
    }
    else if(2u == iir_filter_cfg)
    {
      calc_d_iir += new_calc_pos;
      calc_d_iir += old_stored_pos;		
    }
    else
    {
      calc_d_iir += (uint16_t)(old_stored_pos << 1u);
    }
    
    if(new_calc_pos > old_stored_pos)
    {
      calc_d_iir += 2u;
    }
    else if(new_calc_pos < old_stored_pos)
    {
      calc_d_iir -= 2u;
    }
    else
    {		
    }
    
    calc_d_iir += 2u;
    calc_d_iir = (calc_d_iir >> 2u);
  }
  return calc_d_iir;
}

/*
 * =======================================================================
 * Check whether the 2 segments show 2 separate contacts
 * =======================================================================
 */
static uint8_t check_for_twin_peaks(uint8_t contact_0, uint8_t contact_1, uint8_t merged_check)
{
  uint8_t separate_contacts = 0u;
  uint16_t temp_counter_x;
  uint16_t deviation1;
  uint16_t deviation2;
  uint16_t min_between_devition = 0xFFFFu;
  
  
  /* Contact middle segment deviations */
  deviation1 =  get_positive_deviation(contact_0);
  deviation2 =  get_positive_deviation(contact_1);
  
  /* Lower of the two */
  deviation1 = MIN(deviation1, deviation2);
  
  if(contact_0 > contact_1)
  {
    for(temp_counter_x = (contact_1+1u); temp_counter_x < (contact_0); temp_counter_x++)
    {
      deviation2 = get_positive_deviation(temp_counter_x);
      if(deviation2 < min_between_devition)
      {
        min_between_devition = deviation2;
      }
    }
  }
  else
  {
    for(temp_counter_x = (contact_0+1u); temp_counter_x < (contact_1); temp_counter_x++)
    {
      deviation2 = get_positive_deviation(temp_counter_x);
      if(deviation2 < min_between_devition)
      {
        min_between_devition = deviation2;
      }
    }
  }
  
  if(0u != merged_check)
  {
    /* Unmerge: Require 12.5% valley */
    deviation1 -= (deviation1 >> 3u);
  }
  
  if(min_between_devition < deviation1)
  {
    /* Found a local minimum */
    separate_contacts = 1u;
  }
  return separate_contacts;
}
</#if>
/*
 * =======================================================================
 * Find the contact size (pair of deviations) for a given centre segment
 * =======================================================================
 */
static uint16_t get_axis_contact_size(uint8_t startSegment, uint8_t segmentCount, uint8_t middleSegment)
{
  uint16_t deviation1 = 0u;
  uint16_t deviation2 = 0u;
  uint16_t found_contact_size = 0u;
  
  /* Contact centre segment deviation */
  found_contact_size = get_positive_deviation(middleSegment);
  
  if(middleSegment > startSegment)
  {
    /* Not start segment */
    deviation1 = get_positive_deviation(middleSegment-1u);
  }
  
  if(middleSegment < (startSegment + segmentCount - (uint8_t)1u))
  {
    /* Not end segment */
    if((uint16_t)MTOUCH_Button_Reading_Get(middleSegment+1u) > (uint16_t)MTOUCH_Button_Baseline_Get(middleSegment+1u))
    {
      deviation2 = get_positive_deviation(middleSegment+1u);
    }
  }
  
  if(deviation1 > deviation2)
  {
    found_contact_size += deviation1;
  }
  else
  {
    found_contact_size += deviation2;
  }
  
  return found_contact_size;
}

/*
 * =======================================================================
 * Search for a segment in detect
 * =======================================================================
 */
static uint8_t check_for_segment_detect(uint8_t startSegment, uint8_t segmentCount)
{

    uint8_t return_value = 0u;
    uint8_t segment = startSegment;

    /* Iterate through all the segments in surface checking for touch detect */
    do
    {
        if (MTOUCH_Button_isPressed(segment))
        {
            /* Flag detection */
            return_value = 1u;
            break;
        }

        /* Increment segment */
        segment = segment + 1u;
    }
    while (segment < (startSegment + segmentCount));

    return return_value;
}

/*
 * =======================================================================
 * Returns the positive deviation for the sensor segment / 0 for negative deviation
 * =======================================================================
 */
static uint16_t get_positive_deviation(uint8_t segment)
{
    mtouch_button_deviation_t deviation;

    deviation = MTOUCH_Button_Deviation_Get(segment);
    if (deviation < 0)
    {
        deviation = 0;
    }

    return (uint16_t) deviation;
}

/*
 * =======================================================================
 * Surface Service
 * =======================================================================
 */
static void Surface_Service()
{
<#if mtouch.surface.num_contacts == 2>
  uint16_t contact_h[2] = {0,0};
  uint16_t contact_v[2] = {0,0};
  
  uint16_t contact_size = 0u;
  uint16_t other_contact_size = 0u;
  uint16_t contact_positions_temp[2];
  
  uint16_t contact_size_store[2] = {0,0};
  
  uint16_t count_thru_segments;
  uint16_t filtered_position;
  uint8_t these_contacts_merged;
  
  uint8_t surface_status = 0u;
  
  uint16_t primary_touch_segment_h, primary_touch_segment_v;
  uint16_t secondary_touch_segment_h, secondary_touch_segment_v;
  
  uint8_t axis_size;
  uint16_t axis_start_segment = 0u;
  
  uint8_t valid_contact_found;
	  
    /* Don't process if config is wrong or no qualifying contact is found */
    if(mtouch_surface.resol_deadband <= 0xCFu)
    {
   
      /* Check for detection */
      valid_contact_found = 0u;
      if(0u == (uint8_t)(mtouch_surface.surface_status & TOUCH_ACTIVE))
      {
        /* Not previously in detect, check for a segment contact on any H or V slider segment */
        valid_contact_found = check_for_segment_detect(mtouch_surface.start_segment_h, mtouch_surface.number_of_segments_h);
        if(0u == valid_contact_found)
        {
          /* No detect in h segments, try v segments */
          valid_contact_found = check_for_segment_detect(mtouch_surface.start_segment_v, mtouch_surface.number_of_segments_v);
        }
      }
      else
      {
        /* Already in detect - no segment check required */
        valid_contact_found = 1u;
      }
      
      if(0u == valid_contact_found)
      {
        /* No contact */
      }
      else
      {
        /* Contact co-ordinates */
        /* Contact centre segment positions */
        primary_touch_segment_h = which_segment_biggest_deviation(mtouch_surface.start_segment_h, mtouch_surface.number_of_segments_h);
        primary_touch_segment_v = which_segment_biggest_deviation(mtouch_surface.start_segment_v, mtouch_surface.number_of_segments_v);
        
        /* Axis contact size */
        contact_size = get_axis_contact_size(mtouch_surface.start_segment_h, mtouch_surface.number_of_segments_h, primary_touch_segment_h);
        other_contact_size = get_axis_contact_size(mtouch_surface.start_segment_v, mtouch_surface.number_of_segments_v, primary_touch_segment_v);
        
        /* Use the larger deviation pair seen on X or Y as contact size */
        if(other_contact_size < contact_size)
        {
          other_contact_size = contact_size;
        }
        
        /* Check against minimum contact threshold */
        if(other_contact_size < mtouch_surface.contact_min_threshold)
        {
          valid_contact_found = 0u;
        }
      }
      
      if(0u == valid_contact_found)
      {
        /* No contacts - clear status for both contacts */
        mtouch_surface.surface_status = 0u;
        mtouch_surface.contact_status[0] = 0u;
        mtouch_surface.contact_size[0] = 0u;
        mtouch_surface.contact_status[1] = 0u;
        mtouch_surface.contact_size[1] = 0u;
      }
      else
      {
        /* Primary contact found */
        surface_status = 1u;
        contact_size_store[0] = contact_size;
        
        /* Calculate Horizontal and Vertical positions */
        /* Horizontal: */
        axis_start_segment = mtouch_surface.start_segment_h;
        axis_size = mtouch_surface.number_of_segments_h;
        contact_h[0] =  get_interpolated_position(axis_start_segment, axis_size, primary_touch_segment_h);
        
        /* Secondary contact: Identified by a second contact_size on the same axis not overlapping the first and with a local minimum between the contacts */
        other_contact_size = 0u;
        secondary_touch_segment_h = 0u;
        /* Horizontal Search */
        if(0u == (uint8_t)(mtouch_surface.surface_status & POS_MERGED_H))
        {
          these_contacts_merged = 0u;
        }
        else
        {
          these_contacts_merged = 1u;
        }
        if(primary_touch_segment_h > (axis_start_segment + 1u))
        {
          for(count_thru_segments = axis_start_segment; count_thru_segments < (primary_touch_segment_h - 1u); count_thru_segments++)
          {
            contact_size = get_axis_contact_size(axis_start_segment, axis_size, count_thru_segments);
            if(contact_size > other_contact_size)
            {
              valid_contact_found = check_for_twin_peaks(primary_touch_segment_h, count_thru_segments, these_contacts_merged);
              if(0u != valid_contact_found)
              {
                other_contact_size = contact_size;
                secondary_touch_segment_h = count_thru_segments;
              }
            }
          }
        }
        if(primary_touch_segment_h < (axis_start_segment + axis_size - 1u))
        {
          for(count_thru_segments = (primary_touch_segment_h + 2u); count_thru_segments < (axis_start_segment + axis_size); count_thru_segments++)
          {
            contact_size = get_axis_contact_size(axis_start_segment, axis_size, count_thru_segments);
            if(contact_size > other_contact_size)
            {
              valid_contact_found = check_for_twin_peaks(primary_touch_segment_h, count_thru_segments, these_contacts_merged);
              if(0u != valid_contact_found)
              {
                other_contact_size = contact_size;
                secondary_touch_segment_h = count_thru_segments;
              }
            }
          }
        }
        
        if(other_contact_size >= mtouch_surface.contact_min_threshold)
        {
          /* Second valid contact */
          contact_h[1] =  get_interpolated_position( axis_start_segment, axis_size, secondary_touch_segment_h);
          contact_size_store[1] = other_contact_size;
          surface_status |= 2u;
        }
        else
        {
          contact_h[1] = contact_h[0];
          surface_status |= POS_MERGED_H;
        }
        
        /* Vertical: */
        axis_start_segment = mtouch_surface.start_segment_v;
        axis_size = mtouch_surface.number_of_segments_v;
        contact_v[0] =  get_interpolated_position( axis_start_segment, axis_size, primary_touch_segment_v);
        
        /* Secondary contact: Identified by a second contact_size on the same axis not overlapping the first */
        other_contact_size = 0u;
        secondary_touch_segment_v = 0u;
        /* Vertical Search */
        if(0u == (uint8_t)(mtouch_surface.surface_status & POS_MERGED_V))
        {
          these_contacts_merged = 0u;
        }
        else
        {
          these_contacts_merged = 1u;
        }
        if(primary_touch_segment_v > (axis_start_segment + 1u))
        {
          for(count_thru_segments = axis_start_segment; count_thru_segments < (primary_touch_segment_v - 2u); count_thru_segments++)
          {
            contact_size = get_axis_contact_size(axis_start_segment, axis_size, count_thru_segments);
            if(contact_size > other_contact_size)
            {
              valid_contact_found = check_for_twin_peaks(primary_touch_segment_v, count_thru_segments, these_contacts_merged);
              if(0u != valid_contact_found)
              {
                other_contact_size = contact_size;
                secondary_touch_segment_v = count_thru_segments;
              }
            }
          }
        }
        if(primary_touch_segment_v < (axis_start_segment + axis_size - 1u))
        {
          for(count_thru_segments = (primary_touch_segment_v + 2u); count_thru_segments < (axis_start_segment + axis_size); count_thru_segments++)
          {
            contact_size = get_axis_contact_size(axis_start_segment, axis_size, count_thru_segments);
            if(contact_size > other_contact_size)
            {
              valid_contact_found = check_for_twin_peaks(primary_touch_segment_v, count_thru_segments, these_contacts_merged);
              if(0u != valid_contact_found)
              {
                other_contact_size = contact_size;
                secondary_touch_segment_v = count_thru_segments;
              }
            }
          }
        }
        
        if(other_contact_size >= mtouch_surface.contact_min_threshold)
        {
          /* Second valid contact */
          contact_v[1] = get_interpolated_position(axis_start_segment, axis_size, secondary_touch_segment_v);
          if(other_contact_size > contact_size_store[1])
          {
            contact_size_store[1] = other_contact_size;
          }
          surface_status |= 4u;
        }
        else
        {
          contact_v[1] = contact_v[0];
          surface_status |= POS_MERGED_V;
        }
        
        /* Variable re-use: axis_size for IIR Config */
        axis_size = (mtouch_surface.position_filter & POSITION_IIR_MASK);
        
        /* Match up the contacts + position filtering */
        if(0u == (uint8_t)(mtouch_surface.surface_status & TOUCH_ACTIVE))
        {
          /* Previously no contact -> Primary = Contact 0 */
          mtouch_surface.contact_status[0] = TOUCH_ACTIVE;
          mtouch_surface.h_position_abs[0] = contact_h[0];
          mtouch_surface.h_position[0] = contact_h[0];
          h_history[0] = contact_h[0];
          mtouch_surface.v_position_abs[0] = contact_v[0];
          mtouch_surface.v_position[0] = contact_v[0];
          v_history[0] = contact_v[0];
          mtouch_surface.contact_size[0] = contact_size_store[0];
          
          median_filter_init(0u, contact_h[0], contact_v[0]);
          
          if(0u == (uint8_t)(surface_status & 0x06u))
          {
            /* No second contact found */
            mtouch_surface.contact_status[1] = 0u;
            mtouch_surface.contact_size[1] = 0u;
          }
          else
          {
            /* Two - simultaneous - new contacts -> Secondary = Contact 1*/
            mtouch_surface.contact_size[1] = contact_size_store[1];
            mtouch_surface.contact_status[1] = TOUCH_ACTIVE;
            mtouch_surface.h_position_abs[1] = contact_h[1];
            mtouch_surface.h_position[1] = contact_h[1];
            h_history[1] = contact_h[1];
            mtouch_surface.v_position_abs[1] = contact_v[1];
            mtouch_surface.v_position[1] = contact_v[1];
            v_history[1] = contact_v[1];
            
            median_filter_init(1u, contact_h[1], contact_v[1]);
          } /* Two new contacts */
        } /* No previous contact */
        else
        {
          /* At least one previously in detect -> Predict contact location(s) */
          /* contact_size reused for max reported position */
          contact_size = ((uint16_t)1u << (SURFACE_RESOLUTION(mtouch_surface.resol_deadband & 0xF0u)));
          contact_size--;
          
          for(count_thru_segments = 0u; count_thru_segments < SURFACE_NUM_CONTACTS; count_thru_segments++)
          {
            if(0u == (uint8_t)(mtouch_surface.contact_status[count_thru_segments] & TOUCH_ACTIVE))
            {
              /* This one not already in detect */
              h_extrapolated[count_thru_segments] = 65535u;
              v_extrapolated[count_thru_segments] = 65535u;
            }
            else
            {
              /* Last position */
              filtered_position = mtouch_surface.h_position[count_thru_segments];
              
              /* Last move */
              other_contact_size = DIFFERENCE(filtered_position,h_history[count_thru_segments]);
              if(filtered_position > h_history[count_thru_segments])
              {
                if((filtered_position + other_contact_size) < contact_size)
                {
                  filtered_position += other_contact_size;
                }
                else
                {
                  filtered_position = contact_size;
                }
              }
              else
              {
                if(filtered_position > other_contact_size)
                {
                  filtered_position -= other_contact_size;
                }
                else
                {
                  filtered_position = 0u;
                }
              }
              h_extrapolated[count_thru_segments] = filtered_position;
              
              /* Last position */
              filtered_position = mtouch_surface.v_position[count_thru_segments];
              
              /* Last move */
              other_contact_size = DIFFERENCE(filtered_position,v_history[count_thru_segments]);
              if(filtered_position > v_history[count_thru_segments])
              {
                if((filtered_position + other_contact_size) < contact_size)
                {
                  filtered_position += other_contact_size;
                }
                else
                {
                  filtered_position = contact_size;
                }
              }
              else
              {
                if(filtered_position > other_contact_size)
                {
                  filtered_position -= other_contact_size;
                }
                else
                {
                  filtered_position = 0u;
                }
              }
              v_extrapolated[count_thru_segments] = filtered_position;
            }
          }
          
          /* Match contact(s) to extrapolated co-ordinates */
          if(0u != (surface_status & 0x06u))
          {
            /* 2 current contacts - match by location */
            mtouch_surface.contact_size[0] = contact_size_store[0];
            mtouch_surface.contact_size[1] = contact_size_store[1];
            if(mtouch_surface.contact_status[1] == 0u)
            {
              /* Persistent contact 0 - minimize distance (reuse variables contact_size, other_contact_size) */
              contact_size = DIFFERENCE(h_extrapolated[0], contact_h[0]);
              other_contact_size = DIFFERENCE(h_extrapolated[0], contact_h[1]);
              if(contact_size > other_contact_size)
              {
                /* Mixed */
                mtouch_surface.h_position_abs[0] = filter_position_iir(contact_h[1], mtouch_surface.h_position_abs[0], axis_size);
                mtouch_surface.h_position_abs[1] = contact_h[0];
              }
              else
              {
                mtouch_surface.h_position_abs[0] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[0], axis_size);
                mtouch_surface.h_position_abs[1] = contact_h[1];
              }
              
              contact_size = DIFFERENCE(v_extrapolated[0], contact_v[0]);
              other_contact_size = DIFFERENCE(v_extrapolated[0], contact_v[1]);
              if(contact_size > other_contact_size)
              {
                /* Mixed */
                mtouch_surface.v_position_abs[0] = filter_position_iir(contact_v[1], mtouch_surface.v_position_abs[0], axis_size);
                mtouch_surface.v_position_abs[1] = contact_v[0];
              }
              else
              {
                mtouch_surface.v_position_abs[0] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[0], axis_size);
                mtouch_surface.v_position_abs[1] = contact_v[1];
              }
              
              /* Contact 1 now in detect too */
              mtouch_surface.contact_status[1] = TOUCH_ACTIVE;
              h_history[1] = mtouch_surface.h_position_abs[1];
              h_extrapolated[1] = mtouch_surface.h_position_abs[1];
              mtouch_surface.h_position[1] = mtouch_surface.h_position_abs[1];
              v_history[1] = mtouch_surface.v_position_abs[1];
              v_extrapolated[1] = mtouch_surface.v_position_abs[1];
              mtouch_surface.v_position[1] = mtouch_surface.v_position_abs[1];
              median_filter_init(1u, mtouch_surface.h_position_abs[1], mtouch_surface.v_position_abs[1]);
            }
            else if(mtouch_surface.contact_status[0] == 0u)
            {
              /* Persistent contact 1 - minimize distance */
              contact_size = DIFFERENCE(h_extrapolated[1], contact_h[1]);
              other_contact_size = DIFFERENCE(h_extrapolated[1], contact_h[0]);
              if(contact_size > other_contact_size)
              {
                /* Mixed */
                mtouch_surface.h_position_abs[0] = contact_h[1];
                mtouch_surface.h_position_abs[1] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[1], axis_size);
              }
              else
              {
                mtouch_surface.h_position_abs[0] = contact_h[0];
                mtouch_surface.h_position_abs[1] = filter_position_iir(contact_h[1], mtouch_surface.h_position_abs[1], axis_size);
              }
              contact_size = DIFFERENCE(v_extrapolated[1], contact_v[1]);
              other_contact_size = DIFFERENCE(v_extrapolated[1], contact_v[0]);
              if(contact_size > other_contact_size)
              {
                /* Mixed */
                mtouch_surface.v_position_abs[0] = contact_v[1];
                mtouch_surface.v_position_abs[1] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[1], axis_size);
              }
              else
              {
                mtouch_surface.v_position_abs[0] = contact_v[0];
                mtouch_surface.v_position_abs[1] = filter_position_iir(contact_v[1], mtouch_surface.v_position_abs[1], axis_size);
              }
              
              /* Contact 0 now in detect too */
              mtouch_surface.contact_status[0] = TOUCH_ACTIVE;
              /* Pre-load filter */
              h_history[0] = mtouch_surface.h_position_abs[0];
              mtouch_surface.h_position[0] = mtouch_surface.h_position_abs[0];
              h_extrapolated[0] = mtouch_surface.h_position_abs[0];
              v_history[0] = mtouch_surface.v_position_abs[0];
              mtouch_surface.v_position[0] = mtouch_surface.v_position_abs[0];
              v_extrapolated[0] = mtouch_surface.v_position_abs[0];
              median_filter_init(0u, mtouch_surface.h_position_abs[0], mtouch_surface.v_position_abs[0]);
            }
            else
            {
              /* Both previously in detect - Minimize total distance h and v (reuse variables contact size, other_contact_size) */
              contact_size = DIFFERENCE(h_extrapolated[0], contact_h[0]);
              contact_size += DIFFERENCE(h_extrapolated[1], contact_h[1]);
              
              other_contact_size = DIFFERENCE(h_extrapolated[0], contact_h[1]);
              other_contact_size += DIFFERENCE(h_extrapolated[1], contact_h[0]);
              
              if(other_contact_size < contact_size)
              {
                /* Mixed */
                mtouch_surface.h_position_abs[0] = filter_position_iir(contact_h[1], mtouch_surface.h_position_abs[0], axis_size);
                mtouch_surface.h_position_abs[1] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[1], axis_size);
              }
              else
              {
                mtouch_surface.h_position_abs[0] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[0], axis_size);
                mtouch_surface.h_position_abs[1] = filter_position_iir(contact_h[1], mtouch_surface.h_position_abs[1], axis_size);
              }
              
              contact_size = DIFFERENCE(v_extrapolated[0], contact_v[0]);
              contact_size += DIFFERENCE(v_extrapolated[1], contact_v[1]);
              
              other_contact_size = DIFFERENCE(v_extrapolated[0], contact_v[1]);
              other_contact_size += DIFFERENCE(v_extrapolated[1], contact_v[0]);
              
              if(other_contact_size < contact_size)
              {
                /* Mixed */
                mtouch_surface.v_position_abs[0] = filter_position_iir(contact_v[1], mtouch_surface.v_position_abs[0], axis_size);
                mtouch_surface.v_position_abs[1] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[1], axis_size);
              }
              else
              {
                mtouch_surface.v_position_abs[0] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[0], axis_size);
                mtouch_surface.v_position_abs[1] = filter_position_iir(contact_v[1], mtouch_surface.v_position_abs[1], axis_size);
              }
            }
          }
          else
          {
            /* Now 1 contact */
            if(mtouch_surface.contact_status[1] == 0u)
            {
              /* Persistent contact 0 */
              mtouch_surface.contact_size[0] = contact_size_store[0];
              mtouch_surface.h_position_abs[0] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[0], axis_size);
              mtouch_surface.v_position_abs[0] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[0], axis_size);
            }
            else if(mtouch_surface.contact_status[0] == 0u)
            {
              /* Persistent contact 1 */
              mtouch_surface.contact_size[1] = contact_size_store[0];
              mtouch_surface.h_position_abs[1] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[1], axis_size);
              mtouch_surface.v_position_abs[1] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[1], axis_size);
            }
            else
            {
              /* Both were in detect, now just one - identify by location */
              contact_size = DIFFERENCE(h_extrapolated[0], contact_h[0]);
              contact_size += DIFFERENCE(v_extrapolated[0], contact_v[0]);
              
              other_contact_size = DIFFERENCE(h_extrapolated[1], contact_h[0]);
              other_contact_size += DIFFERENCE(v_extrapolated[1], contact_v[0]);
              
              if(other_contact_size < contact_size)
              {
                /* Contact 1 remains in detect */
                mtouch_surface.h_position_abs[1] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[1], axis_size);
                mtouch_surface.v_position_abs[1] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[1], axis_size);
                mtouch_surface.contact_size[1] = contact_size_store[0];
                mtouch_surface.contact_status[0] = 0u;
              } /* Contact 1 remains in detect */
              else
              {
                /* Contact 0 remains in detect */
                mtouch_surface.h_position_abs[0] = filter_position_iir(contact_h[0], mtouch_surface.h_position_abs[0], axis_size);
                mtouch_surface.v_position_abs[0] = filter_position_iir(contact_v[0], mtouch_surface.v_position_abs[0], axis_size);
                mtouch_surface.contact_size[0] = contact_size_store[0];
                mtouch_surface.contact_status[1] = 0u;
              } /* Contact 0 remains in detect */
            } /* Both were in detect, now just one - identify by location */
          } /* Now 1 contact */
          
          /* Position Filter + Hysteresis */
          for(these_contacts_merged = 0u; these_contacts_merged < SURFACE_NUM_CONTACTS; these_contacts_merged++)
          {
            if(0u == (uint8_t)(mtouch_surface.contact_status[these_contacts_merged] & TOUCH_ACTIVE))
            {
              /* This contact not in detect */
              mtouch_surface.contact_size[these_contacts_merged] = 0u;
            }
            else
            {
              contact_positions_temp[0] = mtouch_surface.h_position[these_contacts_merged];
              contact_positions_temp[1] = mtouch_surface.v_position[these_contacts_merged];
              
              filtered_position = mtouch_surface.h_position_abs[these_contacts_merged];
              
              /* Variable re-use: axis_size for Median Config */
              axis_size = (mtouch_surface.position_filter & POSITION_MEDIAN_ENABLE);
              if(0u != axis_size)
              {
                filtered_position = median_filter_update(these_contacts_merged, HORIZONTAL, filtered_position);
              }
              
              if(filtered_position < mtouch_surface.h_position[these_contacts_merged])
              {
                if(0u == (uint8_t)(mtouch_surface.contact_status[these_contacts_merged] & POSITION_H_DEC))
                {
                  /* First move 'Left' - Apply Hysteresis */
                  if((mtouch_surface.h_position[these_contacts_merged] - filtered_position) > mtouch_surface.position_hysteresis)
                  {
                    mtouch_surface.h_position[these_contacts_merged] = filtered_position;
                    mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_H_DEC);
                    mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_H_INC);
                  }
                  else
                  {
                  }
                }
                else
                {
                  mtouch_surface.h_position[these_contacts_merged] = filtered_position;
                  mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_H_DEC);
                  mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_H_INC);
                }
              } /* filtered_position < surface_contact_data[these_contacts_merged].h_position */
              else
              {
                if(0u == (uint8_t)(mtouch_surface.contact_status[these_contacts_merged] & POSITION_H_INC))
                {
                  /* First move 'Right' - Apply Hysteresis */
                  if((filtered_position - mtouch_surface.h_position[these_contacts_merged]) > mtouch_surface.position_hysteresis)
                  {
                    mtouch_surface.h_position[these_contacts_merged] = filtered_position;
                    mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_H_INC);
                    mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_H_DEC);
                  }
                  else
                  {
                  }
                }
                else
                {
                  mtouch_surface.h_position[these_contacts_merged] = filtered_position;
                  mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_H_INC);
                  mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_H_DEC);
                }
              } /* filtered_position >= mtouch_surface.h_position[these_contacts_merged] */
              
              filtered_position = mtouch_surface.v_position_abs[these_contacts_merged];
              
              /* Variable re-use: axis_size for Median Config */
              axis_size = (mtouch_surface.position_filter & POSITION_MEDIAN_ENABLE);
              if(0u != axis_size)
              {
                filtered_position = median_filter_update(these_contacts_merged, VERTICAL, filtered_position);
              }
              
              if(filtered_position < mtouch_surface.v_position[these_contacts_merged])
              {
                if(0u == (uint8_t)(mtouch_surface.contact_status[these_contacts_merged] & POSITION_V_DEC))
                {
                  /* First move 'Left' - Apply Hysteresis */
                  if((mtouch_surface.v_position[these_contacts_merged] - filtered_position) > mtouch_surface.position_hysteresis)
                  {
                    mtouch_surface.v_position[these_contacts_merged] = filtered_position;
                    mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_V_DEC);
                    mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_V_INC);
                  }
                  else
                  {
                  }
                }
                else
                {
                  mtouch_surface.v_position[these_contacts_merged] = filtered_position;
                  mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_V_DEC);
                  mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_V_INC);
                }
              } /* filtered_position < surface_contact_data[these_contacts_merged].h_position */
              else
              {
                if(0u == (uint8_t)(mtouch_surface.contact_status[these_contacts_merged] & POSITION_V_INC))
                {
                  /* First move 'Right' - Apply Hysteresis */
                  if((filtered_position - mtouch_surface.v_position[these_contacts_merged]) > mtouch_surface.position_hysteresis)
                  {
                    mtouch_surface.v_position[these_contacts_merged] = filtered_position;
                    mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_V_INC);
                    mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_V_DEC);
                  }
                  else
                  {
                  }
                }
                else
                {
                  mtouch_surface.v_position[these_contacts_merged] = filtered_position;
                  mtouch_surface.contact_status[these_contacts_merged] |= (POSITION_CHANGE | POSITION_V_INC);
                  mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~(POSITION_V_DEC);
                }
              } /* filtered_position >= mtouch_surface.v_position[these_contacts_merged] */
              
              if(contact_positions_temp[0] == mtouch_surface.h_position[these_contacts_merged])
              {
                if(contact_positions_temp[1] == mtouch_surface.v_position[these_contacts_merged])
                {
                  mtouch_surface.contact_status[these_contacts_merged] &= (uint8_t)~POSITION_CHANGE;
                }
              }								
            } /* This contact in detect */
          } /* For each contact */
        } /* Previous detection */
        h_history[0] = mtouch_surface.h_position[0];
        h_history[1] = mtouch_surface.h_position[1];
        v_history[0] = mtouch_surface.v_position[0];
        v_history[1] = mtouch_surface.v_position[1];
      } /* Valid contact(s) */
    }
    
    /* Get updated status information */
    if(0u != (uint8_t)(surface_status & TOUCH_ACTIVE))
    {
      mtouch_surface.surface_status = (TOUCH_ACTIVE | SURFACE_REBURST);
    }
    
    if(0x00u != (surface_status & 0x06u))
    {
      /* Only when 2 contacts present */
      mtouch_surface.surface_status |= (uint8_t)(surface_status & (POS_MERGED_H | POS_MERGED_V));
    }
 
<#else>
  
    uint16_t contact_size = 0u;
    uint8_t contact_status = 0u;
    uint8_t median_filter_enabled = 0u;
    uint16_t filtered_position;
    uint16_t touch_segment_h, touch_segment_v;
    uint8_t valid_contact_found;

    /* Don't process if config is wrong or no qualifying contact is found */
    if (mtouch_surface.resol_deadband <= 0xCFu)
    {

        /* Check for detection */
        valid_contact_found = 0u;

        /* check for a segment contact on any H or V slider segment */
        valid_contact_found = check_for_segment_detect(mtouch_surface.start_segment_h, mtouch_surface.number_of_segments_h);
        if (0u == valid_contact_found)
        {
            /* No detect in h segments, try v segments */
            valid_contact_found = check_for_segment_detect(mtouch_surface.start_segment_v, mtouch_surface.number_of_segments_v);
        }
        /* Contact co-ordinates */
        /* Contact centre segment positions */
        touch_segment_h = which_segment_biggest_deviation(mtouch_surface.start_segment_h, mtouch_surface.number_of_segments_h);
        touch_segment_v = which_segment_biggest_deviation(mtouch_surface.start_segment_v, mtouch_surface.number_of_segments_v);

        /* Contact tracking - after segment detection moves we want to track a continuous contact */
        contact_size = get_axis_contact_size(mtouch_surface.start_segment_h, mtouch_surface.number_of_segments_h, touch_segment_h);
        contact_size += get_axis_contact_size(mtouch_surface.start_segment_v, mtouch_surface.number_of_segments_v, touch_segment_v);

        /* Use the larger deviation pair seen on X or Y as contact size */
        if (0u != (uint8_t)(mtouch_surface.surface_status & TOUCH_ACTIVE))
        {
            /* Contact size with 50:50 IIR - ((Previous + Current)/2)*/
            contact_size += (mtouch_surface.contact_size);
            mtouch_surface.contact_size = (contact_size >> 1u);
        }

        /* Check against minimum contact threshold */
        if (contact_size < mtouch_surface.contact_min_threshold)
        {
            /* Contact too small */
            valid_contact_found = 0u;
        }
        else
        {
            /* No segments in detect now, contact not found */
            if (0u == (uint8_t)(mtouch_surface.surface_status & TOUCH_ACTIVE))
            {
                /* Not a persistent contact */
            }
            else
            {
                /* Persistent contact */
                valid_contact_found = 1u;
            }
        }

        if (0u == valid_contact_found)
        {
            /* Do nothing */
        }
        else
        {
            /* Found a contact */
            contact_status = (SURFACE_REBURST | TOUCH_ACTIVE);

            if (0u == (uint8_t)(mtouch_surface.surface_status & TOUCH_ACTIVE))
            {
                new_contact_detected = 1u;
            }
            else
            {
                new_contact_detected = 0u;
            }

            /* Calculate Positions */
            calculate_xy_positions(touch_segment_h, touch_segment_v);

            /* Get the difference between current and previous positions */
            if (0u != new_contact_detected)
            {
                /* New contact -> No position filtering or Hysteresis check */
                mtouch_surface.h_position = mtouch_surface.h_position_abs;
                mtouch_surface.v_position = mtouch_surface.v_position_abs;
                median_filter_init(mtouch_surface.h_position_abs, mtouch_surface.v_position_abs);
            }
            else
            {
                /* Persistent contact -> Median filter + Hyst */
                median_filter_enabled = mtouch_surface.position_filter;
                median_filter_enabled &= POSITION_MEDIAN_ENABLE;

                /* Horizontal */
                if (0u == median_filter_enabled)
                {
                    /* No median filter */
                    filtered_position = mtouch_surface.h_position_abs;
                }
                else
                {
                    /* Median */
                    filtered_position = median_filter_update(HORIZONTAL, mtouch_surface.h_position_abs);
                }

                if (filtered_position < mtouch_surface.h_position)
                {
                    if (0u == (uint8_t)(mtouch_surface.surface_status & POSITION_H_DEC))
                    {
                        /* First move 'Left' */
                        if ((mtouch_surface.h_position - filtered_position) > mtouch_surface.position_hysteresis)
                        {
                            mtouch_surface.h_position = filtered_position;
                            contact_status |= (POSITION_CHANGE | POSITION_H_DEC);
                        }
                        else
                        {
                            contact_status |= (uint8_t) (mtouch_surface.surface_status & POSITION_H_INC);
                        }
                    }
                    else
                    {
                        mtouch_surface.h_position = filtered_position;
                        contact_status |= (POSITION_CHANGE | POSITION_H_DEC);
                    }
                }
                else
                {
                    if (0u == (uint8_t)(mtouch_surface.surface_status & POSITION_H_INC))
                    {
                        /* First move 'Right' */
                        if ((filtered_position - mtouch_surface.h_position) > mtouch_surface.position_hysteresis)
                        {
                            mtouch_surface.h_position = filtered_position;
                            contact_status |= (POSITION_CHANGE | POSITION_H_INC);
                        }
                        else
                        {
                            contact_status |= (uint8_t) (mtouch_surface.surface_status & (POSITION_H_DEC));
                        }
                    }
                    else
                    {
                        mtouch_surface.h_position = filtered_position;
                        contact_status |= (POSITION_CHANGE | POSITION_H_INC);
                    }
                }
                /* Vertical */
                if (0u == median_filter_enabled)
                {
                    /* No median filter */
                    filtered_position = mtouch_surface.v_position_abs;
                }
                else
                {
                    /* Median */
                    filtered_position = median_filter_update(VERTICAL, mtouch_surface.v_position_abs);
                }

                if (filtered_position < mtouch_surface.v_position)
                {
                    if (0u == (uint8_t)(mtouch_surface.surface_status & POSITION_V_DEC))
                    {
                        /* First move 'Down' */
                        if ((mtouch_surface.v_position - filtered_position) > mtouch_surface.position_hysteresis)
                        {
                            mtouch_surface.v_position = filtered_position;
                            contact_status |= (POSITION_CHANGE | POSITION_V_DEC);
                        }
                        else
                        {
                            contact_status |= (uint8_t) (mtouch_surface.surface_status & (POSITION_V_INC));
                        }
                    }
                    else
                    {
                        mtouch_surface.v_position = filtered_position;
                        contact_status |= (POSITION_CHANGE | POSITION_V_DEC);
                    }
                }
                else
                {
                    if (0u == (uint8_t)(mtouch_surface.surface_status & POSITION_V_INC))
                    {
                        /* First move 'Up' */
                        if ((filtered_position - mtouch_surface.v_position) > mtouch_surface.position_hysteresis)
                        {
                            mtouch_surface.v_position = filtered_position;
                            contact_status |= (POSITION_CHANGE | POSITION_V_INC);
                        }
                        else
                        {
                            contact_status |= (uint8_t) (mtouch_surface.surface_status & (POSITION_V_DEC));
                        }
                    }
                    else
                    {
                        mtouch_surface.v_position = filtered_position;
                        contact_status |= (POSITION_CHANGE | POSITION_V_INC);
                    }
                }
            }
        } /* Valid contact */
    }
  
    /* Set updated status information */
    mtouch_surface.surface_status = contact_status;
    
</#if>
} /* End of Service Routine */

/*
 * =======================================================================
 * Surface Initialize
 * =======================================================================
 */
static void Surface_Initialize()
{
<#if mtouch.surface.num_contacts == 2> 
    mtouch_surface.surface_status = 0u;     
    mtouch_surface.contact_status[0] = 0u;
    mtouch_surface.h_position_abs[0] = 0u;
    mtouch_surface.h_position[0] = 0u;
    mtouch_surface.v_position_abs[0] = 0u;
    mtouch_surface.v_position[0] = 0u;
    mtouch_surface.contact_size[0] = 0u;

    mtouch_surface.contact_status[1] = 0u;
    mtouch_surface.h_position_abs[1] = 0u;
    mtouch_surface.h_position[1] = 0u;
    mtouch_surface.v_position_abs[1] = 0u;
    mtouch_surface.v_position[1] = 0u;
    mtouch_surface.contact_size[1] = 0u;
<#else>
    mtouch_surface.surface_status = 0u;
    mtouch_surface.h_position_abs = 0u;
    mtouch_surface.h_position = 0u;
    mtouch_surface.v_position_abs = 0u;
    mtouch_surface.v_position = 0u;
    mtouch_surface.contact_size = 0u;
</#if>
}

/*
 * =======================================================================
 * Surface Initialize
 * =======================================================================
 */
void MTOUCH_Surface_InitializeAll(void)
{
    /* Initialize the surface module */
    Surface_Initialize();
}

/*
 * =======================================================================
 * Surface Service
 * =======================================================================
 */
void MTOUCH_Surface_ServiceAll(void)
{
    /* Execute the surface module */
    Surface_Service();
}

/*
 * =======================================================================
 * Get Surface position 
 * =======================================================================
 */
<#if mtouch.surface.num_contacts == 2>
uint16_t MTOUCH_Surface_Position_Get(uint8_t ver_or_hor, uint8_t contact ) /* Global */
{
    if(contact < SURFACE_NUM_CONTACTS)
    {
        if (ver_or_hor == HORIZONTAL) {
            return  mtouch_surface.h_position[contact];
        }else if (ver_or_hor == VERTICAL) {
            return  mtouch_surface.v_position[contact];
        }
        else 
            return 0u;
    }  
    else 
            return 0u;
}
<#else>
uint16_t MTOUCH_Surface_Position_Get(uint8_t ver_or_hor ) /* Global */
{

    if (ver_or_hor == HORIZONTAL) {
        return  mtouch_surface.h_position;
    }else if (ver_or_hor == VERTICAL) {
        return  mtouch_surface.v_position;
    }
    else 
        return 0u;

}
</#if>

<#if mtouch.surface.num_contacts == 2>
/*
 * =======================================================================
 * Get Surface Contact status
 * =======================================================================
 */
uint8_t MTOUCH_Surface_Contact_Status_Get(uint8_t contact) 
{
    if(contact < SURFACE_NUM_CONTACTS)
        return  mtouch_surface.contact_status[contact];
    else 
        return  0u;   
}
</#if>

/*
 * =======================================================================
 * Get Surface status
 * =======================================================================
 */
uint8_t MTOUCH_Surface_Status_Get(void) 
{
    return mtouch_surface.surface_status;
}

/*
 * =======================================================================
 * Get Surface Resolution
 * =======================================================================
 */
uint8_t MTOUCH_Surface_Resolution_Get(void) 
{
    return SURFACE_RESOLUTION(mtouch_surface.resol_deadband);
}

/*
 * =======================================================================
 * Set Surface Resolution
 * =======================================================================
 */
void MTOUCH_Surface_Resolution_Set(uint8_t resol) 
{
    uint8_t db = SURFACE_DEADBAND(mtouch_surface.resol_deadband);
    mtouch_surface.resol_deadband = SURFACE_RESOL_DEADBAND(resol,db);
}

/*
 * =======================================================================
 * Get Surface Deadband
 * =======================================================================
 */
uint8_t MTOUCH_Surface_Deadband_Get(void) 
{
    return SURFACE_DEADBAND(mtouch_surface.resol_deadband);
}

/*
 * =======================================================================
 * Set Surface Deadband
 * =======================================================================
 */
void MTOUCH_Surface_Deadband_Set(uint8_t db) 
{
    uint8_t resol = SURFACE_RESOLUTION(mtouch_surface.resol_deadband);
    mtouch_surface.resol_deadband = SURFACE_RESOL_DEADBAND(resol,db);
}


