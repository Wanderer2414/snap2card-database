CREATE    TABLE CARD (
          card_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY                       ,
          frontside_id INT NOT NULL                                                  ,
          backside_id INT NOT NULL                                                   ,
          creator_id INT NOT NULL                                                    ,
          date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL                            ,
          FOREIGN KEY (frontside_id) REFERENCES COMPONENT (component_id)             ,
          FOREIGN KEY (backside_id) REFERENCES COMPONENT (component_id)              ,
          FOREIGN KEY (creator_id) REFERENCES ACCOUNT (account_id)                   ,
          CONSTRAINT CK_CARD_DIFFERENT_FRONT_BACK CHECK (frontside_id <> backside_id),
          CONSTRAINT CK_CARD_UNIQUE UNIQUE (frontside_id, backside_id)
          );

-- DROP      TABLE CARD CASCADE;