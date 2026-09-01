CREATE
OR        REPLACE FUNCTION CATEGORY_RETRIEVE (p_session_id TYPE_ID) RETURNS TABLE (
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
            RETURN QUERY 
            SELECT    FN_CATEGORY_ID(C.category_id), C.category_name, CAST(COUNT(DISTINCT CCC.card_id) AS INTEGER), (FN_GET_GMT(MIN(ACH.date_created))).*
            FROM      CATEGORY C
            JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = C.category_id
            JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = FN_SESSION_CHECK(p_session_id)
            GROUP BY C.category_id, C.category_name;
          END
          $$ LANGUAGE plpgsql;