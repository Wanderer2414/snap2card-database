CREATE
OR        REPLACE FUNCTION CATEGORY_TO_CARD_CATEGORIZE (p_card_id TYPE_ID, p_category_ids TYPE_ID[]) RETURNS VOID AS $$ 
DECLARE
    v_card INT        ;
    v_categories INT[] ;
BEGIN
    IF p_card_id IS NULL THEN
        RAISE EXCEPTION 'card id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_category_ids IS NULL THEN
        RAISE EXCEPTION 'category ids must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_card_id, 1, 4) <> 'CARD' THEN
        RAISE EXCEPTION 'invalid card id format' USING ERRCODE = '50006';
    END IF;

    IF EXISTS (SELECT 1 FROM unnest(p_category_ids) AS C(id) WHERE C.id IS NULL) THEN
        RAISE EXCEPTION 'category ids must not be null' USING ERRCODE = '50001';
    END IF;

    IF EXISTS (SELECT 1 FROM unnest(p_category_ids) AS C(id) WHERE SUBSTRING(C.id, 1, 4) <> 'CATE') THEN
        RAISE EXCEPTION 'invalid category id format' USING ERRCODE = '50006';
    END IF;

    v_card := FN_ID_CARD(p_card_id);
    IF NOT EXISTS (SELECT 1 FROM CARD WHERE card_id = v_card) THEN
        RAISE EXCEPTION 'card not found' USING ERRCODE = '50004';
    END IF;

    v_categories := ARRAY(SELECT FN_ID_CATEGORY(C.id) FROM unnest(p_category_ids) AS C(id));

    IF EXISTS (
        SELECT 1 FROM unnest(v_categories) AS C(id)
        WHERE NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = C.id)
    ) THEN
        RAISE EXCEPTION 'category not found' USING ERRCODE = '50004';
    END IF;

    PERFORM FN_CATEGORY_TO_CARD_CATEGORIZE(v_card, v_categories);
END $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION CARD_TO_CATEGORY_CATEGORIZE (p_category_id TYPE_ID, p_card_ids TYPE_ID[]) RETURNS VOID AS $$ 
DECLARE
    v_category INT  ;
    v_cards INT[]   ;
BEGIN
    IF p_category_id IS NULL THEN
        RAISE EXCEPTION 'category id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_card_ids IS NULL THEN
        RAISE EXCEPTION 'card ids must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_category_id, 1, 4) <> 'CATE' THEN
        RAISE EXCEPTION 'invalid category id format' USING ERRCODE = '50006';
    END IF;

    IF EXISTS (SELECT 1 FROM unnest(p_card_ids) AS C(id) WHERE C.id IS NULL) THEN
        RAISE EXCEPTION 'card ids must not be null' USING ERRCODE = '50001';
    END IF;

    IF EXISTS (SELECT 1 FROM unnest(p_card_ids) AS C(id) WHERE SUBSTRING(C.id, 1, 4) <> 'CARD') THEN
        RAISE EXCEPTION 'invalid card id format' USING ERRCODE = '50006';
    END IF;

    v_category := FN_ID_CATEGORY(p_category_id);
    IF NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = v_category) THEN
        RAISE EXCEPTION 'category not found' USING ERRCODE = '50004';
    END IF;

    v_cards := ARRAY(SELECT FN_ID_CARD(C.id) FROM unnest(p_card_ids) AS C(id));

    IF EXISTS (
        SELECT 1 FROM unnest(v_cards) AS C(id)
        WHERE NOT EXISTS (SELECT 1 FROM CARD WHERE card_id = C.id)
    ) THEN
        RAISE EXCEPTION 'card not found' USING ERRCODE = '50004';
    END IF;

    PERFORM FN_CARD_TO_CATEGORY_CATEGORIZE(v_category, v_cards);
END $$ LANGUAGE plpgsql;