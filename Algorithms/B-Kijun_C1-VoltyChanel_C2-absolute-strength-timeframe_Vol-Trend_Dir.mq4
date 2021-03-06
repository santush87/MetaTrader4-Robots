//+------------------------------------------------------------------+
//|               B-Kijun_C1-VoltyChanel_C2-BB_PRC_Vol-Trend_Dir.mq4 |
//|                                               Martin Aleksandrov |
//|                                     https://martinaleksandrov.eu |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://martinaleksandrov.eu"
#property version   "1.00"
#property strict
#include  <Algo_Tester.mqh>
#include <Ready_Function.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TP = 3;
extern double ATR_SL = 1.5;

extern bool moveToBeATR= true;
extern double whenBeATR =1;
extern int pipsToLockIn = 10;

extern bool useTrailingStopATR = true;
extern double WhenToTrailATR = 1.5;
extern double TrailAmountATR = 1.5;

extern bool partCloseATR = true;
extern double partialCloseATR = 1;

extern bool moveToBEpips = false;
extern int WhenToMoveToBE =50;

extern bool useTrailingStop = false;
extern int WhenToTrail = 100;
extern int TrailAmount = 80;


extern bool partClose = false;
extern double partialClosePips = 50;

extern bool tradeWhenBigATR = false;
//((Ask-baseline) < atrValue) || ((baseline-Bid) < atrValue) 
//Да се зададе дали да се отваря сделка ако цената е по-голяма от 1 АТР

 
       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_SL);
       int magicNumber = 5006;

extern int kijunSen = 26;
extern int KijunShift=1;
extern int trendPeriod = 20;

double atrValue =atrTakeProfit();


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
        
   Algo();
      if(moveToBEpips) MoveToBreakEven(WhenToMoveToBE, pipsToLockIn,magicNumber);
      if(moveToBeATR) MoveToBreakEvenATR(whenBeATR,pipsToLockIn,magicNumber);
   
      if(partClose) PartialClose(partialClosePips,optLotSize);
      if(partCloseATR) PartialCloseATR(partialCloseATR,optLotSize);
   
      if(useTrailingStop) AdjustTrail(WhenToTrail,TrailAmount,magicNumber);
      if(useTrailingStopATR) AdjustTrailATR(WhenToTrailATR,TrailAmountATR,magicNumber);  
   
  }
  
//+------------------------------------------------------------------+

void Algo()
{
   //Baseline
   double kijun = iIchimoku(NULL,0,9,kijunSen,52,MODE_KIJUNSEN,KijunShift);
   
   
   //Crossline
   /*double buyLine = iCustom(NULL,0,"Examples\\BB_PRC-1",0,1);
   double sellLine = iCustom(NULL,0,"Examples\\BB_PRC-1",1,1);
   double prevBuyLine = iCustom(NULL,0,"Examples\\BB_PRC-1",0,2);
   double prevSellLine = iCustom(NULL,0,"Examples\\BB_PRC-1",1,2);*/
   
   //Crossline
   double buyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",0,1);
   double sellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",1,1);
   double prevBuyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",0,2);
   double prevSellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",1,2);
   
   //Trend
   double greaterSell = iCustom(NULL,0,"Examples\\volty-channel-stop-indicator",0,0);
   double greaterBuy = iCustom(NULL,0,"Examples\\volty-channel-stop-indicator",1,0);
   double prevGreaterSell = iCustom(NULL,0,"Examples\\volty-channel-stop-indicator",0,1);
   double prevGreaterBuy = iCustom(NULL,0,"Examples\\volty-channel-stop-indicator",1,1);
   
   //Volume
   double upLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 0, 1);
   double downLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 1, 1);
   double levelLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 2, 1);
   
   double prevUpLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 0, 2);
   double prevDownLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 1, 2);
   double prevLevelLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 2, 2);
  
   BaseCrossTrendVolExit(kijun, buyLine, sellLine, greaterSell, greaterBuy, magicNumber);
   BaseCrossTrendVolEntry(kijun, buyLine, sellLine, prevBuyLine, prevSellLine, 
                           greaterSell, greaterBuy, prevGreaterSell, prevGreaterBuy, 
                           upLine, downLine, levelLine, prevUpLine, prevDownLine, prevLevelLine,
                           tradeWhenBigATR, optLotSize, ATR_TP, ATR_SL, magicNumber);
   
}