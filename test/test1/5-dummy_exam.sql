DO        $$
DECLARE 
    r RECORD;
    session_id TYPE_ID;
    category_id TYPE_ID;
    exam_id TYPE_ID;
    log_id TYPE_ID;
BEGIN 
    SELECT    ACCOUNT_LOGIN ('tester@gmail.com', '1234') INTO session_id;
    SELECT    FN_CATEGORY_ID (C.category_id) INTO category_id
    FROM      CATEGORY C
    WHERE     C.category_name = 'ACTIONS';

    SELECT    EXAM_CREATE (category_id) INTO exam_id;
    SELECT    EXAM_START (session_id, exam_id) INTO log_id;

    FOR r IN
        SELECT *, row_number() over () as rn FROM EXAM_REVIEW_RETRIEVE(exam_id)
    LOOP
        CALL EXAM_LOG_REVIEW_RESULT (log_id, r.quiz_id, (r.rn % 2 = 0));
    END LOOP;

    CALL      EXAM_COMPLETED (log_id);

END;
$$;

DO        $$
DECLARE 
    r RECORD;
    session_id TYPE_ID;
    category_id TYPE_ID;
    exam_id TYPE_ID;
    log_id TYPE_ID;
BEGIN 
    SELECT    ACCOUNT_LOGIN ('tester@gmail.com', '1234') INTO session_id;
    SELECT    FN_CATEGORY_ID (C.category_id) INTO category_id
    FROM      CATEGORY C
    WHERE     C.category_name = 'ACTIONS';

    SELECT    EXAM_CREATE (category_id) INTO exam_id;
    SELECT    EXAM_START (session_id, exam_id) INTO log_id;

    FOR r IN
        SELECT *, row_number() over () as rn FROM EXAM_REVIEW_RETRIEVE(exam_id)
    LOOP
        CALL EXAM_LOG_REVIEW_RESULT (log_id, r.quiz_id, (r.rn % 3 = 0));
    END LOOP;

    CALL      EXAM_COMPLETED (log_id);
    CALL ACCOUNT_LOGOUT(SESSION_CHECK(session_id));

END;
$$