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
    SELECT component_id INTO v_id FROM COMPONENT WHERE component_text = p_text;
    RETURN v_id;
END $$ LANGUAGE plpgsql;