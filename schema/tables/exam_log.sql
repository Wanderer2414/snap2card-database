CREATE    TABLE EXAM_LOG (
          log_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY    ,
          session_id INT NOT NULL REFERENCES SESSION (session_id),
          exam_id INT NOT NULL REFERENCES EXAM (exam_id)         ,
          score INT CHECK (score > 0)                            ,
          start_time TIMESTAMPTZ DEFAULT NOW() NOT NULL          ,
          end_time TIMESTAMPTZ CHECK (end_time > start_time)
          );

-- DROP      TABLE EXAM_LOG;
CREATE    TABLE EXAM_LOG_REVIEW_RESULT (
          log_id INT REFERENCES EXAM_LOG (log_id)        ,
          quiz_id INT REFERENCES QUIZ (quiz_id)          ,
          user_answer BOOLEAN                            ,
          date_created TIMESTAMPTZ NOT NULL DEFAULT NOW(),
          PRIMARY KEY (log_id, quiz_id)
          );