CREATE    TABLE FILE (
          file_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          file_source TEXT NOT NULL                            ,
          owner_id INT NOT NULL                                ,
          file_type TYPE_FILE_TYPE NOT NULL                    ,
          date_created TIMESTAMPTZ DEFAULT NOW()               ,
          FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
          );