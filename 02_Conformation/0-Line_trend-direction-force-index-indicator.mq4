//+------------------------------------------------------------------+
//|                 0-Line trend-direction-force-index-indicator.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include <Ready_Function.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TP = 1;
extern double ATR_SL = 1.5;
       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_SL);
       int magicNumber = 2030;
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
   Trend();
  }
//+------------------------------------------------------------------+

void Trend()
{
   double line = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\trend-direction-force-index-indicator",0,1);
   double prevLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\trend-direction-force-index-indicator",0,2);
   
   int ticketNumer;
   int openOrders = OrdersTotal();
   
   if(openOrders<1)
   {
     if(line > 0.4 && prevLine < 0.4)
     {
         double takeProfit = IfBuyAtrTP(ATR_TP);
         double stopLoss = IfBuyAtrSL(ATR_SL);
         int ticketNumer = OrderSend(NULL,OP_BUY, optLotSize, Ask, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
     else if(line < -0.5 && prevLine > -0.5)
     {
         double takeProfit = IfSellAtrTP(ATR_TP);
         double stopLoss = IfSellAtrSL(ATR_SL);
         int ticketNumer = OrderSend(NULL,OP_SELL, optLotSize, Bid, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
   }
}