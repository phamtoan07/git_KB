SET DEFINE ON

REM
REM Create a database administration user cacheuseradmin for managing the 
REM

CREATE USER cacheuseradmin IDENTIFIED BY timesten;
GRANT ADMIN TO cacheuseradmin;
DEFINE cache_password=timesten;
