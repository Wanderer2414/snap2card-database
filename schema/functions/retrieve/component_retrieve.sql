CREATE
OR        REPLACE FUNCTION FN_COMPONENT_RETRIEVE (p_id INT) RETURNS TEXT AS $$ 
DECLARE 
    v_text TEXT;
BEGIN 
    SELECT component_text INTO v_text FROM COMPONENT WHERE component_id = p_id;
    RETURN v_text;
END $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_COMPONENT_RETRIEVE (p_text TEXT) RETURNS INT AS $$ 
DECLARE 
    v_id INT;
BEGIN 
    IF (count_words(p_text) > 10) THEN
        RAISE EXCEPTION 'Excess num of keyword!';
    END IF;

    SELECT component_id INTO v_id FROM COMPONENT WHERE component_text = p_text;
    RETURN v_id;
END $$ LANGUAGE plpgsql;