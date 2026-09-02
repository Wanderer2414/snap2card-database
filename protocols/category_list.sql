CREATE
OR        REPLACE FUNCTION CATEGORY_LIST (p_account_id TYPE_ID) RETURNS TABLE (
          category_id TYPE_ID             ,
          category_name TYPE_NAME_CATEGORY,
          numOfCard INT                   ,
          YEAR INTEGER                    ,
          MONTH INTEGER                   ,
          DAY INTEGER                     ,
          HOUR INTEGER                    ,
          MINUTE INTEGER                  ,
          SECOND INTEGER                  ,
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
            SELECT    FN_CATEGORY_ID(C.category_id), C.category_name, C.numOfCard, C.YEAR, C.MONTH, C.DAY, C.HOUR, C.MINUTE, C.SECOND, C.gmt
            FROM      FN_CATEGORY_LIST(FN_ID_ACCOUNT(p_account_id)) C;
          END
          $$ LANGUAGE plpgsql;