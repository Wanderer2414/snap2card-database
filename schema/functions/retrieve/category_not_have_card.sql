CREATE
OR        REPLACE FUNCTION FN_CATEGORY_NOT_HAVE_CARD (p_account_id INT, p_card_id INT) RETURNS TABLE (category_id INT, category_name TYPE_NAME_CATEGORY) AS $$
BEGIN
    RETURN QUERY
    SELECT C.category_id, C.category_name
    FROM CATEGORY C
    WHERE C.owner_id IS NOT DISTINCT FROM p_account_id
      AND C.category_id NOT IN  (
          SELECT CCC.category_id
          FROM CATEGORY_CARD_CONTAIN CCC
          WHERE CCC.card_id = p_card_id
      );
END
$$ LANGUAGE plpgsql;