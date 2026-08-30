# Functions

## `FN_REQUEST_LOG_INSERT`

### Protocol

```sql
FN_REQUEST_LOG_INSERT(
    p_endpoint       VARCHAR(60),
    p_header         TEXT,
    p_body           TEXT,
    p_reponse_header TEXT,
    p_reponse_body   TEXT
) RETURNS INT
```

### SQL Call

```sql
SELECT FN_REQUEST_LOG_INSERT(
    '/api/card',
    '{ "content-type": "application/json" }',
    '{ "question": "1 + 1" }',
    '200 OK',
    '{ "answer": 2 }'
);
```