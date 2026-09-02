CREATE
OR        REPLACE FUNCTION COMPONENT_RETRIEVE (p_text TEXT) RETURNS TYPE_ID AS $$
DECLARE
    v_id INT;
BEGIN
    IF p_text IS NULL THEN
        RAISE EXCEPTION 'text must not be null' USING ERRCODE = '50001';
    END IF;

    IF count_words(p_text) > 10 THEN
        RAISE EXCEPTION 'excess num of keywords' USING ERRCODE = '50007';
    END IF;

    v_id := FN_COMPONENT_RETRIEVE(p_text);

    IF v_id IS NULL THEN
        RAISE EXCEPTION 'component not found' USING ERRCODE = '50004';
    END IF;

    RETURN FN_COMPONENT_ID(v_id);
END
$$ LANGUAGE plpgsql;