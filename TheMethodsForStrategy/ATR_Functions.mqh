//+------------------------------------------------------------------+
//|                                                ATR_Functions.mqh |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property strict


/////ПРЕСМЯТА КЪДЕ ТРЯБВА ДА Е STOP LOSS-a
double atrStopLoss(double sl)
{ 
double atrSL = iATR(NULL,0,14,1)*sl;
return atrSL;
}
/////ПРЕСМЯТА КЪДЕ ТРЯБВА ДА Е TAKE PROFIT-a
double atrTakeProfit()
{ 
double atrTP = iATR(NULL,0,14,1);
return atrTP;
}


       // Със задаване на параметри!//
       /////// OPERATION BUY //////
  double IfBuyAtrTP(double tp)
   {
      double atrTP = iATR(NULL,0,14,1)*tp;
      double takeProfit;
     
      takeProfit = atrTP+Close[1];
      
      return takeProfit;
   }
   
   double IfBuyAtrSL(double sl)
   {
      double atrSL = iATR(NULL,0,14,1)*sl;
      double stopLoss;
      
      stopLoss = Close[1]-atrSL;
      
      return stopLoss;
   }

/////// OPERATION BUY with candlesBack//////
  double IfBuyAtrTP(double tp, int candlesBack)
   {
      double atrTP = iATR(NULL,0,14,candlesBack)*tp;
      double takeProfit;
     
      takeProfit = atrTP+Close[candlesBack];
      
      return takeProfit;
   }
   
   double IfBuyAtrSL(double sl, int candlesBack)
   {
      double atrSL = iATR(NULL,0,14,candlesBack)*sl;
      double stopLoss;
      
      stopLoss = Close[candlesBack]-atrSL;
      
      return stopLoss;
   }   
   
       
       /////// OPERATION SELL //////   
   double IfSellAtrTP(double tp)
   {
      double atrTP = iATR(NULL,0,14,1)*tp;
      double takeProfit;
      
      takeProfit = Close[1] - atrTP;
      
      return takeProfit;
   }
   
   double IfSellAtrSL(double sl)
   {
      double atrSL = iATR(NULL,0,14,1)*sl;
      double stopLoss;
     
      stopLoss = Close[1]+atrSL;
      
      return stopLoss;
   }

       /////// OPERATION SELL with candlesBack //////   
   double IfSellAtrTP(double tp, int candlesBack)
   {
      double atrTP = iATR(NULL,0,14,candlesBack)*tp;
      double takeProfit;
      
      takeProfit = Close[candlesBack] - atrTP;
      
      return takeProfit;
   }
   
   double IfSellAtrSL(double sl, int candlesBack)
   {
      double atrSL = iATR(NULL,0,14,candlesBack)*sl;
      double stopLoss;
     
      stopLoss = Close[candlesBack]+atrSL;
      
      return stopLoss;
   }
   
   
   // Параметри по подразбиране ТР=1, SL=1,5!//
   
   double IfBuyAtrTP()
   {
      double atrTP = iATR(NULL,0,14,1);
      double takeProfit;
     
      takeProfit = atrTP+Close[1];
      
      return takeProfit;
   }
   
   double IfBuyAtrSL()
   {
      double atrSL = iATR(NULL,0,14,1)*1.5;
      double stopLoss;
      
      stopLoss = Close[1]-atrSL;
      
      return stopLoss;
   }
   
   
    /////// OPERATION SELL //////   
   double IfSellAtrTP()
   {
      double atrTP = iATR(NULL,0,14,1);
      double takeProfit;
      
      takeProfit = Close[1] - atrTP;
      
      return takeProfit;
   }
   
   double IfSellAtrSL()
   {
      double atrSL = iATR(NULL,0,14,1)*1.5;
      double stopLoss;
     
      stopLoss = Close[1]+atrSL;
      
      return stopLoss;
   }
   