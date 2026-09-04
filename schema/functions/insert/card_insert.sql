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
    ON CONFLICT DO NOTHING
    RETURNING CARD.card_id INTO v_id;

    IF v_id IS NULL THEN
        SELECT CARD.card_id INTO v_id
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

CREATE
OR        REPLACE FUNCTION FN_CARD_INSERT (p_cards TYPE_CARD_INSERT_INTERNAL[], p_owner INT) RETURNS TABLE (card_id INT) AS $$
BEGIN
    RETURN QUERY
    WITH card_ids AS (
        INSERT INTO CARD(frontSide_id, backSide_id, creator_id)
        SELECT C.front_id, C.back_id, p_owner FROM unnest(p_cards) AS C(front_id, back_id)
        ON CONFLICT (frontSide_id, backSide_id) DO UPDATE SET creator_id = EXCLUDED.creator_id
        RETURNING CARD.card_id
    )                    ,
    inserted_ids AS (
        INSERT INTO ACCOUNT_CARD_HAVE(account_id, card_id) 
        SELECT p_owner, C.card_id FROM card_ids C
        ON CONFLICT DO NOTHING
        RETURNING ACCOUNT_CARD_HAVE.card_id
    )               ,
    conflict_ids AS (
        SELECT ACH.card_id FROM ACCOUNT_CARD_HAVE AS ACH WHERE (ACH.card_id IN (SELECT * FROM card_ids)) AND (ACH.account_id = p_owner)
    )
    SELECT * FROM inserted_ids
    UNION ALL
    SELECT * FROM conflict_ids;
END;
$$ LANGUAGE plpgsql;