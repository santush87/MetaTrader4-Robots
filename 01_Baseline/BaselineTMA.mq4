//+------------------------------------------------------------------+
//|                                                 Baseline TMA.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double riskPerc = 1;
extern int Periods=7;
extern int ApplyTo=0;
extern double ATR_Stop_Loss = 1.5;
extern double ATR_Take_Profit = 1;
       double maxRiskPerc = riskPerc/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_Stop_Loss);
       
       int magicNumber = 1012;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   TMA();
  }
//+------------------------------------------------------------------+

void TMA()
{
   double tma = iCustom(NULL,0,"Examples\\2. Baseline\\tma-indicator",Periods,ApplyTo,0,1);
   
   BaselineExit(tma,magicNumber);
   BaselineEntry(tma,optLotSize,ATR_Take_Profit,ATR_Stop_Loss,magicNumber);
}
