//+------------------------------------------------------------------+
//|                                     Dynamic_trend_cleaned_up.mq4 |
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
       int magicNumber = 2009;

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
   Dynamic();
  }
//+------------------------------------------------------------------+

void Dynamic()
{
   double trendLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Dynamic_trend_cleaned_up",0,0);
   double prevTrendLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Dynamic_trend_cleaned_up",0,1);

   TrendExit(trendLine, magicNumber);
   TrendEntry(trendLine, prevTrendLine, optLotSize, ATR_TakeProfit, ATR_StopLoss, magicNumber);
}