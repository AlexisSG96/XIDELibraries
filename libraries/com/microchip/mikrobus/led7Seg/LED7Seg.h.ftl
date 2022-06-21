 /*
 <#include "MicrochipDisclaimer.ftl">
 */

#ifndef LED7Seg_H
#define	LED7Seg_H

#include <stdint.h>

// The 7seg displays define their segments as a, b, c, d, e, f, g, and dp  _a_
//                                                                       f|   |b
//                                                                        |_g_|
//                                                                       e|   |c
// Each bit of the uin8_t corresponds to a segment                        |_d_|.dp
   
void LED7seg_Write(uint8_t tens, uint8_t ones);

#endif