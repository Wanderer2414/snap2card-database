CREATE
OR        REPLACE FUNCTION CATEGORY_LIST (p_session_id TYPE_ID) RETURNS TABLE (
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
            SELECT    FN_CATEGORY_ID(C.category_id), C.category_name, C.numOfCard, C.YEAR, C.MONTH, C.DAY, C.HOUR, C.MINUTE, C.SECOND, C.gmt
            FROM      FN_CATEGORY_LIST(FN_SESSION_CHECK(p_session_id)) C;
          END
          $$ LANGUAGE plpgsql;