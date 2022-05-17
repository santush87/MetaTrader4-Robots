//+------------------------------------------------------------------+
//|                                 Baseline Hull moving average.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double riskPerc = 1;
extern int period=20;
extern double Divisor=2.0;
extern double ATR_Stop_Loss = 1.5;
extern double ATR_Take_Profit = 1;
       double maxRiskPerc = riskPerc/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_Stop_Loss);
       
       int stopLoss;
       int takeProfit;
       int magicNumber = 1009;
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
   Hull();
  }
//+------------------------------------------------------------------+

void Hull()
{
   double hull = iCustom(NULL,0,"Examples\\2. Baseline\\Hull moving average",period,Divisor,0,1);
   
   BaselineExit(hull,magicNumber);
   BaselineEntry(hull,optLotSize,ATR_Take_Profit,ATR_Stop_Loss,magicNumber);
}
 