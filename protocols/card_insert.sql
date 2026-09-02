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