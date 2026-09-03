-- CREATE    TABLE CATEGORY (
--           category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           category_name TYPE_NAME_CATEGORY UNIQUE NOT NULL
--           );
CREATE
OR        REPLACE FUNCTION FN_CATEGORY_LIST (p_owner INT, p_category_id INT) RETURNS TABLE (
          category_name TYPE_NAME_CATEGORY,
          numOfCard INT                   ,
          date_created TIMESTAMPTZ
          ) AS $$
          BEGIN
            RETURN QUERY 
            SELECT    C.category_name, C.numOfCard, C.date_created
            FROM      CATEGORY C
            WHERE     C.category_id = p_category_id;
          END
          $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_LIST (p_owner INT) RETURNS TABLE (
          category_id INT                 ,
          category_name TYPE_NAME_CATEGORY,
          numOfCard INT                   ,
          mastery FLOAT                   ,
          date_created TIMESTAMPTZ
          ) AS $$
          BEGIN
            RETURN QUERY 
            SELECT    C.category_id, C.category_name, C.numOfCard,
                      ACF.mastery_score, C.date_created
            FROM      ACCOUNT_CATEGORY_FOLLOW ACF
            JOIN CATEGORY C ON C.category_id = ACF.category_id AND ACF.account_id = p_owner;
          END
          $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_LIST () RETURNS TABLE (category_id INT, category_name TYPE_NAME_CATEGORY) AS $$ BEGIN 
  RETURN QUERY
  SELECT C.category_id, C.category_name FROM CATEGORY C;
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CATEGORY_LIST (p_category_ids INT[]) RETURNS TABLE (category_id INT, category_name TYPE_NAME_CATEGORY) AS $$ BEGIN 
  RETURN QUERY
  SELECT C.category_id, C.category_name FROM CATEGORY C
  WHERE C.category_id IN (SELECT p_id FROM unnest(p_category_ids) as CT(p_id));
END
$$ LANGUAGE plpgsql;