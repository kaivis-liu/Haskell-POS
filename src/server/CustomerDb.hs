module CustomerDb where

import Database.HDBC.Sqlite3 (connectSqlite3)
import Database.HDBC


creatCustomerDb ::  IO ()
creatCustomerDb  =
                 do 
                   conn <- connectSqlite3 "customer.db"
                   run conn "CREATE TABLE test (name VARCHAR(80), password VARCHAR(80))" []                  
                   commit conn
                   disconnect conn
        

insertCustomerDb ::  String->String->IO ()
insertCustomerDb  name p = 
                           do
                              conn <- connectSqlite3 "customer.db"
                              run conn "INSERT INTO test VALUES (?, ?)" [toSql name, toSql p]
                              commit conn
                              disconnect conn

query :: String -> IO ()
query name = do
                conn <- connectSqlite3 "customer.db"
                r <- quickQuery' conn
                    "SELECT name, password from test where name == ? ORDER BY name, password"
                     [toSql name]
                let info = map convRow r      
                mapM_ putStrLn info 
                disconnect conn          
           where convRow :: [SqlValue] -> String
                 convRow [n, p]  = show $ n1 ++ ": " ++ p1   
                  where n1 = (fromSql n)::String  
                        p1 = (fromSql p)::String 
  
  


match :: String -> String -> Bool -> IO ()              
match n p res = do
                   conn <- connectSqlite3 "customer.db"
                   r <- quickQuery' conn
                       "SELECT name, password from test where name== ? ORDER BY name, password"
                        [toSql n]
                   let info = map convRow r      
                  -- mapM_ print info 
                   disconnect conn
              where convRow :: [SqlValue] -> Bool
                    convRow [n1, p1]  = if(p==p2) then True else False  
                     where n2 = (fromSql n1)::String  
                           p2 = (fromSql p1)::String 


--          
                          
showDataBase = do  
                  conn <- connectSqlite3 "customer.db"
                  stmt <- prepare conn "SELECT * from test "
                  execute stmt []
                  results <- fetchAllRowsAL stmt
                  mapM_ print results
                  return ()
 
                  
--match :: String ->String -> IO ()                 
--match n p =do 
--               conn <- connectSqlite3 "customer.db"
--               stmt <- prepare conn "SELECT * from test "
--               execute stmt []
--               results <- fetchAllRowsAL stmt
--               let ok = findelem results 
--               return ()
--              where findelem :: [SqlValue] -> Bool
--                    findelem [n1, p1]  = if ( (fromSql n1)::String == n ) then True
--                                                                                  else False
                                          
           
--main = do  
--                  creatCustomerDb
--                  insertCustomerDb  "kaivis" "123"
--                  insertCustomerDb  "chu" "123456"
--                  conn <- connectSqlite3 "customer.db"
--                  stmt <- prepare conn "SELECT * from test "
--                  execute stmt []
--                  results <- fetchAllRowsAL stmt
--                  mapM_ print results
--                  return ()        