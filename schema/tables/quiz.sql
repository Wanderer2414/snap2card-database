CREATE    TABLE QUIZ (
          quiz_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          quiz_level TYPE_LEVEL_QUIZ NOT NULL                 ,
          quiz_type TYPE_QUIZ_TYPE NOT NULL                   ,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL
          );

-- DROP      TABLE QUIZ CASCADE;
CREATE    TABLE REVIEW_QUIZ (
          quiz_id INT PRIMARY KEY REFERENCES QUIZ (quiz_id),
          card_id INT REFERENCES CARD (card_id)
          );

-- DROP      TABLE REVIEW_QUIZ;
CREATE    TABLE QUES4A_QUIZ (
          quiz_id INT NOT NULL PRIMARY KEY REFERENCES QUIZ (quiz_id)         ,
          question_component INT NOT NULL REFERENCES COMPONENT (component_id),
          answer_component INT NOT NULL REFERENCES COMPONENT (component_id)  ,
          dummy1_component INT NOT NULL REFERENCES COMPONENT (component_id)  ,
          dummy2_component INT NOT NULL REFERENCES COMPONENT (component_id)  ,
          dummy3_component INT NOT NULL REFERENCES COMPONENT (component_id)  ,
          CONSTRAINT CK_QUES4A_COMPONENT_EASY_DIFFERENT CHECK (
          question_component <> answer_component
AND       question_component <> dummy1_component
AND       question_component <> dummy2_component
AND       question_component <> dummy3_component
AND       answer_component <> dummy1_component
AND       answer_component <> dummy2_component
AND       answer_component <> dummy3_component
AND       dummy1_component <> dummy2_component
AND       dummy1_component <> dummy3_component
AND       dummy2_component <> dummy3_component
          )
          );

-- DROP      TABLE QUES4A_COMPONENT CASCADE;
CREATE    TABLE FILLBLANK_QUIZ (
          quiz_id INT PRIMARY KEY REFERENCES QUES4A_QUIZ (quiz_id)                            ,
          question_component INT NOT NULL REFERENCES COMPONENT (component_id)                 ,
          answer_component INT NOT NULL REFERENCES COMPONENT (component_id)                   ,
          CONSTRAINT CK_FILLBLANK_QUIZ_DIFFERENT CHECK (question_component <> answer_component)
          );

-- DROP      TABLE FILLBLANK_QUIZ CASCADE;