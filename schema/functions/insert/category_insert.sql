CREATE
OR        REPLACE FUNCTION FN_CATEGORY_INSERT (p_owner INT, p_name TYPE_NAME_CATEGORY) RETURNS INT AS $$
DECLARE 
    v_id INT;
BEGIN
    INSERT INTO CATEGORY(owner_id, category_name) VALUES (p_owner, p_name)
    ON CONFLICT (owner_id, category_name) DO NOTHING
    RETURNING category_id INTO v_id;

    IF v_id IS NULL THEN
        SELECT category_id INTO v_id FROM CATEGORY WHERE owner_id IS NOT DISTINCT FROM p_owner AND category_name = p_name;
    END IF;

    IF p_owner IS NOT NULL THEN
        INSERT INTO ACCOUNT_CATEGORY_FOLLOW (account_id, category_id)
        VALUES (p_owner, v_id)
        ON CONFLICT (account_id, category_id) DO NOTHING;
    END IF;

    RETURN v_id;
END
$$ LANGUAGE plpgsql;