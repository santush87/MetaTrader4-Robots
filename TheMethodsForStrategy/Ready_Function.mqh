//+------------------------------------------------------------------+
//|                                               Ready_Function.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov Corp."
#property link      "ugodisi.bg"
#property strict
#include  <ATR_Functions.mqh>

/*
double GetPipValue()  ПРЕСМЯТАНЕ НА КОЛКО Е = ПИПСА ЗА ВСЯКА ВАЛУТА

int    OpenOrdersInThisPair(string pair)  Колко са отворените позиции на тази валутна двойка

double CalculateTakeProfit(bool isLong, double entryPrice, int pips)

double CalculateStopLoss(bool isLong, double entryPrice, int pips)

double OptimalLotSize(double maxRiskPerc, double sl)

bool   CheckIfOpenOrdersByMagicNumber(int magicNumber) ПОКАЗВА ДАЛИ ИМА ОТВОРЕНИ ПОЗИЦИИ С ТОЗИ MAGIC NUMBER

bool   IsNewCandle()

void   BaselineEntry(double baseline, double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber)

void   BaselineExit(double baseline, int magicNumber)

void   CrosslineEntry(double buyLine, double sellLine, double prevBuyLine, double prevSellLine, 
                      double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber)

void   CrosslineExit(double buyLine, double sellLine, int magicNumber)

void   HistogramEntry(double buyLine, double sellLine, double prevBuyLine, double prevSellLine, 
                    double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber)

void   HistogramExit(double buyLine, double sellLine, int magicNumber)

void   ZeroLineEntry(double line, double prevLine, double lotSize, double AtrTakeProfit, 
                    double AtrStopLoss, int magicNumber)

void   ZeroLineExit(double line, int magicNumber)

void   TrendLineEntry(double line, double prevLine, double lotSize, double AtrTakeProfit, 
                    double AtrStopLoss, int magicNumber)

void   TrendLineExit(double line, int magicNumber)

void MoveToBreakEven(int WhenToMoveToBE, int pipsToLockIn, int magicNumber)

*/

//////ПРЕСМЯТАНЕ НА КОЛКО Е = ПИПСА ЗА ВСЯКА ВАЛУТА!!!

double GetPipValue()
{
   if(_Digits >= 4)
   {
      return 0.0001;
   }
   else
   {
      return 0.01;
   }
}

//Колко са отворените позиции на тази валутна двойка

int OpenOrdersInThisPair(string pair)
{
   int total = 0;
   for(int i=OrdersTotal()-1; i >= 0; i--)
     {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
         if(OrderSymbol()==pair) total++;
     }
   return (total);
}

///////ПРЕСМЯТАНЕ НА TP
double CalculateTakeProfit(bool isLong, double entryPrice, int pips)
{
   double takeProfit;
   if(isLong)
   {
      takeProfit = entryPrice + pips*GetPipValue();
   }
   else
   {
      takeProfit = entryPrice - pips*GetPipValue();
   }
   
   return takeProfit;
}



//////ПРЕСМЯТАНЕ НА SL
double CalculateStopLoss(bool isLong, double entryPrice, int pips)
{
   double stopLoss;
   if(isLong)
   {
      stopLoss = entryPrice - pips*GetPipValue();
   }
   else
   {
      stopLoss = entryPrice + pips*GetPipValue();
   }
   
   return stopLoss;
}


///// ИЗЧИСЛЯВА С КАКВА ЧАСТ ДА ВЛЕЗЕ В ДАДЕНАТА СДЕЛКА СПРЯМО ЗАДАДЕНИЯ %РИСК/////

double OptimalLotSize(double maxRiskPerc, double sl) {
   double maxLossInPips = atrStopLoss(sl);
   double accountEquity = AccountEquity();
   double lotSize = MarketInfo(NULL, MODE_LOTSIZE);
   double tickValue = MarketInfo(NULL, MODE_TICKVALUE);
   
   if(Digits <= 3) {
      tickValue = tickValue/100;
   }
   
   double maxLossInEuro = accountEquity*maxRiskPerc;
   double maxLossInQuoteCurr = maxLossInEuro/tickValue;
   double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr / maxLossInPips/lotSize,2);
   
   if(optimalLotSize<0.01) {
      optimalLotSize = 0.01;
   }
   
   return optimalLotSize;
}

double TheOptimalLotSize(double riskPercent, double sl) {
   double maxRiskPerc = (riskPercent/100);
   
   double result = OptimalLotSize(maxRiskPerc, sl);
   
   return result;
}



//////ПОКАЗВА ДАЛИ ИМА ОТВОРЕНИ ПОЗИЦИИ С ТОЗИ MAGIC NUMBER

bool CheckIfOpenOrdersByMagicNumber(int magicNumber)
{
   int openOrders = OrdersTotal();
   for(int i = 0; i < openOrders; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
         if(OrderMagicNumber() == magicNumber) 
         return true;
      }
   }
   return false;
}
       
       
   
///// ПОКАЗВА ДАЛИ Е СТАРТИРАЛА И ИМА НОВА СВЕЩ!!!   
bool IsNewCandle()
{
   static int BarsOnChart = 0;
   if(Bars == BarsOnChart)
   return false;
   BarsOnChart = Bars;
   return true;
}

//////ПРАВИЛА ЗА ВХОД ПРИ BASELINE!!!
void BaselineEntry(double baseline, double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber)
{
   int ticketNumer;
   int openOrders = OrdersTotal();
   
   if(openOrders<1)
   {
     if((Ask > baseline && Open[0]>baseline && Open[1]<baseline) ||
        (Ask > baseline && Close[1]>baseline && Open[1]<baseline))
     {
         double takeProfit = IfBuyAtrTP(AtrTakeProfit);
         double stopLoss = IfBuyAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
     else if(Ask < baseline && Close[1]<baseline && Open[1]>baseline)
     {
         double takeProfit = IfSellAtrTP(AtrTakeProfit);
         double stopLoss = IfSellAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
   }
}

//////ПРАВИЛА ЗА ИЗХОД ПРИ BASELINE!!!
void BaselineExit(double baseline, int magicNumber)
{   
   int openOrders = OrdersTotal();
   
   if(openOrders>0)
   {
      for(int i =openOrders-1;i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber && baseline > Close[1])
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) Print("Failure to close the order");
            }
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber && baseline < Close[1])
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) Print("Failure to close the order");
            }
      }
   }
}



//////ПРАВИЛА ЗА ВХОД ПРИ CROSSLINE!!!
void CrosslineEntry(double buyLine, double sellLine, double prevBuyLine, double prevSellLine, 
                    double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber)
{
   int ticketNumer;
   int openOrders = OrdersTotal();
   
   if(openOrders<1)
   {
     if(buyLine > sellLine && prevBuyLine < prevSellLine)
     {
         double takeProfit = IfBuyAtrTP(AtrTakeProfit);
         double stopLoss = IfBuyAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
     else if(sellLine > buyLine && prevBuyLine > prevSellLine)
     {
         double takeProfit = IfSellAtrTP(AtrTakeProfit);
         double stopLoss = IfSellAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
   }
}

//////ПРАВИЛА ЗА ИЗХОД ПРИ CROSSLINE!!!
void CrosslineExit(double buyLine, double sellLine, int magicNumber)
{   
   int openOrders = OrdersTotal();
   
   if(openOrders>0)
   {
      for(int i =openOrders-1;i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber && sellLine > buyLine)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) Print("Failure to close the order");
            }
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber && sellLine < buyLine)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) Print("Failure to close the order");
            }
      }
   }
}


//////ПРАВИЛА ЗА ВХОД ПРИ HISTOGRAM!!!
void HistogramEntry(double buyLine, double sellLine, double prevBuyLine, double prevSellLine, 
                    double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber)
{
   int ticketNumer;
   int openOrders = OrdersTotal();
   
   if(openOrders<1)
   {
     if(buyLine > sellLine)
     {
         double takeProfit = IfBuyAtrTP(AtrTakeProfit);
         double stopLoss = IfBuyAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
     else if(sellLine > buyLine && prevBuyLine > prevSellLine)
     {
         double takeProfit = IfSellAtrTP(AtrTakeProfit);
         double stopLoss = IfSellAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
   }
}

//////ПРАВИЛА ЗА ИЗХОД ПРИ HISTOGRAM!!!
void HistogramExit(double buyLine, double sellLine, int magicNumber)
{   
   int openOrders = OrdersTotal();
   
   if(openOrders>0)
   {
      for(int i =openOrders-1;i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber && sellLine > buyLine)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) Print("Failure to close the order");
            }
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber && sellLine < buyLine)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) Print("Failure to close the order");
            }
      }
   }
}


//////ПРАВИЛА ЗА ВХОД ПРИ 0-LINE!!!
void ZeroLineEntry(double line, double prevLine, double lotSize, double AtrTakeProfit, 
                    double AtrStopLoss, int magicNumber)
{
   int ticketNumer;
   int openOrders = OrdersTotal();
   
   if(openOrders<1)
   {
     if(line > 0 && prevLine < 0)
     {
         double takeProfit = IfBuyAtrTP(AtrTakeProfit);
         double stopLoss = IfBuyAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
     else if(line < 0 && prevLine > 0)
     {
         double takeProfit = IfSellAtrTP(AtrTakeProfit);
         double stopLoss = IfSellAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
   }
}

//////ПРАВИЛА ЗА ИЗХОД ПРИ 0-LINE!!!
void ZeroLineExit(double line, int magicNumber)
{   
   int openOrders = OrdersTotal();
   
   if(openOrders>0)
   {
      for(int i =openOrders-1;i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber && line < 0)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) Print("Failure to close the order");
            }
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber && line > 0)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) Print("Failure to close the order");
            }
      }
   }
}


//////ПРАВИЛА ЗА ВХОД ПРИ UP TREND!!!
void TrendLineEntry(double line, double prevLine, double lotSize, double AtrTakeProfit, 
                    double AtrStopLoss, int magicNumber)
{
   int ticketNumer;
   int openOrders = OrdersTotal();
   
   if(openOrders<1)
   {
     if(line > 0 && prevLine < 0)
     {
         double takeProfit = IfBuyAtrTP(AtrTakeProfit);
         double stopLoss = IfBuyAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
     else if(line < 0 && prevLine > 0)
     {
         double takeProfit = IfSellAtrTP(AtrTakeProfit);
         double stopLoss = IfSellAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
   }
}

//////ПРАВИЛА ЗА ИЗХОД ПРИ UP TREND!!!
void TrendLineExit(double line, int magicNumber)
{   
   int openOrders = OrdersTotal();
   
   if(openOrders>0)
   {
      for(int i =openOrders-1;i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber && line < 0)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) Print("Failure to close the order");
            }
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber && line > 0)
            {
              if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) Print("Failure to close the order");
            }
      }
   }
}

void MoveToBreakEven(int WhenToMoveToBE, int pipsToLockIn, int magicNumber)
{
   double pips = GetPipValue();
   
   for(int b=OrdersTotal()-1; b>=0; b--)
     {
      if(OrderSelect(b, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_BUY)
               if(Bid - OrderOpenPrice() > WhenToMoveToBE*pips)
                  if(OrderOpenPrice() > OrderStopLoss())
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice()+pipsToLockIn*pips, OrderTakeProfit(),0,clrNONE))
                  Print("Error in OrderModify. Error code=",GetLastError());         
     }
   for(int s=OrdersTotal()-1; s>=0; s--)
     {
      if(OrderSelect(s, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_SELL)
               if(OrderOpenPrice() - Ask > WhenToMoveToBE*pips)
                  if(OrderOpenPrice() < OrderStopLoss())
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice()-pipsToLockIn*pips, OrderTakeProfit(),0,clrNONE))
                  Print("Error in OrderModify. Error code=",GetLastError());         
     }
}


void AdjustTrail(int WhenToTrail, int TrailAmount, int magicNumber)
{
   double pips = GetPipValue();
   
   for(int b=OrdersTotal()-1; b>=0; b--)
     {
      if(OrderSelect(b, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_BUY)
               if(Bid - OrderOpenPrice() > WhenToTrail*pips)
                  if(OrderStopLoss() < Bid-TrailAmount*pips)
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TrailAmount*pips, OrderTakeProfit(),0,clrNONE))
                     Print("Error in OrderModify. Error code=",GetLastError());
          
     }
   for(int s=OrdersTotal()-1; s>=0; s--)
     {
      if(OrderSelect(s, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_SELL)
               if(OrderOpenPrice() - Ask > WhenToTrail*pips)
                  if(OrderStopLoss() > Ask+TrailAmount*pips || OrderStopLoss()==0)
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TrailAmount*pips, OrderTakeProfit(),0,clrNONE))
                   Print("Error in OrderModify. Error code=",GetLastError());
     }   
}

//

void PartialClose(double partialClosePips, double optLotSize)
{
   double pips = GetPipValue();
   
   if(!OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
   Print("Unable to select an otder!");
   double op = OrderOpenPrice();
   int type = OrderType();
   double lots = OrderLots();
   int ticket = OrderTicket();
   
   if(lots == optLotSize)
   {
      if(type == OP_BUY && Bid-op > partialClosePips*pips)
      {
      if(!OrderClose(ticket, lots/2, Bid, 30, clrGreen)) Print("Failure to close the order");
      }
   else if(type == OP_SELL && op-Ask > partialClosePips*pips)
      {
      if(!OrderClose(ticket, lots/2, Ask, 30, clrGreen)) Print("Failure to close the order");
      }
   }
}


// Операциите с ATR като опция!!!

void MoveToBreakEvenATR(double whenBeATR, int pipsToLockIn, int magicNumber)
{
   double WhenToMoveToBE = atrTakeProfit()*whenBeATR;
   double pips = GetPipValue();
   
   for(int b=OrdersTotal()-1; b>=0; b--)
     {
      if(OrderSelect(b, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_BUY)
               if(Bid - OrderOpenPrice() > WhenToMoveToBE)
                  if(OrderOpenPrice() > OrderStopLoss())
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice()+pipsToLockIn*pips, OrderTakeProfit(),0,clrNONE))
                  Print("Error in OrderModify. Error code=",GetLastError());         
     }
   for(int s=OrdersTotal()-1; s>=0; s--)
     {
      if(OrderSelect(s, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_SELL)
               if(OrderOpenPrice() - Ask > WhenToMoveToBE)
                  if(OrderOpenPrice() < OrderStopLoss())
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice()-pipsToLockIn*pips, OrderTakeProfit(),0,clrNONE))
                  Print("Error in OrderModify. Error code=",GetLastError());         
     }
}


void AdjustTrailATR(double WhenToTrailATR, double TrailAmountATR, int magicNumber)
{
   double WhenToTrail = atrTakeProfit()*WhenToTrailATR;
   double TrailAmount = atrTakeProfit()*TrailAmountATR;
   double pips = GetPipValue();
   
   for(int b=OrdersTotal()-1; b>=0; b--)
     {
      if(OrderSelect(b, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_BUY)
               if(Bid - OrderOpenPrice() > WhenToTrail)
                  if(OrderStopLoss() < Bid-TrailAmount)
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TrailAmount, OrderTakeProfit(),0,clrNONE))
                     Print("Error in OrderModify. Error code=",GetLastError());
          
     }
   for(int s=OrdersTotal()-1; s>=0; s--)
     {
      if(OrderSelect(s, SELECT_BY_POS, MODE_TRADES))
        if(OrderMagicNumber() == magicNumber)
          if(OrderSymbol() == Symbol())
            if(OrderType() == OP_SELL)
               if(OrderOpenPrice() - Ask > WhenToTrail)
                  if(OrderStopLoss() > Ask+TrailAmount || OrderStopLoss()==0)
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TrailAmount, OrderTakeProfit(),0,clrNONE))
                   Print("Error in OrderModify. Error code=",GetLastError());
     }   
}

//

void PartialCloseATR(double partialCloseATR, double optLotSize)
{
   double partialClosePips = atrTakeProfit()*partialCloseATR;
   double pips = GetPipValue();
   
   if(!OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
   Print("Unable to select an otder!");
   double op = OrderOpenPrice();
   int type = OrderType();
   double lots = OrderLots();
   int ticket = OrderTicket();
   
   if(lots == optLotSize)
   {
      if(type == OP_BUY && Bid-op > partialClosePips)
      {
      if(!OrderClose(ticket, lots/2, Bid, 30, clrGreen)) Print("Failure to close the order");
      }
   else if(type == OP_SELL && op-Ask > partialClosePips)
      {
      if(!OrderClose(ticket, lots/2, Ask, 30, clrGreen)) Print("Failure to close the order");
      }
   }
}


//////ПРАВИЛА ЗА ВХОД ПРИ Between Lines!!!
void BetweenLinesEntry(double downLine, double upLine, double levelLine, 
                       double prevDownLine, double prevUpLine, double prevLevelLine,
                       double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber) {
   int ticketNumer;
   int openOrders = OrdersTotal();
   
   if(openOrders<1) {
     if(levelLine > upLine && prevLevelLine < prevUpLine) {
        
         double takeProfit = IfBuyAtrTP(AtrTakeProfit);
         double stopLoss = IfBuyAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
     
     else if(levelLine < downLine && prevLevelLine > prevDownLine) {
         double takeProfit = IfSellAtrTP(AtrTakeProfit);
         double stopLoss = IfSellAtrSL(AtrStopLoss);
         ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 10, stopLoss, takeProfit,NULL, magicNumber);
     }
   }
}

//////ПРАВИЛА ЗА ИЗХОД ПРИ Between Lines!!!
void BetweenLinesExit(double downLine, double upLine, double levelLine, int magicNumber) {   
   int openOrders = OrdersTotal();
   
   if(openOrders>0) {
      for(int i =openOrders-1;i>=0; i--) {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES)) {
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber && levelLine < upLine) {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) 
               Print("Failure to close the order");
            }
            
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber && levelLine > downLine) {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) Print("Failure to close the order");
            }
         }
      }
   }
}