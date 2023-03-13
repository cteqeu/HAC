#include "stdio.h"
#include "stdbool.h"
#include "hls_and_gate.h"


/*
 * 		Logic And Gate
 * 		BTN1	BTN 2	LED3 (=BTN1 AND BTN2)
 * 		0		0		0
 * 		0		1		0
 * 		1		0		0
 * 		1		1		1
 */


int main()
{
	int status = 0;

	bool BTN1_TB, BTN2_TB, LED3_TB[4]; 		// Array of 4 because we have 4 rows in our truth table
	bool TB_GOLDEN_RESULT[4] = {0,0,0,1}; 	// Truth table results of BTN1 and BTN2 function

	int i=0;
	for(int iBTN1=0; iBTN1<2; iBTN1++)
	{
		for(int iBTN2=0; iBTN2<2; iBTN2++)
		{
			BTN1_TB = (bool) iBTN1;
			BTN2_TB = (bool) iBTN2;

			CombLogicAND(BTN1_TB, BTN2_TB, &LED3_TB[i++]);
		}
	}

	for(int j = 0; j < 4; j++)
	{
		if(LED3_TB[j]!=TB_GOLDEN_RESULT[j])
		{
			printf("Error at row %d of truth table \n\r",j);
			status = 1; //something wrong
		}

		printf("d[%d] = %d = TB_GOLDEN_RESULT[%d] = %d \n\r",j,LED3_TB[j],j,TB_GOLDEN_RESULT[j]);
	}

	if(status == 0)
		printf("Testbench Success!\n\r");
	else
		printf("Testbench Failure!\n\r");


	return status;
}
