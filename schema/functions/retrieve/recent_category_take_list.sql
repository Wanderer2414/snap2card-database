CREATE
OR        REPLACE FUNCTION FN_RECENT_CATEGORY_TAKE_LIST (p_owner INT, p_n INT) RETURNS TABLE (
          category_id INT                 ,
          category_name TYPE_NAME_CATEGORY,
          mastery FLOAT                   ,
          date_created TIMESTAMPTZ
          ) AS $$
BEGIN
    RETURN QUERY
    SELECT TC.category_id, C.category_name, ACF.mastery_score, TC.latest_take
    FROM (
        SELECT DISTINCT ON (ECR.category_id)
               ECR.category_id, EL.start_time AS latest_take
        FROM SESSION S
        JOIN EXAM_LOG EL ON EL.session_id = S.session_id
        JOIN EXAM E      ON E.exam_id = EL.exam_id
        JOIN EXAM_CATEGORY_RELATED ECR ON ECR.exam_id = E.exam_id
        WHERE S.owner_id = p_owner
        ORDER BY ECR.category_id, EL.start_time DESC
    ) TC
    JOIN CATEGORY C ON C.category_id = TC.category_id
    JOIN ACCOUNT_CATEGORY_FOLLOW ACF ON ACF.account_id = p_owner AND ACF.category_id = TC.category_id
    ORDER BY TC.latest_take DESC
    LIMIT p_n;
END
$$ LANGUAGE plpgsql;