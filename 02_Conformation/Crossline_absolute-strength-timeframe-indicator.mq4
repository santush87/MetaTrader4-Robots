//+------------------------------------------------------------------+
//|              Crossline absolute-strength-timeframe-indicator.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TP = 1;
extern double ATR_SL = 1.5;
       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_SL);
       int magicNumber = 2002;

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
   Ash();
  }
//+------------------------------------------------------------------+

void Ash()
{
   double buyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",0,1);
   double sellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",1,1);
   double prevBuyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",0,2);
   double prevSellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",1,2);

   CrosslineExit(buyLine,sellLine,magicNumber);
   CrosslineEntry(buyLine, sellLine, prevBuyLine, prevSellLine, optLotSize,ATR_TP, ATR_SL,magicNumber);
}