-- CREATE    TABLE CARD (
--           card_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY                  ,
--           frontside_id INT NOT NULL                                             ,
--           backside_id INT NOT NULL                                              ,
--           creator_id INT NOT NULL                                               ,
--           date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL                       ,
--           FOREIGN KEY (frontside_id) REFERENCES COMPONENT (component_id)        ,
--           FOREIGN KEY (backside_id) REFERENCES COMPONENT (component_id)         ,
--           FOREIGN KEY (creator_id) REFERENCES ACCOUNT (account_id)              ,
--           CONSTRAINT CK_DIFFERENT_FRONT_BACK CHECK (frontside_id <> backside_id)
--           );
CREATE
OR        REPLACE FUNCTION FN_CARD_INSERT (p_frontside INT, p_backside INT, p_creator INT) RETURNS INT AS $$
DECLARE 
    v_id INT;
BEGIN
    IF p_frontside IS NULL THEN
        RAISE EXCEPTION '50001: frontside must not be null';
    END IF;

    IF p_backside IS NULL THEN
        RAISE EXCEPTION '50001: backside must not be null';
    END IF;

    IF p_creator IS NULL THEN
        RAISE EXCEPTION '50001: creator must not be null';
    END IF;

    IF p_frontside = p_backside THEN
        RAISE EXCEPTION '50003: frontside and backside must be different';
    END IF;

    INSERT INTO CARD(frontside_id, backside_id, creator_id) VALUES (p_frontside, p_backside, p_creator)
    RETURNING card_id INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;