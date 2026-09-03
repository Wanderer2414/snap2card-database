CREATE    TABLE ACCOUNT_CARD_HAVE (
          account_id INT REFERENCES ACCOUNT (account_id)             ,
          card_id INT REFERENCES CARD (card_id)                      ,
          false_count INT NOT NULL DEFAULT 3 CHECK (false_count >= 3),
          true_count INT NOT NULL DEFAULT 0 CHECK (true_count >= 0)  ,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL            ,
          PRIMARY KEY (account_id, card_id)
          );