CREATE    TABLE CATEGORY (
          category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          category_name TYPE_NAME_CATEGORY UNIQUE NOT NULL
          );

CREATE    TABLE CATEGORY_CARD_CONTAIN (
          category_id INT REFERENCES CATEGORY (category_id),
          card_id INT REFERENCES CARD (card_id)            ,
          PRIMARY KEY (category_id, card_id)
          );

CREATE    TABLE ACCOUNT_CATEGORY_HAVE (
          account_id INT REFERENCES ACCOUNT (account_id)         ,
          category_id INT REFERENCES CATEGORY (category_id)      ,
          numOfCard INT NOT NULL CHECK (numOfCard >= 0) DEFAULT 0,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL        ,
          PRIMARY KEY (account_id, category_id)
          );