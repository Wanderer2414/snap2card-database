CREATE
OR        REPLACE FUNCTION FN_CARD_RETRIEVE (p_ids INT[]) RETURNS TABLE (
          card_id INT        ,
          frontside_text TEXT,
          backside_text TEXT
          ) AS $$
BEGIN
    RETURN QUERY 
    SELECT C.card_id, FS.component_text, BS.component_text FROM CARD C
    JOIN COMPONENT FS ON FS.component_id = C.frontside_id
    JOIN COMPONENT BS ON BS.component_id = C.backside_id
    WHERE C.card_id in (SELECT unnest(p_ids));
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CARD_RETRIEVE (p_id INT) RETURNS TABLE (frontside_text TEXT, backside_text TEXT) AS $$
BEGIN
    RETURN QUERY 
    SELECT FS.component_text, BS.component_text FROM CARD C
    JOIN COMPONENT FS ON FS.component_id = C.frontside_id
    JOIN COMPONENT BS ON BS.component_id = C.backside_id
    WHERE C.card_id = p_id;
END
$$ LANGUAGE plpgsql;

-- DROP      FUNCTION FN_CARD_RETRIEVE;