//+------------------------------------------------------------------+
//|           KijunSen + Langarage + absolute-strength-timeframe.mq4 |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property version   "1.00"
#property strict
#include  <Algo_Tester.mqh>

extern double Risk_Percentage = 1;
extern double ATR_TP = 3;
extern double ATR_SL = 1.5;

extern bool moveToBE = true;
extern int WhenToMoveToBE =50;
extern int pipsToLockIn = 5;

extern bool useTrailingStop = true;
extern int WhenToTrail = 100;
extern int TrailAmount = 50;

extern bool partClose = true;
extern double partialClosePips = 50;

       double maxRiskPerc = Risk_Percentage/100;
       double optLotSize = OptimalLotSize(maxRiskPerc,ATR_SL);
       int magicNumber = 5002;

extern int kijunSen = 26;
extern int KijunShift=1;

string Langarage;
extern int first_Per = 14;
extern int second_Per = 14;
extern int thrid_Per = 1;


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
   if(moveToBE) MoveToBreakEven(WhenToMoveToBE, pipsToLockIn,magicNumber);
   if(partClose) PartialClose(partialClosePips,optLotSize);
   if(useTrailingStop) AdjustTrail(WhenToTrail,TrailAmount,magicNumber);

  }
//+------------------------------------------------------------------+
void Algo()
{
   //Baseline
   double kijun = iIchimoku(NULL,0,9,kijunSen,52,MODE_KIJUNSEN,KijunShift);
   
   //Crossline
   double buyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",0,1);
   double sellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",1,1);
   double prevBuyLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",0,2);
   double prevSellLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\absolute-strength-timeframe-indicator",1,2);
   
   //0-Line
   double line = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Lagrange Interpolation forecasting Oscillator",0,1);
   double prevLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Lagrange Interpolation forecasting Oscillator",0,2);

   BaseCrossZeroExit(kijun,buyLine,sellLine,line,magicNumber);
   BaseCrossZeroWaeEntry(kijun,buyLine,sellLine,prevBuyLine,prevSellLine,line,prevLine,optLotSize,ATR_TP,ATR_SL,magicNumber);
}