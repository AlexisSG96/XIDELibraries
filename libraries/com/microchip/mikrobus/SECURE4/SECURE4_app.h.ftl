#include <stdint.h>

void SECURE4_Initialize(void); 

void SECURE4_Example(void);

// Generate random challenge from device
uint8_t SECURE4_genChallenge(uint8_t *challenge);

// Sign the challenge with the device's private key
uint8_t SECURE4_genResponse(uint8_t keySlot, uint8_t *challenge, uint8_t *signedResponse); 

// Verify the signed challenge that with the public key
void SECURE4_verifyResponse(uint8_t keySlot, uint8_t *challenge, uint8_t *signedResponse);



