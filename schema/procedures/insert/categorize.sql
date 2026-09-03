-- CREATE    TABLE CATEGORY_CARD_CONTAIN (
--           category_id INT REFERENCES CATEGORY (category_id),
--           card_id INT REFERENCES CARD (card_id)            ,
--           PRIMARY KEY (category_id, card_id)
--           );
CREATE
OR        REPLACE PROCEDURE PR_CATEGORY_TO_CARD_CATEGORIZE (p_card_id INT, p_category_ids INT[]) AS $$
BEGIN
    INSERT INTO CATEGORY_CARD_CONTAIN(category_id, card_id)
    SELECT C.category_id, p_card_id FROM unnest(p_category_ids) AS C(category_id)
    ON CONFLICT (category_id, card_id) DO NOTHING;

END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE PROCEDURE PR_CARD_TO_CATEGORY_CATEGORIZE (p_category_id INT, p_card_ids INT[]) AS $$
BEGIN
    INSERT INTO CATEGORY_CARD_CONTAIN(category_id, card_id)
    SELECT p_category_id, C.card_id FROM unnest(p_card_ids) AS C(card_id)
    ON CONFLICT (category_id, card_id) DO NOTHING;

END
$$ LANGUAGE plpgsql;