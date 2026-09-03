CREATE    TABLE CATEGORY (
          category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          owner_id INT                                              ,
          category_name TYPE_NAME_CATEGORY NOT NULL                ,
          numOfCard INT NOT NULL DEFAULT 0 CHECK (numOfCard >= 0)  ,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL          ,
          updated_time TIMESTAMPTZ DEFAULT NOW()                   ,
          FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)   ,
          CONSTRAINT UK_CATEGORY_OWNER_NAME UNIQUE (owner_id, category_name)
          );

CREATE    TABLE CATEGORY_CARD_CONTAIN (
          category_id INT REFERENCES CATEGORY (category_id),
          card_id INT REFERENCES CARD (card_id)            ,
          PRIMARY KEY (category_id, card_id)
          );