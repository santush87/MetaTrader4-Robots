//+------------------------------------------------------------------+
//|                                           Baseline Kijun-Sen.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>


extern double Risk_Percentage = 1;
extern int Kijun=26;
extern int KijunShift=1;
extern double ATR_TakeProfit = 1;
extern double ATR_StopLoss = 1.5;
       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_StopLoss);
       
       int magicNumber = 1001;

int OnInit()
  {

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
   KijunSenTrade(); 
  }

void KijunSenTrade()
{
   double kijunSen = iIchimoku(NULL,0,9,Kijun,52,MODE_KIJUNSEN,KijunShift);
   BaselineExit(kijunSen,magicNumber);
   BaselineEntry(kijunSen, optLotSize,ATR_TakeProfit,ATR_StopLoss,magicNumber);
   
}