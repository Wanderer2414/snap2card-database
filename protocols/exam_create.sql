CREATE
OR        REPLACE FUNCTION EXAM_CREATE (p_category_id TYPE_ID) RETURNS TYPE_ID AS $$ 
DECLARE 
    v_id INT;
BEGIN
    IF p_category_id IS NULL THEN
        RAISE EXCEPTION 'category id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_category_id, 1, 4) <> 'CATE' THEN
        RAISE EXCEPTION 'invalid category id format' USING ERRCODE = '50006';
    END IF;

    v_id := FN_ID_CATEGORY(p_category_id);
    IF NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = v_id) THEN
        RAISE EXCEPTION 'category not found' USING ERRCODE = '50004';
    END IF;

    v_id := FN_EXAM_CREATE(v_id);
    RETURN FN_EXAM_ID(v_id);
END $$ LANGUAGE plpgsql;