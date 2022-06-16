//+------------------------------------------------------------------+
//|                        B-Langarage_C1-RSI_C2-Langarage_V-WAE.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Algo_Tester.mqh>
#include <Ready_Function.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TP = 3;
extern double ATR_SL = 1.5;

extern int baseFirst_period = 14;
extern int baseSec_period = 14;
extern int baseThird_period = 1;

extern bool moveToBEpips = false;
extern int WhenToMoveToBE =50;
extern int pipsToLockIn = 10;

extern bool moveToBeATR= true;
extern double whenBeATR =1;

extern bool useTrailingStopATR = true;
extern double WhenToTrailATR = 1.5;
extern double TrailAmountATR = 1.5;

extern bool useTrailingStop = false;
extern int WhenToTrail = 100;
extern int TrailAmount = 80;

extern bool partCloseATR = true;
extern double partialCloseATR = 1;

extern bool partClose = false;
extern double partialClosePips = 50;

 
       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_SL);
       int magicNumber = 5005;

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
   double lagi = iCustom(NULL,0,"Examples\\2. Baseline\\Lagrange Interpolation forecasting",baseFirst_period,baseSec_period,baseThird_period,0,1);
   
   //Crossline
   double buyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\RSI-Laguerre Self Adjusting With Fractal Energy Gaussian Price Filter",1,1);
   double sellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\RSI-Laguerre Self Adjusting With Fractal Energy Gaussian Price Filter",0,1);
   double prevBuyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\RSI-Laguerre Self Adjusting With Fractal Energy Gaussian Price Filter",1,2);
   double prevSellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\RSI-Laguerre Self Adjusting With Fractal Energy Gaussian Price Filter",0,2);
   
   //0-Line
   double line = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Lagrange Interpolation forecasting Oscillator",0,1);
   double prevLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Lagrange Interpolation forecasting Oscillator",0,2);
   
   BaseCrossZeroExit(lagi,buyLine,sellLine,line,magicNumber);
   BaseCrossZeroWaeEntry(lagi,buyLine,sellLine,prevBuyLine,prevSellLine,line,prevLine,optLotSize,ATR_TP,ATR_SL,magicNumber);
}