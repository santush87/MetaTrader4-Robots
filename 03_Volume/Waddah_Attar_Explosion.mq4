//+------------------------------------------------------------------+
//|                                       Waddah_Attar_Explosion.mq4 |
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
       int magicNumber = 4001;

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
   Wae();
  }
//+------------------------------------------------------------------+
void Wae()
{
    double up = iCustom(NULL,0,"Examples\\4. Volume\\Waddah_Attar_Explosion",0,1);
    double down = iCustom(NULL,0,"Examples\\4. Volume\\Waddah_Attar_Explosion",1,1);
    double border = iCustom(NULL,0,"Examples\\4. Volume\\Waddah_Attar_Explosion",2,1);
    
    
}