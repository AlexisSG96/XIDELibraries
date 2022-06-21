#include "SECURE4_app.h"
#include "../CryptoAuthenticationLibrary/cryptoauthlib_config.h"
#include "../CryptoAuthenticationLibrary/cryptoauthlib.h"
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>




void SECURE4_Initialize(void){
    
    client_provision();
    
}

void SECURE4_Example(void){
    
    uint8_t random_number[32];
    uint8_t serial_number[9];
    
    SECURE4_Initialize();
        
    int i = 0;
    int j = 0;
    int loop = 10;

    while(loop--)
    {
        atcab_read_serial_number(serial_number);
        
        printf("Serial Number: \n");
         
        while (i < 9) {
                printf("%02X ", serial_number[i]);
                i++;
            }
            printf("\n");
            printf("\n");
            
            i = 0;
            
        atcab_random(&random_number);

        printf("Generated 32-byte Random Number: \n");
         
        while (i < 32) {
            while (j < 4) {
                printf("0x%02X ", random_number[i]);
                j++;
                i++;
            }
            printf("\n");
            j = 0;
        }
        printf("\n");
        i = 0;
        j = 0;
        
    }
    
    
    printf("\n");
    
}


