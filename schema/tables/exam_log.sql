CREATE    TABLE EXAM_LOG (
          log_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY    ,
          account_id INT NOT NULL REFERENCES ACCOUNT (account_id),
          exam_id INT NOT NULL REFERENCES EXAM (exam_id)         ,
          score INT CHECK (score > 0)                            ,
          start_time TIMESTAMP DEFAULT NOW() NOT NULL                 ,
          end_time TIMESTAMP CHECK (end_time > start_time)
          );

-- DROP      TABLE EXAM_LOG;