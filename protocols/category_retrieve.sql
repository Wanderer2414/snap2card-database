CREATE
OR        REPLACE FUNCTION CATEGORY_RETRIEVE (p_session_id TYPE_ID, p_id TYPE_ID) RETURNS TABLE (
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
            RETURN QUERY 
            SELECT C.category_name, C.numOfCard, 
                  (SELECT array_agg(FN_CARD_ID(CID.card_id)) FROM unnest(C.card_ids) as CID(card_id)), 
                  C.YEAR, C.MONTH, C.DAY, C.HOUR, C.MINUTE, C.SECOND, C.gmt 
            FROM FN_CATEGORY_RETRIEVE(FN_SESSION_CHECK(p_session_id), FN_ID_CATEGORY(p_id)) C;
          END
          $$ LANGUAGE plpgsql;