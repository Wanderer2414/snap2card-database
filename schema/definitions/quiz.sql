CREATE    TYPE TYPE_QUIZ_TYPE AS ENUM('REVIEW', 'QUES4A', 'FILLBLANK');

CREATE    TYPE TYPE_QUIZ_RESULT AS (
quiz_id TYPE_ID       ,
front_text TEXT       ,
back_text TEXT        ,
account_answer BOOLEAN,
result_score INT      ,
total_score INT
);

CREATE    TYPE TYPE_QUIZ_RESULT_INTERNAL AS (
quiz_id INT           ,
front_text TEXT       ,
back_text TEXT        ,
account_answer BOOLEAN,
result_score INT      ,
total_score INT
);