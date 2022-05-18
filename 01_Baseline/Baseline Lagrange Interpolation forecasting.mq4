//+------------------------------------------------------------------+
//|                  Baseline Lagrange Interpolation forecasting.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double riskPerc = 1;
extern int first_period=14;
extern int sec_period=14;
extern int third_period=1;
extern double ATR_Stop_Loss = 1.5;
extern double ATR_Take_Profit = 1;
       double maxRiskPerc = riskPerc/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_Stop_Loss);
       
       int stopLoss;
       int takeProfit;
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
   Lagrange();
  }
//+------------------------------------------------------------------+


void Lagrange()
{
   double lagi = iCustom(NULL,0,"Examples\\2. Baseline\\Lagrange Interpolation forecasting",first_period,sec_period,third_period,0,1);
   
   BaselineExit(lagi,magicNumber);
   BaselineEntry(lagi,optLotSize,ATR_Take_Profit,ATR_Stop_Loss,magicNumber);

}