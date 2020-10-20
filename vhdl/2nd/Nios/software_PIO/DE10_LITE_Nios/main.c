/*
 * "KEY/SW/HEX/LEDR" example.
 */

#include <stdio.h>
#include "terasic_includes.h"
#include "system.h"
#include "alt_types.h"

int number[10] = {0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00100111, 0b01111111, 0b01101111};

int main()
{
  int count = 0;

  printf("KEY/SW/HEX/LEDR Demo! KEY0 Start, KEY1 End.\n");
  while (IORD(KEY_BASE, 0) & 0x1) {  // KEY0 Start
	IOWR(HEX_BASE, 0, 0);  // HEX Clear
	IOWR(LEDR_BASE, 0, 0); // LEDR Clear
  }
  do {
	if (count>10) count=0;
	IOWR(HEX_BASE, 0, number[count++]);  // HEX<-SW
	IOWR(LEDR_BASE, 0, IORD(SW_BASE, 0));  // LEDR<-count
	usleep(100*1000);  // 1us Sleep
  } while (IORD(KEY_BASE, 0) & 0x2);  // KEY1 End
  return 0;
}
