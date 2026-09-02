CREATE
OR        REPLACE FUNCTION FN_EXAM_REVIEW_RETRIEVE (p_exam_id INT) RETURNS TABLE (
          quiz_id INT            ,
          frontSide INT          ,
          backSide INT           ,
          date_created TIMESTAMPTZ
          ) AS $$ 
BEGIN
    RETURN QUERY
    SELECT RQ.quiz_id, C.frontSide_id, C.backSide_id, C.date_created FROM EXAM_QUIZ EQ
    JOIN REVIEW_QUIZ RQ ON EQ.exam_id = p_exam_id AND RQ.quiz_id = EQ.quiz_id
    JOIN CARD C ON RQ.card_id = C.card_id;
END $$ LANGUAGE plpgsql;

SELECT    *
FROM      FN_EXAM_REVIEW_RETRIEVE (4);