CREATE    TABLE DAILY_LOG (
          account_id INT NOT NULL REFERENCES ACCOUNT (account_id),
          day DATE NOT NULL                                  ,
          card_learned INT NOT NULL DEFAULT 0                ,
          PRIMARY KEY (account_id, day)
          );
