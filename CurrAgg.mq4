#property copyright "Thijs"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
string pathTDI = "TrueBTMM\\!btmm_TDI_Plus";
int timeframe = 1;
int shift = 1;
datetime LastActionTime;

//first major pairs second 
string pairs[] = {"AUDUSD",
                  "EURUSD",
                  "GBPUSD",
                  "USDCAD",
                  "USDJPY",
                  "USDCHF",
                  "AUDCAD",
                  "AUDCHF",
                  "AUDJPY",
                  "AUDNZD",
                  "CADCHF",
                  "CADJPY",
                  "CHFJPY",
                  "EURAUD",
                  "EURCHF",
                  "EURCAD",
                  "EURGBP",
                  "EURJPY",
                  "EURNZD",
                  "GBPAUD",
                  "GBPCAD",
                  "GBPCHF",
                  "GBPJPY",
                  "GBPNZD",
                  "NZDCAD",
                  "NZDCHF",
                  "NZDJPY",
                  "NZDUSD",
                  "USDSGD",
                  };

struct dataStructure {
   datetime  D;               
   double    O;               
   double    H;              
   double    L;               
   double    C;              
   long      V;               
   double    TDIUpperBand;    
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

string fileName = StringConcatenate("CurrAgg\\",timeframe, "\\Data.csv");
   int filehandle = FileOpen(fileName, FILE_CSV|FILE_READ|FILE_WRITE, ",");

void get(string Lpair){
   dataStructure currentData;
   currentData.D = iTime(Lpair, timeframe, shift);
   currentData.O = iOpen(Lpair, timeframe, shift);
   currentData.H = iHigh(Lpair, timeframe, shift);
   currentData.L = iLow(Lpair, timeframe, shift);
   currentData.C = iClose(Lpair, timeframe, shift);
   currentData.V = iVolume(Lpair, timeframe, shift);
   currentData.TDIUpperBand = iCustom(Lpair, timeframe, pathTDI, 0, shift);
   currentData.TDILowerBand = iCustom(Lpair, timeframe, pathTDI, 1, shift);
   currentData.TDIBaseLine = iCustom(Lpair, timeframe, pathTDI, 2, shift);
   currentData.TDISignalLine = iCustom(Lpair, timeframe, pathTDI, 3, shift);
   currentData.TDIRsiLine = iCustom(Lpair, timeframe, pathTDI, 4, shift);
   currentData.Ema5 = iMA(Lpair, timeframe, 5,0,1,0,shift);
   currentData.Ema13 = iMA(Lpair, timeframe, 13,0,1,0,shift);
   currentData.Ema50 = iMA(Lpair, timeframe, 50,0,1,0,shift);
   currentData.Ema200 = iMA(Lpair, timeframe, 200,0,1,0,shift);
   currentData.Ema800 = iMA(Lpair, timeframe, 800,0,1,0,shift);
   
   if(FileSeek(filehandle, 0, SEEK_END)){
      FileWrite(filehandle, Lpair, currentData.D, NormalizeDouble(currentData.O,5), NormalizeDouble(currentData.H,5), NormalizeDouble(currentData.L,5), NormalizeDouble(currentData.C,5),
         currentData.V, NormalizeDouble(currentData.TDIUpperBand,3), NormalizeDouble(currentData.TDILowerBand,3), NormalizeDouble(currentData.TDIBaseLine,3), 
         NormalizeDouble(currentData.TDISignalLine,3), NormalizeDouble(currentData.TDIRsiLine,3), NormalizeDouble(currentData.Ema5,5), NormalizeDouble(currentData.Ema13,5), 
         NormalizeDouble(currentData.Ema50,5), NormalizeDouble(currentData.Ema200,5), NormalizeDouble(currentData.Ema800,5));

   }          
   return;
}

int OnInit(){
   FolderClean(StringConcatenate("CurrAgg\\",timeframe));
   for(int i = ArraySize(pairs) - 1; i >= 0; i--){
      get(pairs[i]);
   }
   FileClose(filehandle);
   LastActionTime = Time[0];
   Print("Done");
   return(INIT_SUCCEEDED);
}

void OnTick(){
   if(LastActionTime !=Time[0]){
      FolderClean(StringConcatenate("CurrAgg\\",timeframe));
      Sleep(1000);
      for(int i = ArraySize(pairs) - 1; i >= 0; i--){
          get(pairs[i]);
      }
      FileClose(filehandle);
      LastActionTime = Time[0];
      Print("Done");
   }
}

void OnDeinit(const int reason){

}

