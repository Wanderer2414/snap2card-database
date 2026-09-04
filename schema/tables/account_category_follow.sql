CREATE    TABLE ACCOUNT_CATEGORY_FOLLOW (
          account_id INT REFERENCES ACCOUNT (account_id)                     ,
          category_id INT REFERENCES CATEGORY (category_id) ON DELETE CASCADE,
          mastery_score FLOAT                                                ,
          followed_date TIMESTAMPTZ DEFAULT NOW() NOT NULL                   ,
          PRIMARY KEY (account_id, category_id)
          );