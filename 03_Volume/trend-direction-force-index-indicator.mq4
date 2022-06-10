//+------------------------------------------------------------------+
//|                        trend-direction-force-index-indicator.mq4 |
//|                                               Martin Aleksandrov |
//|                                     https://martinaleksandrov.eu |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://martinaleksandrov.eu"
#property version   "1.00"
#property strict
#include  <Ready_Function.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TP = 1;
extern double ATR_SL = 1.5;
extern int trendPeriod = 20;

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

       double optLotSize = TheOptimalLotSize(Risk_Percentage, ATR_SL);
       //double maxRiskPerc = (Risk_Percentage/100);
       //double optLotSize = OptimalLotSize(maxRiskPerc,ATR_SL);
       int magicNumber = 2080;


int OnInit() {

   return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason) {
  
}


void OnTick() {

    Trend();
      if(moveToBEpips) MoveToBreakEven(WhenToMoveToBE, pipsToLockIn,magicNumber);
      if(moveToBeATR) MoveToBreakEvenATR(whenBeATR,pipsToLockIn,magicNumber);
   
      if(partClose) PartialClose(partialClosePips,optLotSize);
      if(partCloseATR) PartialCloseATR(partialCloseATR,optLotSize);
   
      if(useTrailingStop) AdjustTrail(WhenToTrail,TrailAmount,magicNumber);
      if(useTrailingStopATR) AdjustTrailATR(WhenToTrailATR,TrailAmountATR,magicNumber);
}


void Trend(){
   double upLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 0, 1);
   double downLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 1, 1);
   double levelLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 2, 1);
   
   double prevUpLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 0, 2);
   double prevDownLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 1, 2);
   double prevLevelLine = iCustom(NULL,0,"Examples\\trend-direction-force-index-indicator", trendPeriod, 2, 2);
   
   BetweenLinesExit(downLine, upLine, levelLine, magicNumber);
   BetweenLinesEntry(downLine, upLine, levelLine, prevDownLine, prevUpLine, prevLevelLine,
                     optLotSize, ATR_TP, ATR_SL, magicNumber);
}
   
