CREATE    TABLE ACCOUNT (
          account_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          account_name TYPE_NAME_ACCOUNT NOT NULL                ,
          account_password TYPE_PASSWORD_CRYPTED NOT NULL        ,
          date_created TIME DEFAULT NOW() NOT NULL
          );

-- DROP      TABLE ACCOUNT CASCADE;