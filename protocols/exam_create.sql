CREATE
OR        REPLACE FUNCTION EXAM_CREATE (p_category_id TYPE_ID) RETURNS TYPE_ID AS $$ 
DECLARE 
    v_id INT;
BEGIN
    v_id := FN_ID_CATEGORY(p_category_id);
    IF (v_id IS NULL) THEN RETURN NULL; END IF;
    v_id := FN_EXAM_CREATE(v_id);
    IF (v_id IS NULL) THEN RETURN NULL; END IF;
    RETURN FN_EXAM_ID(v_id);
END $$ LANGUAGE plpgsql;