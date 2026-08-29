CREATE    TABLE EXAM (
          exam_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          date_created TIME DEFAULT NOW() NOT NULL            ,
          exam_level TYPE_LEVEL_EXAM NOT NULL                 ,
          total_score INT CHECK (total_score > 0)
          );

CREATE    TABLE EXAM_QUIZ (
          exam_id INT REFERENCES EXAM (exam_id),
          quiz_id INT REFERENCES QUIZ (quiz_id),
          PRIMARY KEY (exam_id, quiz_id)
          );