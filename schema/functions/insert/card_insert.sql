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
    v_res INT;
BEGIN
    INSERT INTO CARD (frontside_id, backside_id, creator_id)
    VALUES (p_frontside, p_backside, p_creator)
    ON CONFLICT
    DO NOTHING
    RETURNING card_id INTO v_id;

    IF v_id IS NULL THEN
        SELECT card_id
        INTO v_id
        FROM CARD
        WHERE frontside_id = p_frontside
          AND backside_id = p_backside;
    END IF;

    INSERT INTO ACCOUNT_CARD_HAVE (account_id, card_id)
    VALUES (p_creator, v_id)
    ON CONFLICT (account_id, card_id) DO NOTHING
    RETURNING card_id INTO v_res;

    RETURN v_res;


END;
$$ LANGUAGE plpgsql;