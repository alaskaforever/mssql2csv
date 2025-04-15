# mssql2csv
Executes queries from multiple sql files and stores outputs as csv files

1. git clone https://alaskaforever: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@github.com/alaskaforever/mssql2csv.git
2. cd mssql2csv
3. go build -o mssql2csv
4. set variable values in .env file
5. great success

Example:
minaise@RPC13-02:~/tmp/mssql2csv$ time ./mssql2csv *.sql
✅ assets.sql -> assets.csv
✅ networks.sql -> networks.csv
✅ switchports.sql -> switchports.csv
✅ vm_guests.sql -> vm_guests.csv

real    0m0.060s
user    0m0.010s
sys     0m0.010s

time elapsed 60 milliseconds :)

