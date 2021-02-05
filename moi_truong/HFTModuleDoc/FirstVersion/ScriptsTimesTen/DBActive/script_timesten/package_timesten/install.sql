-------------------------------------------------------------------
--
--  File : install.sql (SQLPlus script)
--
--  Description : excute FO packages scripts
-------------------------------------------------------------------
--
-- history :   who         created     comment
--     v1.0    tien.do   2014-08-21    creation
--                                     
--
-------------------------------------------------------------------
/*
 * Copyright (C) FSS software. All rights reserved.
 *
 * This software is published under the terms of the The FSS 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.   
 * see: <http://fss.com.vn> */


spool install.txt

PROMPT FO Packages Installation
PROMPT **********************
PROMPT 

---------------------CSPKS_FO_ACCOUNT---------------------
--PROMPT Create package CSPKS_FO_ACCOUNT ...
--@@CSPKS_FO_ACCOUNT
--PROMPT Create package body CSPKS_FO_ACCOUNT ...
--@@Body/CSPKS_FO_ACCOUNT

---------------------CSPKS_FO_COMMON---------------------
PROMPT Create package CSPKS_FO_COMMON ...
@@CSPKS_FO_COMMON
--PROMPT Create package body CSPKS_FO_COMMON ...
--@@Body/CSPKS_FO_COMMON

---------------------CSPKS_FO_VALIDATION---------------------
PROMPT Create package CSPKS_FO_VALIDATION ...
@@CSPKS_FO_VALIDATION
--PROMPT Create package body CSPKS_FO_VALIDATION ...
--@@Body/CSPKS_FO_VALIDATION

---------------------CSPKS_FO_RESET_SEQUENCE---------------------
PROMPT Create package CSPKS_FO_RESET_SEQUENCE ...
@@CSPKS_FO_RESET_SEQUENCE
--PROMPT Create package body CSPKS_FO_RESET_SEQUENCE ...
--@@Body/CSPKS_FO_RESET_SEQUENCE

---------------------CSPKS_FO_POOLROOM---------------------
PROMPT Create package CSPKS_FO_POOLROOM ...
@@CSPKS_FO_POOLROOM
--PROMPT Create package body CSPKS_FO_POOLROOM ...
--@@Body/CSPKS_FO_POOLROOM

---------------------CSPKS_FO_ORDER---------------------
PROMPT Create package CSPKS_FO_ORDER ...
@@CSPKS_FO_ORDER
--PROMPT Create package body CSPKS_FO_ORDER ...
--@@Body/CSPKS_FO_ORDER

---------------------CSPKS_FO_ORDER_ADV---------------------
PROMPT Create package CSPKS_FO_ORDER_ADV ...
@@CSPKS_FO_ORDER_ADV
--PROMPT Create package body CSPKS_FO_ORDER_ADV ...
--@@Body/CSPKS_FO_ORDER_ADV

---------------------CSPKS_FO_ORDER_NEW---------------------
PROMPT Create package CSPKS_FO_ORDER_NEW ...
@@CSPKS_FO_ORDER_NEW
--PROMPT Create package body CSPKS_FO_ORDER_NEW ...
--@@Body/CSPKS_FO_ORDER_NEW

--------------------CSPKS_FO_ORDER_AMEND----------------------
PROMPT Create package CSPKS_FO_ORDER_AMEND ...
@@CSPKS_FO_ORDER_AMEND
--PROMPT Create package body CSPKS_FO_ORDER_AMEND ...
--@@Body/CSPKS_FO_ORDER_AMEND

--------------------CSPKS_FO_ORDER_CROSS----------------------
PROMPT Create package CSPKS_FO_ORDER_CROSS ...
@@CSPKS_FO_ORDER_CROSS
--PROMPT Create package body CSPKS_FO_ORDER_CROSS ...
--@@Body/CSPKS_FO_ORDER_CROSS

----------------------CSPKS_FO_ORDER_RESPONE--------------------
PROMPT Create package CSPKS_FO_ORDER_RESPONE ...
@@CSPKS_FO_ORDER_RESPONE
--PROMPT Create package body CSPKS_FO_ORDER_RESPONE ...
--@@Body/CSPKS_FO_ORDER_RESPONE

--------------------CSPKS_FO_ORDER_CANCEL----------------------
PROMPT Create package CSPKS_FO_ORDER_CANCEL ...
@@CSPKS_FO_ORDER_CANCEL
--PROMPT Create package body CSPKS_FO_ORDER_CANCEL ...
--@@Body/CSPKS_FO_ORDER_CANCEL

---------------------CSPKS_FO_GW_HNX---------------------
PROMPT Create package CSPKS_FO_GW_HNX ...
@@CSPKS_FO_GW_HNX
--PROMPT Create package body CSPKS_FO_GW_HNX ...
--@@Body/CSPKS_FO_GW_HNX

---------------------CSPKS_FO_GW_HSX---------------------
PROMPT Create package CSPKS_FO_GW_HSX ...
@@CSPKS_FO_GW_HSX
--PROMPT Create package body CSPKS_FO_GW_HSX ...
--@@Body/CSPKS_FO_GW_HSX

---------------------CSPKS_FO_TRANS---------------------
PROMPT Create package CSPKS_FO_TRANS ...
@@CSPKS_FO_TRANS
--PROMPT Create package body CSPKS_FO_TRANS ...
--@@Body/CSPKS_FO_TRANS


spool off

