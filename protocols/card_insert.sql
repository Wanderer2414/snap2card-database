CREATE
OR        REPLACE FUNCTION CARD_INSERT (
          p_frontside TYPE_ID,
          p_backside TYPE_ID ,
          p_creator TYPE_ID
          ) RETURNS TYPE_ID AS $$
DECLARE
    v_frontside INT;
    v_backside INT ;
    v_creator INT  ;
    v_id INT;
BEGIN
    IF p_frontside IS NULL THEN
        RAISE EXCEPTION 'frontside must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_backside IS NULL THEN
        RAISE EXCEPTION 'backside must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_creator IS NULL THEN
        RAISE EXCEPTION 'creator must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_frontside, 1, 4) <> 'COMP' THEN
        RAISE EXCEPTION 'invalid component id format' USING ERRCODE = '50006';
    END IF;

    IF SUBSTRING(p_backside, 1, 4) <> 'COMP' THEN
        RAISE EXCEPTION 'invalid component id format' USING ERRCODE = '50006';
    END IF;

    IF SUBSTRING(p_creator, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_frontside := FN_ID_COMPONENT(p_frontside);
    v_backside  := FN_ID_COMPONENT(p_backside);
    v_creator   := FN_ID_ACCOUNT(p_creator);

    IF v_frontside = v_backside THEN
        RAISE EXCEPTION 'frontside and backside must be different' USING ERRCODE = '50003';
    END IF;
    v_id := FN_CARD_INSERT(v_frontside, v_backside, v_creator);
    IF v_id IS NULL THEN RETURN v_id; END IF;
    RETURN FN_CARD_ID(v_id);
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION CARD_INSERT (p_cards TYPE_CARD_INSERT[], p_owner TYPE_ID) RETURNS TABLE (card_id TYPE_ID) AS $$
DECLARE
    c TYPE_CARD_INSERT;
    v_owner INT;
    v_row RECORD;
BEGIN
    IF p_cards IS NULL THEN
        RAISE EXCEPTION 'cards must not be null' USING ERRCODE = '50001';
    END IF;

    IF array_length(p_cards, 1) IS NULL THEN
        RAISE EXCEPTION 'cards must not be empty' USING ERRCODE = '50001';
    END IF;

    IF p_owner IS NULL THEN
        RAISE EXCEPTION 'owner id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_owner, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    FOREACH c IN ARRAY p_cards LOOP
        IF c.frontSide_id IS NULL THEN
            RAISE EXCEPTION 'frontside must not be null' USING ERRCODE = '50001';
        END IF;

        IF c.backSide_id IS NULL THEN
            RAISE EXCEPTION 'backside must not be null' USING ERRCODE = '50001';
        END IF;

        IF SUBSTRING(c.frontSide_id, 1, 4) <> 'COMP' THEN
            RAISE EXCEPTION 'invalid component id format' USING ERRCODE = '50006';
        END IF;

        IF SUBSTRING(c.backSide_id, 1, 4) <> 'COMP' THEN
            RAISE EXCEPTION 'invalid component id format' USING ERRCODE = '50006';
        END IF;

        IF FN_ID_COMPONENT(c.frontSide_id) = FN_ID_COMPONENT(c.backSide_id) THEN
            RAISE EXCEPTION 'frontside and backside must be different' USING ERRCODE = '50003';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM COMPONENT WHERE component_id = FN_ID_COMPONENT(c.frontSide_id)) THEN
            RAISE EXCEPTION 'frontside component not found' USING ERRCODE = '50004';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM COMPONENT WHERE component_id = FN_ID_COMPONENT(c.backSide_id)) THEN
            RAISE EXCEPTION 'backside component not found' USING ERRCODE = '50004';
        END IF;
    END LOOP;

    v_owner := FN_ID_ACCOUNT(p_owner);
    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'owner id does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY
    SELECT FN_CARD_ID(i.card_id) FROM FN_CARD_INSERT(
        (SELECT array_agg(ROW(FN_ID_COMPONENT(front), FN_ID_COMPONENT(back))::__TYPE_CARD_INSERT) FROM unnest(p_cards) AS X(front, back))
    , v_owner) AS i;
END
$$ LANGUAGE plpgsql;