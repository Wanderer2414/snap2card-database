CREATE
OR        REPLACE FUNCTION FN_EXAM_CREATE (p_category_id INT) RETURNS INT AS $$ 
DECLARE
    v_exam_id INT;
    v_ids INT[];
BEGIN
    SELECT ARRAY(
        SELECT card_id FROM CATEGORY_CARD_CONTAIN WHERE category_id = p_category_id
    ) INTO v_ids;

    WITH cards AS (
        SELECT C.card_id, ROW_NUMBER() OVER () AS rn FROM unnest(v_ids) AS C(card_id)
        WHERE C.card_id NOT IN (
            SELECT card_id FROM REVIEW_QUIZ
        )
    )              ,
    inserted_id AS (
        INSERT INTO QUIZ(quiz_level, quiz_type)
        SELECT 'COMPREHENSION', 'REVIEW' FROM cards
        RETURNING quiz_id
    )      ,
    ids AS (
        SELECT quiz_id, ROW_NUMBER() OVER () AS rn FROM inserted_id
    )
    INSERT INTO REVIEW_QUIZ(quiz_id, card_id)
    SELECT quiz_id, card_id FROM ids
    JOIN cards USING (rn);

    INSERT INTO EXAM(exam_level, total_score) VALUES ('EASY', NULL)
    RETURNING exam_id INTO v_exam_id;

    INSERT INTO EXAM_CATEGORY_RELATED(exam_id, category_id) VALUES (v_exam_id, p_category_id) ON CONFLICT (v_exam_id, p_category_id) DO NOTHING;

    INSERT INTO EXAM_QUIZ 
    SELECT v_exam_id, C.quiz_id FROM REVIEW_QUIZ C
    WHERE C.card_id IN (SELECT * FROM unnest(v_ids));

    RETURN v_exam_id;
END $$ LANGUAGE plpgsql;