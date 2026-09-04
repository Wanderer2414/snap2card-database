CREATE    TABLE EXAM (
          exam_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          exam_name TYPE_NAME_EXAM DEFAULT NULL               ,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL     ,
          exam_level TYPE_LEVEL_EXAM NOT NULL                 ,
          total_score INT CHECK (total_score > 0)
          );

CREATE    TABLE EXAM_CATEGORY_RELATED (
          exam_id INT REFERENCES EXAM (exam_id)                              ,
          category_id INT REFERENCES CATEGORY (category_id) ON DELETE CASCADE,
          PRIMARY KEY (exam_id, category_id)
          );

CREATE    TABLE EXAM_QUIZ (
          exam_id INT REFERENCES EXAM (exam_id),
          quiz_id INT REFERENCES QUIZ (quiz_id),
          PRIMARY KEY (exam_id, quiz_id)
          );