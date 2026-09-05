CREATE    TABLE ACCOUNT_CARD_HAVE (
          account_id INT REFERENCES ACCOUNT (account_id)             ,
          card_id INT REFERENCES CARD (card_id) ON DELETE CASCADE    ,
          false_count INT NOT NULL DEFAULT 1 CHECK (false_count >= 1),
          true_count INT NOT NULL DEFAULT 0 CHECK (true_count >= 0)  ,
          mastery_score FLOAT GENERATED ALWAYS AS
              (LEAST (true_count::float / (3 * false_count), 1)) STORED         ,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL            ,
          PRIMARY KEY (account_id, card_id)
          );