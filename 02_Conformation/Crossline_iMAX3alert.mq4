//+------------------------------------------------------------------+
//|                                         Crossline iMAX3alert.mq4 |
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
       int magicNumber = 2013;
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
   Imax();
  }
//+------------------------------------------------------------------+
void Imax()
{
   double buyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\iMAX3alert",6,1);
   double sellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\iMAX3alert",5,1);
   double prevBuyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\iMAX3alert",6,2);
   double prevSellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\iMAX3alert",5,2);

   CrosslineExit(buyLine,sellLine,magicNumber);
   CrosslineEntry(buyLine, sellLine, prevBuyLine, prevSellLine, optLotSize,ATR_TP, ATR_SL,magicNumber);
}
