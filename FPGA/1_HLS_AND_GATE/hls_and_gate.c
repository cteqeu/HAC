#include "stdbool.h"
#include "hls_and_gate.h"

void CombLogicAND(bool BTN1, bool BTN2, bool  *LED3)
{
#pragma HLS INTERFACE ap_ctrl_none port = return
#pragma HLS INTERFACE ap_none port = BTN1
#pragma HLS INTERFACE ap_none port = BTN2
#pragma HLS INTERFACE ap_none port = LED3

		*LED3 = BTN1 && BTN2; // LOGIC AND GATE
}
