-- CREATE
-- OR        REPLACE FUNCTION FN_ACCOUNT_INSERT (
--           p_name TYPE_NAME_ACCOUNT,
--           p_email TYPE_EMAIL      ,
--           p_phone TYPE_PHONE      ,
--           p_password TYPE_PASSWORD
--           ) RETURNS INT AS $$ 
SELECT    FN_ACCOUNT_INSERT ('tester', 'tester@gmail.com', 0944444444, '1234');