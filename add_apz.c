//v1.00

//addition of two arbitrary precision integers

//includes

#include <stdint.h>
#include "apz.h"

//global variables

uint32_t limbs; //sign and number of limbs of sum/difference

uint32_t m;
uint32_t n;
uint32_t * u;
uint32_t * v;

uint32_t uSign;
uint32_t vSign;

//assembly prototypes

extern uint32_t add_non_negative_apz(uint32_t, uint32_t *, uint32_t, uint32_t *);
extern uint32_t subtract_non_negative_apz(uint32_t, uint32_t *, uint32_t, uint32_t *);

int main (void) {
    m = four[0];                                    
    u = &four[1];
	
    n = nine[0] | 0x80000000; //set MSB of sign/number of limbs word to make negative
    v = &nine[1];
    
    uSign = m & 0x80000000;
    vSign = n & 0x80000000;
                  
    if (uSign && vSign) limbs = add_non_negative_apz(m & 0x7FFFFFFF, u, n & 0x7FFFFFFF, v) | 0x80000000;  //both addends negative -> u+v = -(u'+v'), u' = -u, v' = -v  
    else {
      if (uSign) limbs = subtract_non_negative_apz(m & 0x7FFFFFFF, u, n, v) ^ 0x80000000; //u negative, v positive -> -u'+v = -(u'-v)
      else {
        if (vSign) limbs = subtract_non_negative_apz(m, u, n & 0x7FFFFFFF, v);  //u positive, v negative -> u+v = u-v'
        else limbs = add_non_negative_apz(m, u, n, v);  //u positive, v positive 
      }
    } 
            
    while (1);                           
}
