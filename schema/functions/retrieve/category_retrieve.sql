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
            SELECT    C.category_name, C.numOfCard,
                      array_agg(DISTINCT ACH.card_id),
                      ACF.mastery_score,
                      C.date_created
            FROM      ACCOUNT_CATEGORY_FOLLOW ACF
            JOIN CATEGORY C ON C.category_id = ACF.category_id
            LEFT JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = C.category_id
            LEFT JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = p_owner
            WHERE ACF.account_id = p_owner
              AND ACF.category_id = p_category_id
            GROUP BY C.category_name, C.date_created, ACF.mastery_score, C.numOfCard;
          END
          $$ LANGUAGE plpgsql;