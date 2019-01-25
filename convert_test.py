import pandas as pd
import glob

dataDir = r"C:\\Users\\Thijs\\AppData\\Roaming\\MetaQuotes\\Terminal\\716A697617E9A5A0D5AF0DA145BC61F6\\MQL4\\Files\\HistoryAgg\\1"
cols = ["Pair", 'Date', 'O', 'H', "L", "C", "V", "Up", "Low", "Base",
        "Rsi", "Signal", "e5", "e13", "e50", "e200", "e800"]
dir = glob.glob(dataDir + "/*.csv")

dfs = []
for file in dir:
    df = pd.read_csv(file, names=cols, header=None, delimiter=",")
    dfs.append(df)

df = pd.concat(dfs, axis=0)
date = df.loc[df["Pair"] == "EURUSD"].Date
str = date.iloc[0][11] + date.iloc[0][12] + \
    df.Date.iloc[0][13] + df.Date.iloc[0][14] + df.Date.iloc[0][15]
df.Date = str


# df.set_index("Pair", inplace=True)
# json = df.to_json(orient='index', date_format=None)
# print(json)


# add functionallity to filter on sharkfins etc than the server can react
# by displaying in browser and sending msg to slack/telegram
