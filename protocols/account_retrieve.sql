CREATE
OR        REPLACE FUNCTION ACCOUNT_RETRIEVE (p_account_id TYPE_ID) RETURNS TABLE (
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
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    RETURN QUERY 
    SELECT A.account_email, A.account_name, A.account_phone, A.YEAR, A.MONTH, A.DAY, A.HOUR, A.MINUTE, A.SECOND, A.gmt
    FROM FN_ACCOUNT_RETRIEVE(FN_ID_ACCOUNT(p_account_id)) AS A;
END;
$$ LANGUAGE plpgsql;