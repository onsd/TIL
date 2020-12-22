/*
 * "KEY/SW/HEX/LEDR" example.
 */

#include <stdio.h>
#include "terasic_includes.h"
#include "system.h"
#include "alt_types.h"

int number[10] = {0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00100111, 0b01111111, 0b01101111};

int count = 0;
bool down = 0;

int main()
{
	printf("KEY/SW/HEX/LEDR Demo! KEY0 Start, KEY1 End.\n");
	while(1){
		/*
		while (IORD(KEY_BASE, 0) & 0x01) {  // KEY0 Start
			checkSW();
			IOWR(HEX_BASE, 0, createNumber(count));  // HEX<-SW
			IOWR(LEDR_BASE, 0, IORD(SW_BASE, 0));  // LEDR<-count
		}
		printf("count start count: %d\n", count);
		usleep(100*1000);

		while (IORD(KEY_BASE, 0) & 0x01){  // KEY0 End
			IOWR(HEX_BASE, 0, createNumber(down ? count-- : count++));  // HEX<-SW
			IOWR(LEDR_BASE, 0, IORD(SW_BASE, 0));  // LEDR<-count
			usleep(100*100); // wait for 0.01 sec
		}

		usleep(100*1000);
		printf("count stop count: %d\n", count);
		*/
		while (IORD(KEY_BASE, 0) & 0x01) {  // KEY0 Start

		}
		printf("value 0b01\n");
		IOWR(HEX_BASE, 0, 0b01);
		usleep(100*1000);
		while (IORD(KEY_BASE, 0) & 0x01){  // KEY0 End

		}
		printf("value 0b00000000\n");
		IOWR(HEX_BASE, 0, 0b00000000);
		usleep(100*1000);
	}
	return 0;
}


void checkSW(){
	if(!(IORD(KEY_BASE, 0) & 0x02)){
		int sw_value = IORD(SW_BASE, 0);
		if(sw_value == 0){
			down = 0;
			count = 0;
		}else{
			down = 1;
			int tenth = (sw_value >> 4) & 0x0F;
			int first = sw_value & 0x0F;
			count = tenth*1000 + first*100;
		}
		printf("Count: %d\n", count);
		usleep(100*1000);
	}
}

int createNumber(int count) {
	int four = count / 1000;
	count = count % 1000;

	int three = count / 100;
	count = count % 100;

	int two = count / 10;
	count = count % 10;

	int one = count;

	return number[four]*256*256*256 + number[three] * 256 * 256  + number[two] * 256 + number[one] | 0b100000000000000000000000;
}
