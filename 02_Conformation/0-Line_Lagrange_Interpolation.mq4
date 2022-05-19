//+------------------------------------------------------------------+
//|                                0-Line Lagrange Interpolation.mq4 |
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
       int magicNumber = 2027;

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
   Lagrange();
  }
//+------------------------------------------------------------------+

void Lagrange()
{
   double line = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Lagrange Interpolation forecasting Oscillator",0,1);
   double prevLine = iCustom(NULL,0,"Examples\\3. Confirmation Indicators\\Lagrange Interpolation forecasting Oscillator",0,2);
   
   ZeroLineExit(line, magicNumber);
   ZeroLineEntry(line, prevLine, optLotSize, ATR_TP, ATR_SL, magicNumber);
}