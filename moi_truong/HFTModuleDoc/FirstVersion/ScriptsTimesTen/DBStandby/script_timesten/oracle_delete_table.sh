#!/bin/sh

echo 
echo delete table

cd /home/fo/newfo/script_timesten/
sqlplus -s FOPRO/FOPRO@HFT << EOF
whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off


@oracle_delete_table.sql

exit;
EOF

