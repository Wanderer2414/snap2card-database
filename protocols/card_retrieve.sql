CREATE
OR        REPLACE FUNCTION CARD_RETRIEVE (p_ids TYPE_ID[]) RETURNS TABLE (
          card_id TYPE_ID    ,
          frontside_text TEXT,
          backside_text TEXT
          ) AS $$
DECLARE
    v_ids INT[];
BEGIN
    IF p_ids IS NULL THEN
        RAISE EXCEPTION 'card ids must not be null' USING ERRCODE = '50001';
    END IF;

    IF EXISTS (SELECT 1 FROM UNNEST(p_ids) AS CID(id) WHERE SUBSTRING(CID.id, 1, 4) <> 'CARD') THEN
        RAISE EXCEPTION 'invalid card id format' USING ERRCODE = '50006';
    END IF;

    SELECT ARRAY_AGG(FN_ID_CARD(CID.id))
    INTO v_ids
    FROM UNNEST(p_ids) AS CID(id);

    RETURN QUERY
    SELECT    FN_CARD_ID(R.card_id), R.frontside_text, R.backside_text
    FROM      FN_CARD_RETRIEVE (v_ids) AS R;
END
$$ LANGUAGE plpgsql;