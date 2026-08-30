-- CREATE    TABLE ACCOUNT (
--           account_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           account_email TYPE_EMAIL UNIQUE NOT NULL               ,
--           account_name TYPE_NAME_ACCOUNT NOT NULL                ,
--           account_phone TYPE_PHONE NOT NULL                      ,
--           account_password TYPE_PASSWORD_CRYPTED NOT NULL        ,
--           date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL
--           );
CREATE
OR        REPLACE FUNCTION FN_ACCOUNT_RETRIEVE (p_id INT) RETURNS TABLE (
          account_email TYPE_EMAIL      ,
          account_name TYPE_NAME_ACCOUNT,
          account_phone TYPE_PHONE      ,
          YEAR INTEGER                  ,
          MONTH INTEGER                 ,
          DAY INTEGER                   ,
          HOUR INTEGER                  ,
          MINUTE INTEGER                ,
          SECOND INTEGER                ,
          gmt CHAR(3)
          ) AS $$
BEGIN
    RETURN QUERY 
    SELECT A.account_email, A.account_name, A.account_phone, (FN_GET_GMT(A.date_created)).* FROM ACCOUNT A WHERE account_id = p_id;
END;
$$ LANGUAGE plpgsql;