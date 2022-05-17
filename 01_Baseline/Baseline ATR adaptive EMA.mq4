//+------------------------------------------------------------------+
//|                                    Baseline ATR adaptive EMA.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TakeProfit = 1;
extern double ATR_StopLoss = 1.5;
       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_StopLoss);
       int magicNumber = 1002;
   

int OnInit()
  {
  return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason)
  {
  
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   ATR_adaptive_EMA();
  }
//+------------------------------------------------------------------+

void ATR_adaptive_EMA()
{
   double adaptive_EMA = iCustom(NULL,0,"Examples\\2. Baseline\\ATR adaptive EMA",0,1);

   BaselineExit(adaptive_EMA,magicNumber);
   BaselineEntry(adaptive_EMA,optLotSize,ATR_TakeProfit,ATR_StopLoss,magicNumber);
}