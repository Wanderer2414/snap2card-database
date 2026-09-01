-- CREATE    TABLE CATEGORY_CARD_CONTAIN (
--           category_id INT REFERENCES CATEGORY (category_id),
--           card_id INT REFERENCES CARD (card_id)            ,
--           PRIMARY KEY (category_id, card_id)
--           );
CREATE
OR        REPLACE PROCEDURE PR_CATEGORIZE (p_card_id INT, p_category_ids INT[]) AS $$
BEGIN
    INSERT INTO CATEGORY_CARD_CONTAIN(category_id, card_id)
    SELECT C.category_id, p_card_id FROM unnest(p_category_ids) AS C(category_id)
    ON CONFLICT (category_id, card_id) DO NOTHING;

END
$$ LANGUAGE plpgsql;