//+------------------------------------------------------------------+
//|                                          0-Line_BB_PRC_RANGE.mq4 |
//|                                               Martin Aleksandrov |
//|                                     https://martinaleksandrov.eu |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TP = 1;
extern double ATR_SL = 1.5;
extern int bPer = 20;
extern int bDev = 2;
extern int maPer = 50;
extern int maMeth = 1;

       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_SL);
       int magicNumber = 2055;
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
   BB();
  }
//+------------------------------------------------------------------+

void BB()
{
      double buyLine = iCustom(NULL,0,"Examples\\BB_PRC-1",0,1);
      double sellLine = iCustom(NULL,0,"Examples\\BB_PRC-1",1,1);
      double prevBuyLine = iCustom(NULL,0,"Examples\\BB_PRC-1",0,2);
      double prevSellLine = iCustom(NULL,0,"Examples\\BB_PRC-1",1,2);

      CrosslineExit(buyLine,sellLine,magicNumber);
      CrosslineEntry(buyLine, sellLine, prevBuyLine, prevSellLine, optLotSize,ATR_TP, ATR_SL,magicNumber);
}