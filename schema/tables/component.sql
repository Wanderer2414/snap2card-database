CREATE    TABLE COMPONENT (
          component_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY                  ,
          component_text TEXT                                                        ,
          owner_id INT NOT NULL                                                      ,
          date_created TIMESTAMPTZ DEFAULT NOW()                                      ,
          num_of_length INT GENERATED ALWAYS AS (count_words (component_text)) STORED,
          FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
          );

-- DROP      TABLE CONTENT CASCADE;