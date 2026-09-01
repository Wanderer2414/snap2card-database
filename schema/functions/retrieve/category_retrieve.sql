-- CREATE    TABLE CATEGORY (
--           category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           category_name TYPE_NAME_CATEGORY UNIQUE NOT NULL
--           );
CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE (p_owner INT, p_id INT) RETURNS TABLE (
          category_name TEXT,
          numOfCard INT     ,
          YEAR INTEGER      ,
          MONTH INTEGER     ,
          DAY INTEGER       ,
          HOUR INTEGER      ,
          MINUTE INTEGER    ,
          SECOND INTEGER    ,
          gmt CHAR(3)
          ) AS $$
          BEGIN
            RETURN QUERY 
            SELECT C.category_name, C.numOfCard, (FN_GET_GMT(G.date_created)).* FROM CATEGORY C
            JOIN ACCOUNT_CATEGORY_HAVE G ON G.account_id = p_owner;
          END
          $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE () RETURNS TABLE (category_id INT, category_name TYPE_NAME_CATEGORY) AS $$ BEGIN 
  RETURN QUERY
  SELECT C.category_id, C.category_name FROM CATEGORY C;
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE (p_ids INT[]) RETURNS TABLE (category_id INT, category_name TYPE_NAME_CATEGORY) AS $$ BEGIN 
  RETURN QUERY
  SELECT C.category_id, C.category_name FROM CATEGORY C
  WHERE C.category_id IN (SELECT * FROM unnest(p_ids));
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE (p_id INT) RETURNS TYPE_NAME_CATEGORY AS $$ 
  SELECT C.category_name FROM CATEGORY C
$$ LANGUAGE SQL;