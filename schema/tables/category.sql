CREATE    TABLE CATEGORY (
          category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          category_name TYPE_NAME_CATEGORY UNIQUE NOT NULL
          );

CREATE    TABLE CATEGORY_CARD_CONTAIN (
          category_id INT REFERENCES CATEGORY (category_id),
          card_id INT REFERENCES CARD (card_id)            ,
          PRIMARY KEY (category_id, card_id)
          );