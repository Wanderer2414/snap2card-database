CREATE
OR        REPLACE FUNCTION CATEGORY_RETRIEVE (p_account_id TYPE_ID, p_id TYPE_ID) RETURNS TABLE (
          category_name TYPE_NAME_CATEGORY,
          numOfCard INT                   ,
          card_ids TYPE_ID[]              ,
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

            IF p_id IS NULL THEN
                RAISE EXCEPTION 'category id must not be null' USING ERRCODE = '50001';
            END IF;

            IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
                RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
            END IF;

            IF SUBSTRING(p_id, 1, 4) <> 'CATE' THEN
                RAISE EXCEPTION 'invalid category id format' USING ERRCODE = '50006';
            END IF;

            RETURN QUERY 
            SELECT C.category_name, C.numOfCard, 
                  (SELECT array_agg(FN_CARD_ID(CID.card_id)) FROM unnest(C.card_ids) as CID(card_id)) AS card_ids, 
                  C.YEAR, C.MONTH, C.DAY, C.HOUR, C.MINUTE, C.SECOND, C.gmt 
            FROM FN_CATEGORY_RETRIEVE(FN_ID_ACCOUNT(p_account_id), FN_ID_CATEGORY(p_id)) C;
          END
          $$ LANGUAGE plpgsql;