CREATE
OR        REPLACE FUNCTION CARD_RETRIEVE (p_ids TYPE_ID[]) RETURNS TABLE (
          card_id TYPE_ID    ,
          frontside_text TEXT,
          backside_text TEXT
          ) AS $$
BEGIN
    RETURN QUERY 
    SELECT FN_CARD_ID(C.card_id), FS.component_text, BS.component_text FROM CARD C
    JOIN COMPONENT FS ON FS.component_id = C.frontside_id
    JOIN COMPONENT BS ON BS.component_id = C.backside_id
    WHERE C.card_id in (SELECT FN_ID_CARD(Card.id) FROM unnest(p_ids) AS Card(id));
END
$$ LANGUAGE plpgsql;