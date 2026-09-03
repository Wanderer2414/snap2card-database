CREATE    TABLE FILE (
          file_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          file_source TEXT GENERATED ALWAYS AS (
          GET_FILE_SOURCE (file_id, hash_code, file_name, file_type)
          ) STORED                                                   ,
          file_name TYPE_NAME_FILE NOT NULL                          ,
          hash_code CHAR(64) NOT NULL                                ,
          owner_id INT NOT NULL                                      ,
          file_type TYPE_FILE_TYPE NOT NULL                          ,
          date_created TIMESTAMPTZ DEFAULT NOW()                     ,
          FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)     ,
          CONSTRAINT UK_UNIQUE_FILE_DATA UNIQUE (file_name, hash_code)
          );

ALTER     TABLE ACCOUNT
ADD       CONSTRAINT FK_ACCOUNT_AVATAR FOREIGN KEY (account_avatar) REFERENCES FILE (file_id);