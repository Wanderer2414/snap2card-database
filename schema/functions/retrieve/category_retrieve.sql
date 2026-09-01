-- CREATE    TABLE CATEGORY (
--           category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           category_name TYPE_NAME_CATEGORY UNIQUE NOT NULL
--           );
CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE (p_owner TYPE_ID, p_category_id TYPE_ID) RETURNS TABLE (
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
            SELECT    C.category_name, CAST(COUNT(DISTINCT CCC.card_id) AS INTEGER), (FN_GET_GMT(MIN(ACH.date_created))).*
            FROM      CATEGORY C
            JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = C.category_id AND C.category_id = FN_ID_CATEGORY (p_category_id)
            JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = FN_ID_ACCOUNT(p_owner)
            GROUP BY C.category_name;
          END
          $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE (p_owner TYPE_ID) RETURNS TABLE (
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
            SELECT    C.category_name, CAST(COUNT(DISTINCT CCC.card_id) AS INTEGER), (FN_GET_GMT(MIN(ACH.date_created))).*
            FROM      CATEGORY C
            JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = C.category_id
            JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = FN_ID_ACCOUNT(p_owner)
            GROUP BY C.category_name;
          END
          $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE () RETURNS TABLE (
          category_id TYPE_ID            ,
          category_name TYPE_NAME_CATEGORY
          ) AS $$ BEGIN 
  RETURN QUERY
  SELECT FN_CATEGORY_ID(C.category_id), C.category_name FROM CATEGORY C;
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE (p_category_ids TYPE_ID[]) RETURNS TABLE (
          category_id TYPE_ID            ,
          category_name TYPE_NAME_CATEGORY
          ) AS $$ BEGIN 
  RETURN QUERY
  SELECT FN_CATEGORY_ID(C.category_id), C.category_name FROM CATEGORY C
  WHERE C.category_id IN (SELECT FN_ID_CATEGORY(p_id) FROM unnest(p_category_ids) as CT(p_id));
END
$$ LANGUAGE plpgsql;