//+------------------------------------------------------------------+
//|                                                    OHLCtoCSV.mq4 |
//|                                                            Thijs |
//|                                             http://www.inseed.nl |
//+------------------------------------------------------------------+
#property copyright "Thijs"
#property link      "http://www.inseed.nl"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+


// om shift te vinden doe zo groot mogelijk en kijk wanneer je 1970 als date krijgt
//ga dan in csv file en kijk wanneer echte waardes komen haal die dat verschil van je shift af
//dat is je max shift 
//0         = Current timeframe
//1         =1 minute         ong 65.125
//5         =5 minutes
//15        =15 minutes       ong 15.462
//30        =30 minutes
//60        =1 hour           ong 12.000
//240       =4 hours
//1440      =1 day
//10080     =1 week
//43200     =1 month

//Files are written to C:\Users\Thijs\AppData\Roaming\MetaQuotes\Terminal\9082373EE32FC7CCE068116E17943C8E\MQL4\Files\CSVs
struct dataStructure {
   datetime  D;               
   double    O;               
   double    H;              
   double    L;               
   double    C;              
   long      V;               
   double    TDIUpperBand;    //index 0 etc.
   double    TDILowerBand;    
   double    TDIBaseLine;
   double    TDISignalLine;
   double    TDIRsiLine;
   double    Ema5;
   double    Ema13;
   double    Ema50;
   double    Ema200;
   double    Ema800;
};

string pathTDI = "TrueBTMM\\!btmm_TDI_Plus";

void OnStart()
  {
   string pair = "GBPCAD";
   int timeframe = 15;
   int shift = 30000;

   get(pair, timeframe, shift);
   double open = iOpen(pair, timeframe, shift);      
   datetime date = iTime(pair, timeframe, shift);
   double TDIUpperBand = iCustom(pair, timeframe, pathTDI, 0, 0);
   Print("  |||  ",pair, "  ---  ", date," --- ",open);
   return;
  }
//+------------------------------------------------------------------+
  
void get(string pair, int timeframe, int shift){
   dataStructure currentData;
   string fileName = StringConcatenate("CSVs\\",pair, "_", timeframe,"_", shift,".csv");
   int filehandle = FileOpen(fileName, FILE_WRITE|FILE_CSV, ",");
   for(int i = shift; i >= 0; i--){
      currentData.D = iTime(pair, timeframe, i);
      currentData.O = iOpen(pair, timeframe, i);
      currentData.H = iHigh(pair, timeframe, i);
      currentData.L = iLow(pair, timeframe, i);
      currentData.C = iClose(pair, timeframe, i);
      currentData.V = iVolume(pair, timeframe, i);
      currentData.TDIUpperBand = iCustom(pair, timeframe, pathTDI, 0, i);
      currentData.TDILowerBand = iCustom(pair, timeframe, pathTDI, 1, i);
      currentData.TDIBaseLine = iCustom(pair, timeframe, pathTDI, 2, i);
      currentData.TDISignalLine = iCustom(pair, timeframe, pathTDI, 3, i);
      currentData.TDIRsiLine = iCustom(pair, timeframe, pathTDI, 4, i);
      currentData.Ema5 = iMA(pair, timeframe, 5,0,1,0,i);
      currentData.Ema13 = iMA(pair, timeframe, 13,0,1,0,i);
      currentData.Ema50 = iMA(pair, timeframe, 50,0,1,0,i);
      currentData.Ema200 = iMA(pair, timeframe, 200,0,1,0,i);
      currentData.Ema800 = iMA(pair, timeframe, 800,0,1,0,i);
      
      FileWrite(filehandle, currentData.D, NormalizeDouble(currentData.O,5), NormalizeDouble(currentData.H,5), NormalizeDouble(currentData.L,5), NormalizeDouble(currentData.C,5),
               currentData.V, NormalizeDouble(currentData.TDIUpperBand,3), NormalizeDouble(currentData.TDILowerBand,3), NormalizeDouble(currentData.TDIBaseLine,3), 
               NormalizeDouble(currentData.TDISignalLine,3), NormalizeDouble(currentData.TDIRsiLine,3), NormalizeDouble(currentData.Ema5,5), NormalizeDouble(currentData.Ema13,5), 
               NormalizeDouble(currentData.Ema50,5), NormalizeDouble(currentData.Ema200,5), NormalizeDouble(currentData.Ema800,5));
      //Print("Pair: ",pair," Shift: ",i, " Timeframe: ", timeframe ," - " "Date: ", currentData.D," ,O: ",NormalizeDouble(currentData.O,5), " ,H: ", NormalizeDouble(currentData.H,5), " ,L: ", NormalizeDouble(currentData.L,5), " ,C: ", NormalizeDouble(currentData.C,5), " ,V: ", currentData.V, ", TDIUpperband: ", NormalizeDouble(currentData.TDIUpperBand,3));
   }
}



