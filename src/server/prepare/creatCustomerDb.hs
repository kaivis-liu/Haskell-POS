
import Database.HDBC.Sqlite3 (connectSqlite3)
import Database.HDBC


creatCustomerDb ::  IO ()
creatCustomerDb  =
                 do 
                   conn <- connectSqlite3 "customer.db"
                   run conn "CREATE TABLE test (name VARCHAR(80), password VARCHAR(80))" []                  
                   commit conn
                   disconnect conn
        

    