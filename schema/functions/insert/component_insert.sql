-- CREATE    TABLE COMPONENT (
--           component_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY                   ,
--           component_text TEXT                                                         ,
--           owner_id INT NOT NULL                                                       ,
--           date_created TIMESTAMPTZ DEFAULT NOW()                                      ,
--           num_of_length INT GENERATED ALWAYS AS (count_words (component_text)) STORED ,
--           FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
--           );
CREATE
OR        REPLACE FUNCTION FN_COMPONENT_INSERT (p_text TEXT, p_id INT) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO COMPONENT(component_text, owner_id) VALUES (p_text, p_id)
    ON CONFLICT DO NOTHING
    RETURNING COMPONENT.component_id INTO v_id;

    IF v_id IS NULL THEN
        SELECT COMPONENT.component_id INTO v_id FROM COMPONENT WHERE LOWER(component_text) = LOWER(p_text);
    END IF;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_COMPONENT_INSERT (p_text TEXT[], p_id INT) RETURNS TABLE (component_id INT) AS $$
DECLARE
    v_id INT[];
BEGIN
    RETURN QUERY
    INSERT INTO COMPONENT(component_text, owner_id)
    SELECT C.text, p_id FROM unnest(p_text) AS C(text)
    ON CONFLICT (component_text) DO UPDATE SET owner_id = EXCLUDED.owner_id
    RETURNING COMPONENT.component_id;
END;
$$ LANGUAGE plpgsql;