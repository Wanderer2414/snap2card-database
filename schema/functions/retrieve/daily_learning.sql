CREATE
OR        REPLACE FUNCTION FN_DAILY_LEARNED_CARDS (p_account_id INT, p_date DATE) RETURNS INT AS $$
BEGIN
    RETURN COALESCE(
        (SELECT DL.card_learned FROM DAILY_LOG DL WHERE DL.account_id = p_account_id AND DL.day = p_date),
        0
    );
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION FN_MONTHLY_LEARNED_CARDS (p_account_id INT) RETURNS TABLE (DAY DATE, card_count INT) AS $$
BEGIN
    RETURN QUERY
    SELECT d.day::DATE, COALESCE(
        (SELECT DL.card_learned FROM DAILY_LOG DL WHERE DL.account_id = p_account_id AND DL.day = d.day::DATE),
        0
    )::INT AS card_count
    FROM generate_series(
        DATE_TRUNC('month', CURRENT_DATE)::DATE,
        CURRENT_DATE                           ,
        '1 day'
    ) AS d(day);
END
$$ LANGUAGE plpgsql;