//+------------------------------------------------------------------+
//|                                                  Algo tester.mqh |
//|                                               Martin Aleksandrov |
//|                                           https://www.ugodisi.bg |
//+------------------------------------------------------------------+
#property copyright "Martin Aleksandrov"
#property link      "https://www.ugodisi.bg"
#property strict
#include  <ATR_Functions.mqh>
#include <Ready_Function.mqh>

//ПРАВИЛА ЗА ВХОД ПРИ Baseline + C1 Crossline + C2 0-line + WAE

void BaseCrossZeroWaeEntry(double baseline, 
                   double buyLine, double sellLine, double prevBuyLine, double prevSellLine,
                   double line, double prevLine,
                   double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber)
{
   int ticketNumer;
   int openOrders = OrdersTotal();
   double atrValue =atrTakeProfit();
   
   //Waddah_Attar_Explosion   
   double up = iCustom(NULL,0,"Examples\\4. Volume\\Waddah_Attar_Explosion",0,1);
   double down = iCustom(NULL,0,"Examples\\4. Volume\\Waddah_Attar_Explosion",1,1);
   double border = iCustom(NULL,0,"Examples\\4. Volume\\Waddah_Attar_Explosion",2,1);
   
   if(openOrders<1)
   {      
       if((((   Ask > baseline && Open[0]>baseline && Open[1]<baseline) 
            || (Ask > baseline && Close[1]>baseline && Open[1]<baseline))
            && (buyLine > sellLine) 
            && (line > 0) 
            && (up > border) 
            && ((Ask-baseline) < atrValue)
            ) ||
         
            ((Ask > baseline && Open[0]>baseline) 
            && (buyLine > sellLine && prevBuyLine < prevSellLine)
            && (line > 0) 
            && (up > border)  
            && ((Ask-baseline) < atrValue)
            ) ||
         
            ((Ask > baseline && Open[0]>baseline)
            && (buyLine > sellLine)
            && (line > 0 && prevLine < 0) 
            && (up > border)
            && ((Ask-baseline) < atrValue)
            ))
          {
            double takeProfit = IfBuyAtrTP(AtrTakeProfit);
            double stopLoss = IfBuyAtrSL(AtrStopLoss);
            ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 30, stopLoss, takeProfit,NULL, magicNumber);
          }
      
     else if((((Bid < baseline && Open[0]<baseline && Open[1]>baseline) 
            || (Bid < baseline && Close[1]<baseline && Open[1]>baseline))
            && (buyLine < sellLine) 
            && (line < 0)
            && (down > border) 
            && ((baseline-Bid) < atrValue)
            ) ||
         
            ((Bid < baseline && Open[0]<baseline) 
            && (buyLine < sellLine && prevBuyLine > prevSellLine)
            && (line < 0) 
            && (down > border) 
            && ((baseline-Bid) < atrValue)
            ) ||
         
            ((Bid < baseline && Open[0]<baseline)
            && (buyLine < sellLine)
            && (line < 0 && prevLine > 0)
            && (down > border)
            && ((baseline-Bid) < atrValue)
            ))
         {
            double takeProfit = IfSellAtrTP(AtrTakeProfit);
            double stopLoss = IfSellAtrSL(AtrStopLoss);
            ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 30, stopLoss, takeProfit,NULL, magicNumber);
         }
   }
}



//ПРАВИЛА ЗА ИЗХОД ПРИ Baseline + C1 Crossline + C2 0-line
void BaseCrossZeroExit(double baseline, double buyLine, double sellLine, double line, int magicNumber)
{   
   int openOrders = OrdersTotal();
   
   if(openOrders>0)
   {
      for(int i =openOrders-1;i>=0; i--)
      {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber && (baseline > Close[1] || sellLine > buyLine || line < 0))
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) Print("Failure to close the order");
            }
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber && (baseline < Close[1] || sellLine < buyLine || line > 0))
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) Print("Failure to close the order");
            }
      }
   }
}





//ПРАВИЛА ЗА ВХОД ПРИ Baseline + C1 Crossline + C2 Trend
void BaseCrossTrendVolEntry(double baseline, 
                   double buyLine, double sellLine, double prevBuyLine, double prevSellLine,
                   double greaterSell, double greaterBuy, double prevGreaterSell, double prevGreaterBuy,
                   double upLine, double downLine, double levelLine,
                   double prevUpLine, double prevDownLine, double prevLevelLine,
                   bool tradeWhenBigATR, 
                   double lotSize, double AtrTakeProfit, double AtrStopLoss, int magicNumber) {
                   
   int ticketNumer;
   int openOrders = OrdersTotal();
   double atrValue = atrTakeProfit();
   
   if(openOrders<1) {
         
       if((((   Ask > baseline && Open[0]>baseline && Open[1]<baseline)    //Baseline подродно
            || (Ask > baseline && Close[1]>baseline && Open[1]<baseline))  
            && (buyLine > sellLine)                                        //Crossline
            && (greaterBuy > greaterSell)                                  //Trend
            && (levelLine > upLine)                                        //Volume
            ) ||
         
            ((Ask > baseline && Open[0]>baseline)                          //Baseline
            && (buyLine > sellLine && prevBuyLine < prevSellLine)          //Crossline подродно
            && (greaterBuy > greaterSell)                                  //Trend
            && (levelLine > upLine)                                        //Volume  
            ) ||
         
            ((Ask > baseline && Open[0]>baseline)                          //Baseline
            && (buyLine > sellLine)                                        //Crossline
            && (greaterBuy > greaterSell && prevGreaterBuy < prevGreaterSell) //Trend подродно
            && (levelLine > upLine)                                        //Volume
            ) ||
         
            ((Ask > baseline && Open[0]>baseline)                          //Baseline
            && (buyLine > sellLine)                                        //Crossline
            && (greaterBuy > greaterSell)                                  //Trend
            && (levelLine > upLine && prevLevelLine < prevUpLine)          //Volume подродно  
            ))
          {
            if(!tradeWhenBigATR) {
               if((Ask-baseline) < atrValue) {
                  double takeProfit = IfBuyAtrTP(AtrTakeProfit);
                  double stopLoss = IfBuyAtrSL(AtrStopLoss);
                  ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 30, stopLoss, takeProfit,NULL, magicNumber);
               }
            } else if(tradeWhenBigATR){
                 double takeProfit = IfBuyAtrTP(AtrTakeProfit);
                 double stopLoss = IfBuyAtrSL(AtrStopLoss);
                 ticketNumer = OrderSend(NULL,OP_BUY, lotSize, Ask, 30, stopLoss, takeProfit,NULL, magicNumber);
            }
                
          }
      
     else if((((Bid < baseline && Open[0]<baseline && Open[1]>baseline)    //Baseline подродно
            || (Bid < baseline && Close[1]<baseline && Open[1]>baseline))
            && (buyLine < sellLine)                                        //Crossline
            && (greaterBuy < greaterSell)                                  //Trend
            && (levelLine < downLine)                                      //Volume
            ) ||
         
            ((Bid < baseline && Open[0]<baseline)                          //Baseline
            && (buyLine < sellLine && prevBuyLine > prevSellLine)          //Crossline подродно
            && (greaterBuy < greaterSell)                                  //Trend
            && (levelLine < downLine)                                      //Volume
            ) ||
         
            ((Bid < baseline && Open[0]<baseline)                          //Baseline
            && (buyLine < sellLine)                                        //Crossline
            && (greaterBuy < greaterSell && prevGreaterBuy > prevGreaterSell) //Trend подродно
            && (levelLine < downLine)                                      //Volume
            ) ||
            
            ((Bid < baseline && Open[0]<baseline)                          //Baseline
            && (buyLine < sellLine)                                        //Crossline
            && (greaterBuy < greaterSell)                                  //Trend 
            && (levelLine < downLine && prevLevelLine > prevDownLine)      //Volume подродно
            ))
         {
         
            if(!tradeWhenBigATR) {
                  if((baseline-Bid) < atrValue) {
                     double takeProfit = IfSellAtrTP(AtrTakeProfit);
                     double stopLoss = IfSellAtrSL(AtrStopLoss);
                     ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 30, stopLoss, takeProfit,NULL, magicNumber);
                  }
            } else if(tradeWhenBigATR){
                double takeProfit = IfSellAtrTP(AtrTakeProfit);
                double stopLoss = IfSellAtrSL(AtrStopLoss);
                ticketNumer = OrderSend(NULL,OP_SELL, lotSize, Bid, 30, stopLoss, takeProfit,NULL, magicNumber); 
            }
            
         }
   }
}



//ПРАВИЛА ЗА ИЗХОД ПРИ Baseline + C1 Crossline + C2 Trend
void BaseCrossTrendVolExit(double baseline, double buyLine, double sellLine, 
                           double greaterSell, double greaterBuy, int magicNumber) {   
   int openOrders = OrdersTotal();
   
   if(openOrders>0) {
      for(int i =openOrders-1;i>=0; i--) {
         if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES)) {
         
            if(OrderType()==OP_BUY && OrderMagicNumber()==magicNumber 
               && (baseline > Close[1] || sellLine > buyLine || greaterBuy < greaterSell)) {
               
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,5)) 
               Print("Failure to close the order");
            }
            
            else if(OrderType()==OP_SELL && OrderMagicNumber()==magicNumber 
                     && (baseline < Close[1] || sellLine < buyLine || greaterBuy > greaterSell)) {
                     
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,5)) 
               Print("Failure to close the order");
            }
         }
      }
   }
}