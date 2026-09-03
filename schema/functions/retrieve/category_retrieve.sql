CREATE
OR        REPLACE FUNCTION FN_CATEGORY_RETRIEVE (p_owner INT, p_category_id INT) RETURNS TABLE (
          category_name TYPE_NAME_CATEGORY,
          numOfCard INT                   ,
          card_ids INT[]                  ,
          mastery FLOAT                   ,
          date_created TIMESTAMPTZ
          ) AS $$
          BEGIN
            RETURN QUERY 
            SELECT    C.category_name, CAST(COUNT(DISTINCT CCC.card_id) AS INTEGER), array_agg(CCC.card_id),
                      AVG(ACH.true_count::float / ACH.false_count),
                      MIN(ACH.date_created)
            FROM      CATEGORY C
            JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = C.category_id AND C.category_id = p_category_id
            JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = p_owner
            GROUP BY C.category_name;
          END
          $$ LANGUAGE plpgsql;