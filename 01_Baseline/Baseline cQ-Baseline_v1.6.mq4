//+------------------------------------------------------------------+
//|                                    Baseline cQ-Baseline_v1.6.mq4 |
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
       int magicNumber = 1003;


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
   cQ_Baseline_v1();
  }
//+------------------------------------------------------------------+
void cQ_Baseline_v1()
{
   double cQ_Baseline = iCustom(NULL,0,"Examples\\2. Baseline\\cQ-Baseline_v1.6",0,1);

   BaselineExit(cQ_Baseline,magicNumber);
   BaselineEntry(cQ_Baseline,optLotSize,ATR_TakeProfit,ATR_StopLoss,magicNumber);
}