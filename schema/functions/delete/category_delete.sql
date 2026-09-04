CREATE
OR        REPLACE FUNCTION FN_CATEGORY_DELETE (p_account_id INT, p_category_id INT) RETURNS VOID AS $$
BEGIN
    DELETE FROM ACCOUNT_CATEGORY_FOLLOW WHERE account_id = p_account_id AND category_id = p_category_id;
    DELETE FROM CATEGORY WHERE owner_id = p_account_id AND category_id = p_category_id;
END
$$ LANGUAGE plpgsql;