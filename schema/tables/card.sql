CREATE    TABLE CARD (
          card_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY                 ,
          frontside_id INT NOT NULL                                            ,
          backside_id INT NOT NULL                                             ,
          creator_id INT NOT NULL                                              ,
          date_created TIMESTAMP DEFAULT NOW() NOT NULL                        ,
          FOREIGN KEY (frontside_id) REFERENCES COMPONENT (component_id)       ,
          FOREIGN KEY (backside_id) REFERENCES COMPONENT (component_id)        ,
          FOREIGN KEY (creator_id) REFERENCES ACCOUNT (account_id)             ,
          CONSTRAINT CK_DIFFERENT_FRONT_BACK CHECK (frontside_id <> backside_id)
          );

-- DROP      TABLE CARD CASCADE;