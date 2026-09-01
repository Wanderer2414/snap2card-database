CREATE
OR        REPLACE FUNCTION FN_CATEGORY_INSERT (p_name TYPE_NAME_CATEGORY) RETURNS INT AS $$
DECLARE 
    v_id INT;
BEGIN
    INSERT INTO CATEGORY(category_name) VALUES (p_name)
    ON CONFLICT (category_name) DO NOTHING
    RETURNING category_id INTO v_id;

    IF v_id IS NULL THEN
        SELECT category_id INTO v_id FROM CATEGORY WHERE category_name = p_name;
    END IF;

    RETURN v_id;
END
$$ LANGUAGE plpgsql;