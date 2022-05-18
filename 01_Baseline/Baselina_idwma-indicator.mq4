//+------------------------------------------------------------------+
//|                                     Baselina idwma-indicator.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double riskPerc = 1;
extern int MA_period=14;
extern int MA_Shift=0;
extern int MA_Price=0;
extern int MA_TF=0;
extern double ATR_Stop_Loss = 1.5;
extern double ATR_Take_Profit = 1;
       double maxRiskPerc = riskPerc/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_Stop_Loss);       
       int magicNumber = 1010;

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
   Idwma();
  }
//+------------------------------------------------------------------+

void Idwma()
{
   double idwma = iCustom(NULL,0,"Examples\\2. Baseline\\idwma-indicator",MA_period,MA_Shift,MA_Price,MA_TF,0,1);
   
   BaselineExit(idwma,magicNumber);
   BaselineEntry(idwma,optLotSize,ATR_Take_Profit,ATR_Stop_Loss,magicNumber);

}
