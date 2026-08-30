CREATE
OR        REPLACE FUNCTION FN_CARD_LIST (p_id INT) RETURNS TABLE (card_id INT, component_text TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT A.card_id, C.component_text FROM ACCOUNT_CARD_HAVE A 
    JOIN CARD CD ON A.card_id = CD.card_id
    JOIN COMPONENT C ON CD.frontside_id = C.component_id
    WHERE A.account_id = p_id;
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_CARD_LIST () RETURNS TABLE (card_id INT, component_text TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT A.card_id, C.component_text FROM ACCOUNT_CARD_HAVE A 
    JOIN CARD CD ON A.card_id = CD.card_id
    JOIN COMPONENT C ON CD.frontside_id = C.component_id;
END
$$ LANGUAGE plpgsql;