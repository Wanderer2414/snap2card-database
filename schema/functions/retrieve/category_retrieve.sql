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
            SELECT    C.category_name, C.numOfCard                   ,
                      CASE WHEN C.numOfCard > 0 THEN 
                        (SELECT array_agg(CCC.card_id) FROM CATEGORY_CARD_CONTAIN CCC WHERE CCC.category_id = p_category_id)
                      ELSE ARRAY[]::INT[] END        AS card_ids                                                               ,
                      ACF.mastery_score                                                                                        ,
                      C.date_created
            FROM      ACCOUNT_CATEGORY_FOLLOW ACF
            JOIN CATEGORY C ON C.category_id = ACF.category_id  AND C.category_id = p_category_id
            WHERE ACF.account_id = p_owner
            GROUP BY C.category_name, C.date_created, ACF.mastery_score, C.numOfCard;
          END
          $$ LANGUAGE plpgsql;