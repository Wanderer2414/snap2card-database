CREATE
OR        REPLACE FUNCTION RECENT_CATEGORY_TAKE_LIST (
          p_account_id TYPE_ID,
          p_n INT
          ) RETURNS TABLE (
          category_id TYPE_ID             ,
          category_name TYPE_NAME_CATEGORY,
          mastery FLOAT                   ,
          YEAR INTEGER                    ,
          MONTH INTEGER                   ,
          DAY INTEGER                     ,
          HOUR INTEGER                    ,
          MINUTE INTEGER                  ,
          SECOND INTEGER                  ,
          gmt CHAR(3)
          ) AS $$
DECLARE
    v_owner INT;
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_n IS NULL THEN
        RAISE EXCEPTION 'n must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_owner := FN_ID_ACCOUNT(p_account_id);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'account does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY 
    SELECT FN_CATEGORY_ID(C.category_id), C.category_name, C.mastery,
           (FN_GET_GMT(C.date_created)).YEAR,
           (FN_GET_GMT(C.date_created)).MONTH,
           (FN_GET_GMT(C.date_created)).DAY,
           (FN_GET_GMT(C.date_created)).HOUR,
           (FN_GET_GMT(C.date_created)).MINUTE,
           (FN_GET_GMT(C.date_created)).SECOND,
           (FN_GET_GMT(C.date_created)).gmt
    FROM FN_RECENT_CATEGORY_TAKE_LIST(v_owner, GREATEST(p_n, 0)) AS C;
END
$$ LANGUAGE plpgsql;