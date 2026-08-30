CREATE    TABLE ACCOUNT_CARD_HAVE (
          account_id INT REFERENCES ACCOUNT (account_id) ,
          card_id INT REFERENCES CARD (card_id)          ,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL,
          PRIMARY KEY (account_id, card_id)
          );