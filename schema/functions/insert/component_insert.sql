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
    IF p_text IS NULL THEN
        RAISE EXCEPTION '50001: text must not be null';
    END IF;

    IF p_id IS NULL THEN
        RAISE EXCEPTION '50001: owner id must not be null';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = p_id) THEN
        RAISE EXCEPTION '50004: owner id does not exist';
    END IF;

    INSERT INTO COMPONENT(component_text, owner_id) VALUES (p_text, p_id)
    RETURNING component_id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;