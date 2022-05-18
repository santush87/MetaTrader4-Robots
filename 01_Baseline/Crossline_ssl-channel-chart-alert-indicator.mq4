//+------------------------------------------------------------------+
//|                  Crossline ssl-channel-chart-alert-indicator.mq4 |
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
extern int Lb=10;
       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_StopLoss);
       int magicNumber = 1002;


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
   ssl_chanel();
  }
//+------------------------------------------------------------------+

void ssl_chanel()
{
   double sellLine = iCustom(NULL,0,"Examples\\2. Baseline\\ssl-channel-chart-alert-indicator",Lb,0,1);
   double buyLine = iCustom(NULL,0,"Examples\\2. Baseline\\ssl-channel-chart-alert-indicator",Lb,1,1);
   double prevSellLine = iCustom(NULL,0,"Examples\\2. Baseline\\ssl-channel-chart-alert-indicator",Lb,0,2);
   double prevBuyLine = iCustom(NULL,0,"Examples\\2. Baseline\\ssl-channel-chart-alert-indicator",Lb,1,2);

   CrosslineEntry(buyLine, sellLine, prevBuyLine, prevSellLine, optLotSize,ATR_TakeProfit, ATR_StopLoss,magicNumber);
   CrosslineExit(buyLine,sellLine,magicNumber);
}
