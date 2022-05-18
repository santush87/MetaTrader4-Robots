//+------------------------------------------------------------------+
//|                                               Baseline VIDYA.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>


extern double riskPerc = 1;
extern int period=9;
extern int histper=30;
extern double ATR_sl = 1.5;
extern double ATR_tp = 1;
       double maxRiskPerc = riskPerc/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_sl);
       
       int stopLoss;
       int takeProfit;
       int magicNumber = 1007;

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
   Vidya();
  }
//+------------------------------------------------------------------+

void Vidya()
{
   double vidya = iCustom(NULL,0,"Examples\\2. Baseline\\VIDYA",0,1);
   
   BaselineExit(vidya,magicNumber);
   BaselineEntry(vidya,optLotSize,ATR_tp,ATR_sl,magicNumber);
}